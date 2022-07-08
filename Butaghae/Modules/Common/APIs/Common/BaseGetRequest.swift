//
//  BaseGetRequest.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct BaseGetRequest<T: Codable> {
    private var path: String?
    private var query: T
    
    init(path: String? = nil, query: T) {
        self.path = path
        self.query = query
    }
    
    func getPath() -> String {
        if let path = self.path {
            return "/\(path)"
        } else {
            return ""
        }
    }
    
    func getQuery() -> T {
        return query
    }
}
