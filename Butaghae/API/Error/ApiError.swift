//
//  ApiError.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/04/29.
//

import Foundation

enum ApiError: Error {
    case ENCODING_ERROR
    case DECODING_ERROR
    case DATA_IS_NULL
    case JSON_PARSING_FAIL([String: Any], Data?)
    case RESPONSE_FAIL(String)
    case RESPONSE_DATA_IS_NULL(String?)
    
}
