//
//  User.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation
import CoreData

struct UserInfo {
    var manager: NSManagedObject?
    var phoneNumber: Int
    
    init(manager: NSManagedObject = NSManagedObject()) {
        self.manager = manager
        self.phoneNumber = manager.value(forKey: "phoneNumber") as? Int ?? 0
    }
}
