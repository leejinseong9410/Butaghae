//
//  Font.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit

struct Fonts {
    
    static func ultraLight(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .ultraLight)
    }
    
    static func thin(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .thin)
    }
    
    static func light(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .light)
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .regular)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .medium)
    }
    
    static func semibold(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .semibold)
    }
    
    static func heavy(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .heavy)
    }
    
    static func black(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .black)
    }
    
    static func bold(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .bold)
    }
    
}
