//
//  ApiError.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

enum ApiError: Error {
    case DATA_IS_NULL([String: Any], Data?)
    case JSON_PARSING_FAIL([String: Any], Data?)
    case RESPONSE_FAIL(String)
    case RESPONSE_DATA_IS_NULL(String?)
    case NETWORK_CONNECTION(String)
    case SERVER_ISSUE(String)
    case ACCESS_TOKEN_DENIND
}
