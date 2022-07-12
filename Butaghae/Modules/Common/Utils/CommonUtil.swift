//
//  CommonUtil.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import UIKit

class CommonUtil {
    
    enum UpdateType {
        case optional
        case required
        case none
    }
    
    /*
     * MARK: Check version
     */
    
    func checkUpdate(latestVersion: String, requireVersion: String) -> UpdateType {
        if isRequiredUpdate(requireVersion) { return .required }
        if isOptinalUpdate(latestVersion) { return .optional }
        return .none
    }
    
    func getVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "0.0.0" }
        
        return appVersion
    }
    
    func getBundleVersion() -> String {
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return "0" }
        
        return bundleVersion
    }
    
    func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
}

extension CommonUtil {
    
    func isRequiredUpdate(_ require: String) -> Bool {
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
        
        return versionToInt(version: require) > versionToInt(version: bundleVersion)
    }
    
    func isOptinalUpdate(_ latest: String) -> Bool {
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return false }
        
        return versionToInt(version: latest) > versionToInt(version: bundleVersion)
    }
    
    private func versionToInt(version: String) -> Int {
        let splitVersion = version.split(separator: ".")
        guard let major = Int(splitVersion[0]) else { return 0 }
        guard let minor = Int(splitVersion[1]) else { return 0 }
        guard let last = Int(splitVersion[2]) else { return 0 }
        
        return (major*10000) + (minor*100) + (last)
    }
    
}
