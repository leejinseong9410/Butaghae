//
//  BaseUserInfo.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

protocol BaseUserInfo {
    var accessToken: String? { get }
    var refreshToken: String? { get }
}
