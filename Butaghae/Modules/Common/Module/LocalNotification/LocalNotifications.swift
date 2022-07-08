//
//  LocalNotifications.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

protocol NotificationName {
    var name: Notification.Name { get }
}

enum LocalNotifications: String, NotificationName {
    case foreground
    case background
    case incomePushNotification
    case firebaseRDB
    case willTerminate
}
