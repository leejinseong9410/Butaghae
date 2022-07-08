//
//  JwtStorage.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

class JwtStorage {
    
    private let ud = UserDefaults.standard
    static let shared = JwtStorage()
    
    // JWT AccessToken
    @UserDefaultWrapper(key: "jwt_access_token", defaultValue: "")
    var accessToken: String {
        didSet {
            LogUtil.d(accessToken)
        }
    }
    
    // JWT RefreshToken
    @UserDefaultWrapper(key: "jwt_refresh_token", defaultValue: "")
    var refreshToken: String {
        didSet {
            LogUtil.d(refreshToken)
        }
    }
    
}

extension JwtStorage {
    
    func clear() {
        accessToken = ""
        refreshToken = ""
    }
    
}
