//
//  BaseResponse.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

protocol BaseResponse {
    var msg: String? { get }
    var code: Int? { get }
}
