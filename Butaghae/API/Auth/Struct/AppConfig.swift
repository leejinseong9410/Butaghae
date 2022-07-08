//
//  AppConfig.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct AppConfig: BaseResponse, Codable {
    var code: Int?
    var msg: String?
    let appConfig: Config?
}

struct Config: Codable {
    let appType: String?
    let created: String?
    let gpsCycle: Int?
    let id: String?
    let latestVersion: String?
    let minVersion: String?
    let updateCycle: Int?
    let updated: String?
}

struct AppConfig_Req: Codable {
    
}
