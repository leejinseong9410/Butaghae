//
//  AppDelegate.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/04/27.
//

import UIKit
import Firebase
import FirebaseMessaging
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var launchScreenView: UIView?
    var isFromLaunch: Bool = false
    
    private let appConfigModel = AppConfigApiModel()
    private let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // API Data를 가져올때 지연되는 시간에 대비한 LaunchScreenView
        setupLoadingView()
        
        // iOS 15 이후 TableView Top Padding 생기는 이슈 수정
        counteractiOSVersion()
        
        FirebaseApp.configure()
        // FCM
        setupFcmService(application)
        
        //Splash 넘겨주기..
        setupWindow()
        
        return true
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashVC()
        window?.makeKeyAndVisible()
    }
    
    // MARK: - iOS 15 View Setting
    
    private func counteractiOSVersion() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
}

extension AppDelegate {
    
    public func logout() {
        JwtStorage.shared.clear()
        UserSingletone.shared.userData.clear()
        
        window?.rootViewController?.removeFromParent()
        window?.rootViewController = UINavigationController(rootViewController: MainVC())
    }
    
    private func showErrorPopup(error: Error) {
        guard let vc = window?.rootViewController as? BaseVC else {
            return
        }
        vc.showNetworkAlert(error: error)
    }
    
    private func setupLoadingView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BaseVC()
        window?.makeKeyAndVisible()
        
        if let view = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()?.view {
            view.translatesAutoresizingMaskIntoConstraints = false
            launchScreenView = view
            
            if let rootView = window?.rootViewController?.view {
                rootView.addSubview(view)
                
                var constraints = [NSLayoutConstraint]()
                
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": view])
                constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": view])
                rootView.addConstraints(constraints)
            }
        }
    }
}

// MARK: Enviroment
extension AppDelegate {
    
    func observeChangeServer() {
        Environment.shared.serverDidChanged = { [weak self] callback in
            guard let topVC = self?.window?.rootViewController?.topMostViewController() as? BaseVC else {
                return
            }
            
            let title = "서버 스위칭"
            let message =
                """
                앱을 재실행 합니다
                
                기존 : \(callback.prev.rawValue)
                변경 : \(callback.new.rawValue)
                """
            
            SystemPopupManager().showAlert(vc: topVC,
                                           title: title,
                                           message: message,
                                           defaultAction: UIAlertAction(title: "확인",
                                                                        style: .destructive,
                                                                        handler: { _ in
                exit(0)
            }))
        }
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    // MARK: - FCM
    private func setupFcmService(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        application.registerForRemoteNotifications()
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        Messaging.messaging().token { [weak self] (token, error) in
            if let error = error {
                LogUtil.d("Error fetching remote instange ID: \(error)")
            } else if let token = token {
                LogUtil.d("Remote instance ID token: \(token)")
                
                if !UserdefaultsManager.shared.isSendServerDeviceToken {
                    // Server로 Token을 보낸 적이 없다면 Token Send
                    self?.sendToken(token)
                } else if UserdefaultsManager.shared.isSendServerDeviceToken &&
                            UserdefaultsManager.shared.deviceToken != token {
                    // Server로 Token을 보낸 적이 있으면서 갱신 된 Token이 저장되어 있는 Token과 다를 경우 갱신 토큰으로 재전송
                    self?.sendToken(token)
                }
            }
        }
    }
    
    private func sendToken(_ token: String?) {
        let req = AppAddToken_Req(tokenId: token)
        
        appConfigModel
        // 이름 받지 않기
            .postAppAddToken(req: req)
            .subscribe(onNext: { res in
                if res.code == 0 {
                    UserdefaultsManager.shared.deviceToken = token
                    UserdefaultsManager.shared.isSendServerDeviceToken = true
                }
            }, onError: { e in
                LogUtil.e("Token Register Error \(e)")
            })
            .disposed(by: disposeBag)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {
            return
        }
        
        LogUtil.i("Firebase registration token: \(token)")
        
        let dataDict: [String: String] = ["token": token]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    // FCM Input
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        LogUtil.i(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        LogUtil.i(" user info \(userInfo)")
        //AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        LogUtil.e("Unable to register for remote notifications: \(error)")
    }
    
    // Open Deeplinks
    // Open URI-scheme for iOS 8 and below
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        //AppsFlyerLib.shared().continue(userActivity, restorationHandler: restorationHandler)
        return true
    }
    
    // Open URI-scheme for iOS 9 and above
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    // Report Push Notification attribution data for re-engagements
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //AppsFlyerLib.shared().handleOpen(url, options: options)
        return true
    }
    
    // Reports app open from deep link for iOS 10 or later
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       //AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        LogUtil.i(notification.request.content.userInfo)
        touchPushNotification(info: notification.request.content.userInfo)
        completionHandler([[.badge, .sound]])
    }
    
    // Background, Touch Action
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        LogUtil.i(response.notification.request.content.userInfo)
        touchPushNotification(info: response.notification.request.content.userInfo,
                              isUserAction: true,
                              isFromLaunch: isFromLaunch)
        completionHandler()
    }
    
    private func touchPushNotification(info: [AnyHashable: Any], isUserAction: Bool = false, isFromLaunch: Bool = false) {
        guard let info = info as? [String: Any] else { return }
        
        do {
            guard let notificationItem = try? JsonUtil().decodeWithSerialization(NotificationItem.self, info) else { return }
            
            if isUserAction && isFromLaunch {
                UserSingletone.shared.notificationItem = notificationItem
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.isFromLaunch = false
            } else if isUserAction {
                PushNotificationManager.shared.presentLink(item: notificationItem)
            }
        }
    }
    
}
