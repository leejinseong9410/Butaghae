//
//  JwtResponse.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

typealias JwtResponse = ((_ isSuccess: Bool, _ data: Data?, _ error: Error?) -> ())
