//
//  LocalNotificationManager.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

class LocalNotificationManager {
    
    static let shared = LocalNotificationManager()
    private let notificationCenter = NotificationCenter.default
    
    func add(target: Any, selector: Selector, name: NSNotification.Name, object: Any? = nil) {
        notificationCenter.addObserver(target,
                                       selector: selector,
                                       name: name,
                                       object: object)
    }
    
    func post(name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        notificationCenter.post(name: name,
                                object: object,
                                userInfo: userInfo)
    }
    
    func remove(target: Any, name: NSNotification.Name, object: Any? = nil) {
        notificationCenter.removeObserver(self,
                                          name: name,
                                          object: object)
    }
    
    func removeAll(target: Any) {
        notificationCenter.removeObserver(target)
    }
    
}
