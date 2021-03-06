//
//  Strings+Extensions.swift
//  sdk
//
//  Created by Sergey Iskhakov on 16.09.2020.
//  Copyright © 2020 Cloudpayments. All rights reserved.
//

import Foundation

extension String {
    static let bundleName = "CloudpaymentsSdkResources"
    static let errorWord = "Ошибка"
    static let informationWord = "Информация"
    
    static let RUBLE_SIGN = "\u{20BD}"
    static let EURO_SIGN = "\u{20AC}"
    static let GBP_SIGN = "\u{00A3}"
    
    static let tipsToCardSegue = "TipsToCardSegue"
    static let toResultSegue = "ToResultSegue"
    static let unwindToTipsSegue = "unwindToMainSegue"
}

extension String {
    public func formattedPhoneNumber() -> String {
        return self.phoneNumber().formattedString(mask: "+7 (XXX) XXX-XX-XX", ignoredSymbols: "7")
    }
    
    public func phoneNumber() -> String {
        return onlyNumbers()
    }
    
    func formattedCardNumber() -> String {
        let mask = "XXXX XXXX XXXX XXXX XXX"
        return self.onlyNumbers().formattedString(mask: mask, ignoredSymbols: nil)
    }
    
    func clearCardNumber() -> String {
        return self.onlyNumbers()
    }
    
    func formattedCardExp() -> String {
        let mask = "XX/XX"
        return self.onlyNumbers().formattedString(mask: mask, ignoredSymbols: nil)
    }
    
    func cleanCardExp() -> String {
        return self.onlyNumbers()
    }

    func formattedCardCVV() -> String {
        let mask = "XXX"
        return self.onlyNumbers().formattedString(mask: mask, ignoredSymbols: nil)
    }
    
    func cardNumberIsValid() -> Bool {
        let number = self.onlyNumbers()
        guard number.count >= 16 && number.count <= 19 else {
            return false
        }
        
        var digits = number.map { Int(String($0))! }
        stride(from: digits.count - 2, through: 0, by: -2).forEach { i in
            var value = digits[i] * 2
            if value > 9 {
                value = value % 10 + 1
            }
            digits[i] = value
        }
        
        let sum = digits.reduce(0, +)
        return sum % 10 == 0
    }

    
    func formattedString(mask: String, ignoredSymbols: String?) -> String {
        let cleanString = self.onlyNumbers()
        
        var result = ""
        var index = cleanString.startIndex
        for ch in mask {
            if index == cleanString.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanString[index])
                index = cleanString.index(after: index)
            } else {
                result.append(ch)
                
                if ignoredSymbols?.contains(ch) == true {
                    index = cleanString.index(after: index)
                }
            }
        }
        return result
    }
    
    private func onlyNumbers() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
