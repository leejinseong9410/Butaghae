//
//  UIButton + module.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit

extension UIButton {
    
    func moveImageLeftTextCenter(imagePadding: CGFloat = 30.0) {
        guard let imageViewWidth = imageView?.frame.width else { return }
        guard let titleLabelWidth = titleLabel?.intrinsicContentSize.width else { return }
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imagePadding - imageViewWidth / 2, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: (bounds.width - titleLabelWidth) / 2 - imageViewWidth, bottom: 0.0, right: 0.0)
    }
    
    func moveImageRightTextCenter(imagePadding: CGFloat = 30.0) {
        guard let imageViewWidth = imageView?.frame.width else { return }
        guard let titleLabelWidth = titleLabel?.intrinsicContentSize.width else { return }
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: bounds.width - imageViewWidth / 2 - imagePadding, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: bounds.width - imageViewWidth - imagePadding - titleLabelWidth, bottom: 0.0, right: 0.0)
    }
    
    func moveImageRightTextLeft(textPadding: CGFloat = 20.0, imagePadding: CGFloat = 20.0) {
        guard let imageViewWidth = imageView?.frame.width else { return }
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: bounds.width - imageViewWidth - imagePadding, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: textPadding, bottom: 0.0, right: imagePadding * 2 + imageViewWidth)
    }
    
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
