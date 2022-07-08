//
//  UIViewController + Extension.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import UIKit

extension UIViewController {

    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
    
    func show(viewController: UIViewController) {
        willMove(toParent: self)
        addChild(viewController)
        
        view.addSubview(viewController.view)
        
        didMove(toParent: self)
        view.bringSubviewToFront(viewController.view)
    }
    
}

extension UIViewController {
    
    func topMostViewController() -> UIViewController? {
        if presentedViewController == nil {
            return self
        }
        
        if let navigation = presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        
        if let tab = presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        return presentedViewController?.topMostViewController()
    }
    
}
