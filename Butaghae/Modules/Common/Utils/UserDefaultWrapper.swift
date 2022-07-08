//
//  UserDefaultWrapper.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    
    let key: String
    let storage: UserDefaults
    let defaultValue: T
    
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set {
            self.storage.set(newValue, forKey: self.key)
            storage.synchronize()
        }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
}
