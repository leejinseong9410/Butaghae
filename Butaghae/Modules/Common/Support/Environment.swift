//
//  Environment.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

enum EnvironmentType: String {
    case QA = "QA(Staging)"
    case RELEASE = "Release"
    case DEVELOPMENT = "Development"
    case `default`
}

class Environment {
    
    typealias ServerChangedInfo = (prev: EnvironmentType, new: EnvironmentType)
    
    static let shared: Environment = Environment()
    
    public var serverDidChanged: ((ServerChangedInfo) -> ())?
    
    private var nowEnviromentType: EnvironmentType {
        if let prefrence = UserDefaults.standard.value(forKey: plistSavedAppEnvUserDefaultsKey) as? String,
           let preferenceType = EnvironmentType(rawValue: prefrence) {
            return preferenceType
        } else {
            return .DEVELOPMENT
        }
    }
    
    private var prevEnviromentType: EnvironmentType = .default
    private let plistSavedAppEnvUserDefaultsKey = "app_server_preference_settings"
    
    public func getServerBaseUrl(serverBaseUrls: ServerBaseUrls, bundleVersion: String) -> String {
        let bundleVersionToInt = Int(bundleVersion) ?? 1
        let isRelease = (bundleVersionToInt % 2) == 0
        
        if isRelease {
            return serverBaseUrl(type: .RELEASE,
                                 urls: serverBaseUrls)
        } else {
            return serverBaseUrl(type: nowEnviromentType,
                                 urls: serverBaseUrls)
        }
    }
    
    private func serverBaseUrl(type: EnvironmentType, urls: ServerBaseUrls) -> String {
        let url: String
        
        switch type {
        case .DEVELOPMENT, .default:
            url = urls.dev
        case .QA:
            url = urls.staging
        case .RELEASE:
            url = urls.release
        }
        
        prevEnviromentType = type
        
        LogUtil.i(
            """
            The app enviroment type : \(type.rawValue)
            The app base url : \(url)
            """
        )
        
        return url
    }
    
    public func checkServerChanged() {
        guard let _serverDidChanged = serverDidChanged,
              prevEnviromentType != nowEnviromentType,
              ![EnvironmentType.default, EnvironmentType.RELEASE].contains(prevEnviromentType) else {
            return
        }
        
        _serverDidChanged((prevEnviromentType, nowEnviromentType))
    }
    
}
