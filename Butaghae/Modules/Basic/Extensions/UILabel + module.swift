//
//  UILabel + module.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit

extension UILabel {
    
    open override var bounds: CGRect {
        didSet {
            adjustsFontSizeToFitWidth = true
        }
    }
    
    func setLineSpacing(value: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = value
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                         value: style,
                                         range: NSRange(location: 0, length: attributeString.length))
            self.attributedText = attributeString }
    }
    
}
