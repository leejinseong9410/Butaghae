//
//  Colors.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import UIKit

struct Colors {
    
    static func achromatic(color: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: color/255, green: color/255, blue: color/255, alpha: alpha)
    }
    
}
