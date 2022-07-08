//
//  PrefixManager.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct PrefixManager {
    
    private static let commonUtil = CommonUtil()
    
    // MARK: - Mobile Server
    static var MOBILE_SERVER_BASE_URL: String {
        get {
            return Environment.shared.getServerBaseUrl(serverBaseUrls: Targets.getTarget().getServerBaseUrl(),
                                                       bundleVersion: commonUtil.getBundleVersion())
        }
    }
    
    // MARK: - Mobile Image Server
    static var MOBILE_IMAGE_SERVER_BASE_URL: String {
        get {
            return Environment.shared.getServerBaseUrl(serverBaseUrls: Targets.getTarget().getImageServerBaseUrl(),
                                                       bundleVersion: commonUtil.getBundleVersion())
        }
    }
}

extension PrefixManager {
    
    static let TERMS_BASE_URL                   = ""
    
    static let APP_CONFIG                       = ""
    static let APP_VERSION                      = ""
    static let APP_ADDAPP                       = ""
    static let APP_FCMSEND                      = ""
    
    // MARK: - NAVER OPEN API
    static let NAVER_API_CLIENT_ID              = ""
    static let NAVER_API_CLIENT_SECRET          = ""
    
    // MARK: - SK OPEN API
    static let SK_API_PROJECT_KEY               = ""
    static let SK_API_SECRET_KEY                = ""
    
    // MARK: - User
    
    static let MOBILE_USER                      = ""
    static let APP_LOGOUT                       = ""
    static let APP_LOGIN                        = ""
    static let APP_LOGIN_SENDCODE               = ""
    static let APP_LOGIN_VERIFYCODE             = ""
    static let APP_REGISTER                     = ""
    static let APP_WITHDRAW                     = ""
    static let ACCESS_TOKEN_REISSUE             = ""
    static let TERMS_LIST                       = ""
    
}
