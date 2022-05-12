//
//  User.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation

struct UserInfoRes: Codable {
    var userInfo: UserInfo?
}

struct UserInfo: Codable {
    var phoneNumber: String?
    var userId: String?
}
