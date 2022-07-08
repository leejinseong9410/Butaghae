//
//  UserSingletone.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

class UserSingletone {
    static let shared = UserSingletone()
    
    var appVersion: AppVersion? {
        didSet {
            LogUtil.d(appVersion ?? "")
        }
    }
    
    var notificationItem: NotificationItem? = nil { didSet { LogUtil.d(notificationItem ?? "") } }
    var isProcessOnboarding: Bool = false
    var userData = UserData() { didSet { LogUtil.d(self) } }
}

class UserData: ReflectedStringConvertible {
    var userInfo: UserInfo? {
        didSet {
            LogUtil.d(self)
        }
    }
    
    func clear() {
        userInfo = nil
    }
    
}
