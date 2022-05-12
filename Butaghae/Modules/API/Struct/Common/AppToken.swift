//
//  AppToken.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation

struct AppToken: Codable {
    var msg: String?
    var code: Int?
}

struct AppToken_Req: Codable {
    let tokenId: String?
}
