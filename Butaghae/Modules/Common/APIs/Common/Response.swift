//
//  Response.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct Response {
    let code: Int?
    let msg: String?
    let data: Any?
    
    init(code: Int?, msg: String?, data: Any? = nil) {
        self.code = code
        self.msg = msg
        self.data = data
    }
}
