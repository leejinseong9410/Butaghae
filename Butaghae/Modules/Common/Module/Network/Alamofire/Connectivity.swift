//
//  Connectivity.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return self.sharedInstance.isReachable
    }
}
