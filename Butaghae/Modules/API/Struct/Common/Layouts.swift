//
//  Layouts.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/09.
//

import Foundation
import UIKit

struct Layouts {
    
    static let BOTTOM_BUTTON_HEIGHT: CGFloat = 54.0
    static let GUIDE_LABEL_HEIGHT: CGFloat = 50.0
    static let HELP_BUTTON_HEIGHT: CGFloat = 50.0
    static let DROPDOWN_HEIGHT: CGFloat = 55.0
    static let MAIN_BARRIER_INFO_VIEW_HEIGHT: CGFloat = 118.0
    static let SERVICE_BOTTOM_BUTTON_HEIGHT: CGFloat = 56.0
    static let CONTAINER_BOTTOM_BUTTON_HEIGHT: CGFloat = 92.0
    
    static var TEXT_FIELD_HEIGHT: CGFloat {
        get {
            return UIDevice.isScreenSize_4_inch() ? 30.0 : 37.0
        }
    }
    
    static var SAFEAREA_INSETS: UIEdgeInsets? {
        get {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets
        }
    }
    
}
