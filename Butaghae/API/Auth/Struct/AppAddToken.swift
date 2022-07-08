//
//  AppAddToken.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct AppAddToken: BaseResponse, Codable {
    var msg: String?
    var code: Int?
}

struct AppAddToken_Req: Codable {
    let tokenId: String?
}
