//
//  Target.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

typealias ServerBaseUrls = (dev: String, staging: String, release: String)

/*
 * 개발, 운영 서버 스위칭
 * 하나의 프로젝트에서 다양한 Target 설정을 통해 다양한 App 빌드 가능
 * Targets case 설정, URLs 설정 으로 사용 가능
 */
enum Targets: String {
    case a = "a"
    case b = "b"
    
    static func getTarget() -> Targets {
        guard let bundleId = Bundle.main.bundleIdentifier,
              let target = self.init(rawValue: bundleId) else {
            fatalError("\(#function) Target 추가 후 사용!!")
        }
        
        return target
    }
    
    func getAppId() -> String {
        switch self {
        case .a:
            return "a"
        case .b:
            return "b"
            
        }
    }
    
    func getServerBaseUrl() -> ServerBaseUrls {
        switch self {
        case .a:
            return (dev: "dev",
                    staging: "stag",
                    release: "rele")
        case .b:
            return (dev: "dev",
                    staging: "stag",
                    release: "rele")
        }
    }
        
        func getImageServerBaseUrl() -> ServerBaseUrls {
            switch self {
            case .a:
                return (dev: "",
                        staging: "",
                        release: "")
            default:
                return (dev: "",
                        staging: "",
                        release: "")
            }
        }
        
        func getStoreLink() -> String {
            switch self {
            case .a:
                return ""
            case .b:
                return ""
                
            }
        }
        
        func getAccessDenindCode() -> Int {
            switch self {
            default: return -1002
            }
        }
        
        var isUseJWT: Bool {
            switch self {
            case .a:
                return true
            default:
                return false
            }
        }
}

