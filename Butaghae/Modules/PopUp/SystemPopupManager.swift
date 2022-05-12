//
//  d.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit
import Toast_Swift

class SystemPopupManager {
    
    /**
     * MARK: Alert
     */
    
    func showAlert(vc: UIViewController,
                   style: UIAlertController.Style = .alert,
                   title: String?,
                   message: String?,
                   defaultAction: UIAlertAction,
                   destructiveAction: UIAlertAction? = nil,
                   cancelAction: UIAlertAction? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if let action = destructiveAction { alert.addAction(action) }
        if let action = cancelAction { alert.addAction(action) }
        alert.addAction(defaultAction)
        
        vc.view.endEditing(true)
        vc.present(alert, animated: true, completion: nil)
    }
    
    /**
     * MARK: Toast
     */
    
    func showToast(vc: UIViewController,
                   message : String?,
                   withDuration duration: TimeInterval = 2.0,
                   position: ToastPosition = .center,
                   _ completion: ((_ didTap: Bool) -> Void)? = nil) {
        var style = ToastStyle()
        style.messageAlignment = NSTextAlignment.center
        
        Vibration.success.vibrate()
        
        DispatchQueue.main.async {
            if let vc = vc as? BasicVC {
                vc.contentView.makeToast(message,
                                         duration: duration,
                                         position: position,
                                         title: nil,
                                         image: nil,
                                         style: style, completion: completion)
            } else {
                vc.view.makeToast(message,
                                  duration: duration,
                                  position: position,
                                  title: nil,
                                  image: nil,
                                  style: style, completion: completion)
            }
        }
    }
    
    func makeAction(title: String? = "확인",
                    style: UIAlertAction.Style = .default,
                    completion: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        
        return UIAlertAction(title: title,
                             style: style,
                             handler: completion)
    }
    
    func makeCancelAction(title: String? = "취소",
                          style: UIAlertAction.Style = .cancel,
                          completion: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        
        return UIAlertAction(title: title,
                             style: style,
                             handler: completion)
    }
}
