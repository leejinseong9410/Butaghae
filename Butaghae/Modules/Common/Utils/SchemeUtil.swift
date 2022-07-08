//
//  SchemeUtil.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import UIKit

class SchemeUtil {
    
    func open(link: String, completion: @escaping (Bool) -> ()) {
        if let url = URL(string: link),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { isSuccess in
                completion(isSuccess)
            })
        } else {
            completion(false)
        }
    }
    
}
