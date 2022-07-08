//
//  ArrayEncoding.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import Alamofire

struct ArrayEncoding: ParameterEncoding {
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
        return request
    }
    
}
