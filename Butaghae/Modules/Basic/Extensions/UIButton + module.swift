//
//  UIButton + module.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation

import UIKit

extension UIButton {

    func setTitle(text: String?) {
        setTitle(text, for: .normal)
        setTitle(text, for: .highlighted)
    }
    
    func setTitleColor(color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .highlighted)
    }
    
    func setImage(images: (normal: UIImage?, highlighted: UIImage?)) {
        setImage(images.normal, for: .normal)
        setImage(images.highlighted, for: .highlighted)
    }
    
}
