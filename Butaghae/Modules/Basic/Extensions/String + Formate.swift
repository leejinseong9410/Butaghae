//
//  String + Formate.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation

extension String {
    
    func toPhoneNumberFormatted() -> String {
        let cleanPhoneNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX-XXXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
}
