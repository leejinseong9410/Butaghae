//
//  UserdefaultsManager.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation

class UserdefaultsManager {
    
    private let ud = UserDefaults.standard
    static let shared = UserdefaultsManager()
    
    private let KEY_SEND_SERVER_DEVICE_TOKEN = "send_server_device_token"
    var isSendServerDeviceToken: Bool {
        get {
            return ud.bool(forKey: KEY_SEND_SERVER_DEVICE_TOKEN)
        }
        set {
            ud.set(newValue, forKey: KEY_SEND_SERVER_DEVICE_TOKEN)
            ud.synchronize()
        }
    }
    
    private let KEY_DEVICE_TOKEN = "device_token"
    var deviceToken: String? {
        get {
            return ud.string(forKey: KEY_DEVICE_TOKEN)
        }
        set {
            guard let s = newValue else {
                return
            }
            ud.set(s, forKey: KEY_DEVICE_TOKEN)
            ud.synchronize()
        }
    }
    
}
