//
//  UIView + module.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit

extension UIView {

    func setShadow(shadowColor: UIColor,
                   offSet: CGSize,
                   opacity: Float,
                   shadowRadius: CGFloat,
                   cornerRadius: CGFloat,
                   corners: UIRectCorner,
                   fillColor: UIColor = .white) {
        if let firstIndex = layer.sublayers?.firstIndex(where: {
            return $0 is CAShapeLayer
        }) {
            layer.sublayers?.remove(at: firstIndex)
        }
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
}
