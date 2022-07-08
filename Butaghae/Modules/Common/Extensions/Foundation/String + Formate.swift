//
//  String + Formate.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit

extension String {
    
    var isNotEmpty: Bool {
        get {
            return self.count > 0
        }
    }
    
    // convert to Double
    func toDouble() -> Double? {
        return Double(self)
    }
    
}

extension String {
    func toCustomMaskingFormatted(to mask: String) -> String {
        let cleanNumber = components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
        var result = ""
        var index = cleanNumber.startIndex
        for ch in mask where index < cleanNumber.endIndex {
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else if ch == "●" {
                result.append("●")
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func toCustomNumberFormatted(to mask: String) -> String {
        let cleanPhoneNumber = components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
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
    
    func toNumberFormatted() -> String {
        var result: String = ""
        let characters = Array(self.replacingOccurrences(of: ",", with: "").reversed())
        stride(from: 0, to: characters.count, by: 3).forEach {
            result += String(characters[$0..<min($0+3, characters.count)])
            if $0+3 < characters.count {
                result += ","
            }
        }
        return String(result.reversed())
    }
    
    func toCardNumberFormatted() -> String {
        var result: String = ""
        let characters = Array(self.replacingOccurrences(of: "-", with: "").reversed())
        stride(from: 0, to: characters.count, by: 4).forEach {
            result += String(characters[$0..<min($0+4, characters.count)])
            if $0+4 < characters.count {
                result += "-"
            }
        }
        return String(result.reversed())
    }
    
    func toKiloMeterFormatted() -> String {
        guard let i = Int(self) else { return "" }
        let k = i/1000
        let m = i%1000/100
        
        return String(k) + "." + String(m)
    }
    
    func toMinuteFormatted() -> String {
        guard let i = Int(self) else { return "" }
        return String(i/60)
    }
    
}

//MARK: html
extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

//MARK: 다국어
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
    
}

// MARK: - 크기 계산
extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

// MARK: - base64
extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

// MARK: - EndPoint
// URL Formatting
extension String {
    func endPointFormatted(_ arguments: CVarArg...) -> Self {
        return String(format: self, arguments: arguments)
    }
}

