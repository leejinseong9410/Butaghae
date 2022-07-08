//
//  JwtReissue.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct JwtReissue: Codable, BaseResponse {
    var msg: String?
    var code: Int?
    let accessToken: String?
    let refreshToken: String?
}
