//
//  AppVersion.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct AppVersion: BaseResponse, Codable {
    var msg: String?
    var code: Int?
    let latestVersion: String?          // 최대 버전
    let minVersion: String?             // 최소 버전
}

struct AppVersion_Req: Codable {
    
}
