//
//  UserInfo.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct UserInfoRes: BaseResponse, Codable {
    var msg: String?
    var code: Int?
    var userInfo: UserInfo?
}

struct UserInfo: Codable {
    var phoneNo: String?
    var userId: String?
}

struct UserInfo_Req: Codable { }
