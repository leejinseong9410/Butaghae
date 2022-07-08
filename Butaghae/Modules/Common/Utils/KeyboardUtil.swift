//
//  KeyboardUtil.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import UIKit

class KeyboardUtil: NSObject {
    
    static var serviceSingleton = KeyboardUtil()
    var measuredSize: CGRect = CGRect.zero
    
    /*
     * 키보드 사이즈 - 자동완성 단어 노출 높이
     */
    @objc class func keyboardHeight() -> CGFloat {
        let keyboardSize = KeyboardUtil.keyboardSize()
        var completionWordHeight: CGFloat = 0
        
        if #available(iOS 13.0, *) {
            completionWordHeight = UIDevice.current.screenType == .iPhones_5_5s_5c_SE
                ? 34.0 // iPhones_5_5s_5c_SE
                : (UIDevice.current.screenType == .iPhones_6_6s_7_8)
                ? 0.0 // iPhones_6_6s_7_8
                : 30.0 // else
        } else {
            completionWordHeight = UIDevice.current.screenType == .iPhones_5_5s_5c_SE
                ? 34.0 // iPhones_5_5s_5c_SE
                : (UIDevice.current.screenType == .iPhones_6_6s_7_8)
                ? 40.0 // iPhones_6_6s_7_8
                : 30.0 // else
        }
        
        return keyboardSize.size.height - completionWordHeight
    }
    
    @objc class func keyboardSize() -> CGRect {
        return serviceSingleton.measuredSize
    }
    
    private func observeKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(self.keyboardChange), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func observeKeyboard() {
        let field = UITextField()
        UIApplication.shared.windows.first?.addSubview(field)
        field.becomeFirstResponder()
        field.resignFirstResponder()
        field.removeFromSuperview()
    }
    
    @objc private func keyboardChange(_ notification: Notification) {
        guard measuredSize == CGRect.zero, let info = notification.userInfo,
            let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        
        measuredSize = value.cgRectValue
    }
    
    override init() {
        super.init()
        observeKeyboardNotifications()
        observeKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
