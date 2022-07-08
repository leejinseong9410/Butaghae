//
//  RawRepresentable + Extension.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

extension RawRepresentable where RawValue == String, Self: NotificationName {
    
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
    
}
