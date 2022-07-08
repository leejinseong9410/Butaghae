//
//  PushNotificationManager.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import UserNotifications
import UIKit

struct PushNotification {
    var id: String
    var title: String
    var body: String
    var datetime: DateComponents?
}

enum FcmType: String, NotificationName {
    case appstore
}


class PushNotificationManager {
    
    static let shared = PushNotificationManager()
    private var notifications = [PushNotification]()
    
    func push(key: String, title: String, body: String) {
        notifications = [
            PushNotification(id: key, title: title, body: body, datetime: nil)
        ]
        schedule()
    }

}

extension PushNotificationManager {
    
    private func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }

    private func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }

    private func scheduleNotifications() {
        for notification in notifications {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.body     = notification.body
            content.sound    = .default

            var request: UNNotificationRequest
            if let datetime = notification.datetime {
                let trigger = UNCalendarNotificationTrigger(dateMatching: datetime, repeats: false)
                request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            } else {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            }

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
    
    func presentLink(item: NotificationItem) {
        // https://auto-jira.atlassian.net/wiki/spaces/MOB/pages/709329128/v.1.7.0+FCM
        if let link = item.url {
            SchemeUtil().open(link: link) { isSuccess in
                LogUtil.d(isSuccess)
            }
        } else {
            if let url = item.aps.alert?.body,
               url.contains("://") {
                SchemeUtil().open(link: url) { isSuccess in
                    LogUtil.d(isSuccess)
                }
            }
            switch FcmType(rawValue: item.fcmType ?? "") {
            case .appstore:
                SchemeUtil().open(link: item.aps.alert?.body ?? "") { isSuccess in
                    LogUtil.d(isSuccess)
                }
            default:
                break
            }
        }
        
        UserSingletone.shared.notificationItem = nil
    }
    
}
