//
//  NotificationItem.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

struct NotificationItem: Codable {
    var aps: Aps
    var url: String?
    var fcmType: String?
    var timeStamp: String?          // "yyyy-MM-dd HH:mm:ss"
}

struct Aps: Codable {
    var alert: Alert?
    var category: String?
}

struct Alert: Codable {
    var body: String?
    var title: String?
}
