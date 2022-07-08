//
//  BasicVC.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/04/27.
//

import Foundation
import UIKit
import SnapKit
import Then

typealias ErrorInfo<T> = (error: Error, type: T?)
typealias ApiInfo<T> = (response: Response, type: T?)

class BaseVC: UIViewController {
    
    lazy var layoutGuideView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        
        return v
    }()
    
    lazy var customTopNavigationBarView: CustomNavigationBarView = { [weak self] in
        let v = CustomNavigationBarView()
        
        v.leftImageButton.isHidden = !topAppBarShowLeftBtn()
        v.leftImageButton.setImage(images: topAppBarLeftBtnImage())
        v.leftImageButton.setTitle(text: topAppBarLeftBtnText())
        v.leftImageButton.setTitleColor(color: topAppBarLeftBtnTextColor())
        v.leftImageButton.addTarget(self, action: #selector(navigationLeftButtonDidTapped), for: .touchDown)
        
        v.rightImageButton.isHidden = !topAppBarShowRightBtn()
        v.rightImageButton.setImage(images: topAppBarRightBtnImage())
        v.rightImageButton.setTitle(text: topAppBarRightBtnText())
        v.rightImageButton.setTitleColor(color: topAppBarRightBtnColor())
        v.rightImageButton.addTarget(self, action: #selector(navigationRightButtonDidTapped), for: .touchDown)
        
        v.titleLabel.isHidden = !topAppBarShowTitle()
        v.titleLabel.text = topAppBarTitleText()
        v.titleLabel.textColor = topAppBarTitleTextColor()
        v.titleLabel.font = topAppBarTitleTextFont()
        v.titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigationTitleDidTapped)))
        
        v.titleImageView.isHidden = !topAppBarShowImage()
        v.titleImageView.image = topAppBarTitleImage()
        
        v.bottomBorderLine.backgroundColor = topAppBarBottomBorderLineColor()
        
        v.isHidden = !topAppBarIsShow()
        v.backgroundColor = topAppBarBgColor()
        
        return v
    }()
    
    lazy var contentView: UIView = { [weak self] in
        let v = UIView()
        v.backgroundColor = self?.contentViewBgColor() ?? .white
        
        return v
    }()
    
    public let systemPopupManager = SystemPopupManager()
    public let API_TIMEOUT = 60 //5 //second
    public let UI_DEBOUNCE_TIME = 350 //ms
    public let TRANSITION_DURATION = 0.35
    public let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
    public let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
    public var appDelegate: AppDelegate? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            return appDelegate
        }
    }
    
    private var moveViewWhenKeyabordShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayoutGuideView()
        LogUtil.i("\(self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController()
        enableUserInteraction()
    }
    
    deinit {
        LogUtil.i("\(self)")
    }
    
    /*
     * MARK: View Bg Color (Must Override)
     */
    
    func viewBgColor() -> UIColor {
        return .white
    }
    
    /*
     * MARK: ContentView Bg Color (Must Override)
     */
    
    func contentViewBgColor() -> UIColor {
        return .white
    }
    
    /*
     * MARK: Custom Top App Bar Options (Must Override)
     */
    
    func topAppBarBottomBorderLineColor() -> UIColor {
        return Colors.achromatic(color: 227)
    }
    
    func topAppBarBgColor() -> UIColor {
        return .white
    }
    
    func topAppBarLeftBtnImage() -> (UIImage?, UIImage?) {
        return (nil, nil)
    }
    
    func topAppBarRightBtnImage() -> (UIImage?, UIImage?) {
        return (nil, nil)
    }
    
    func topAppBarLeftBtnText() -> String? {
        return nil
    }

    func topAppBarRightBtnText() -> String? {
        return nil
    }
    
    func topAppBarTitleText() -> String? {
        return nil
    }
    
    func topAppBarTitleImage() -> UIImage? {
        return nil
    }
    
    func topAppBarLeftBtnTextColor() -> UIColor {
        return .black
    }
    
    func topAppBarRightBtnColor() -> UIColor {
        return .black
    }
    
    func topAppBarTitleTextColor() -> UIColor {
        return .black
    }
    
    func topAppBarTitleTextFont() -> UIFont {
        return Fonts.bold(16)
    }
    
    /*
     * MARK: Navigation Button Events
     */
    @objc
    func navigationLeftButtonDidTapped() {
        fatalError("must be override func \(#function)  {} in \(NSStringFromClass(self.classForCoder))")
    }
    
    @objc
    func navigationRightButtonDidTapped() {
        fatalError("must be override func \(#function)  {} in \(NSStringFromClass(self.classForCoder))")
    }
    
    @objc
    func navigationTitleDidTapped() {
        //        fatalError("must be override func \(#function)  {} in \(NSStringFromClass(self.classForCoder))")
    }
    
    /*
     * MARK: Enable/Disable Gesture
     */
    func isEnableNavigationGesture() -> Bool {
        return true
    }
    
    func enableUserInteraction() {
        UIApplication.shared.firstKeyWindow?.isUserInteractionEnabled = true
    }
    
    /*
     * MARK: Add Keyboard Observer
     */
    func addKeyboardObserver(resizeView: Bool = true) {
        moveViewWhenKeyabordShow = resizeView
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIApplication.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: UIApplication.keyboardDidHideNotification,
                                               object: nil)
    }
    
    /*
     * MARK: Remove Keyboard Observer
     */
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.keyboardDidShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.keyboardDidHideNotification,
                                                  object: nil)
    }
    
    /*
     * MARK: Add Foreground/Background Observer
     */
    
    func addForeBackgroundObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMoveToBackground(notification:)),
                                               name: LocalNotifications.background.name,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMoveToForeground(notification:)),
                                               name: LocalNotifications.foreground.name,
                                               object: nil)
    }
    
    /*
     * MARK: Remove Foreground/Background Observer
     */
    
    func removeForeBackgroundObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: LocalNotifications.background.name,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: LocalNotifications.foreground.name,
                                                  object: nil)
    }
    
    /*
     * MARK: Keyboard Events
     */
    
    @objc
    func keyboardWillShow(notification: Notification) {
        let i = notification.userInfo!
        let k = (i[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.contentView.snp.updateConstraints {
                if strongSelf.moveViewWhenKeyabordShow {
                    $0.bottom.equalTo(strongSelf.layoutGuideView).inset(k - strongSelf.view.safeAreaInsets.bottom)
                }
            }
            
            UIView.animate(withDuration: s) {
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        let info = notification.userInfo!
        let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.contentView.snp.updateConstraints {
                $0.bottom.equalTo(strongSelf.layoutGuideView)
            }
            
            UIView.animate(withDuration: s) {
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    func keyboardDidShow(notification: Notification) {
        
    }
    
    @objc
    func keyboardDidHide(notification: Notification) {
        
    }
    
    /*
     * MARK: FirstResponder Event
     */
    func becomeFirstResponder(_ view: UIView, withDuration: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration) {
            view.becomeFirstResponder()
        }
    }
    
    /*
     * Fore/Background Events
     */
    
    @objc
    func appMoveToForeground(notification: Notification) {
        LogUtil.d("\(self)")
        PushNotificationManager.shared.push(key: "fore", title: "Foreground", body: "진입!")
    }
    
    @objc
    func appMoveToBackground(notification: Notification) {
        LogUtil.d("\(self)")
        PushNotificationManager.shared.push(key: "back", title: "Background", body: "진입!")
    }
    
    /*
     * MARK: Page Events
     */
    
    func pushViewController(_ vc: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            self?.navigationController?.pushViewController(vc, animated: animated)
            self?.removeToastIfNeed()
        }
    }
    
    func popViewController(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            self?.navigationController?.popViewController(animated: animated)
        }
    }
    
    func popViewController(before idx: Int, animated: Bool = true) {
        let controllerCount = navigationController?.viewControllers.count ?? 0
        let targetIdx = controllerCount - idx - 1
        
        if targetIdx >= 0 {
            guard let controller = navigationController?.viewControllers[targetIdx] else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.appDelegate?.window?.endEditing(true)
                
                self?.navigationController?.popToViewController(controller, animated: animated)
            }
        }
    }
    
    func popToRootViewController(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            self?.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        removeToastIfNeed()
    }
    
    func presentFullScreen(_ vc: UIViewController,
                           animated flag: Bool = true,
                           completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            let vc = UINavigationController(rootViewController: vc)
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: flag, completion: completion)
            self?.removeToastIfNeed()
        }
    }
    
    func presentCrossDissolve(_ vc: UIViewController, withNavigationController: Bool = true, animated: Bool = false) {
        let naviVC = withNavigationController ? UINavigationController(rootViewController: vc) : vc
        naviVC.modalTransitionStyle = .crossDissolve
        naviVC.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            self?.present(naviVC, animated: animated, completion: nil)
            self?.removeToastIfNeed()
        }
    }
    
    func presentModal(_ vc: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            let vc = UINavigationController(rootViewController: vc)
            vc.modalPresentationStyle = .popover
            self?.present(vc, animated: true, completion: nil)
            self?.removeToastIfNeed()
        }
    }
    
    func dismissVC(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true) {
                self?.appDelegate?.window?.endEditing(true)
                
                completion?()
            }
        }
    }
    
    func presentLeftToRight(_ vc: UIViewController) {
        let transition = CATransition()
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            self?.view.window?.layer.add(transition, forKey: kCATransition)
            self?.navigationController?.pushViewController(vc, animated: false)
            self?.removeToastIfNeed()
        }
    }
    
    func dismissRightToLeft(animated: Bool = true) {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        DispatchQueue.main.async { [weak self] in
            if let window = self?.view.window {
                self?.appDelegate?.window?.endEditing(true)
                
                window.layer.add(transition, forKey: kCATransition)
                self?.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    /*
     Toast
     */
    
    private func removeToastIfNeed() {
        let keyWindow: UIWindow? = UIApplication.shared.firstKeyWindow
        if let toast = keyWindow?.viewWithTag(PrefixManager.toastViewTag) {
            toast.removeFromSuperview()
        }
    }
    
    /**
     * MARK: fileprivate
     */
    
    fileprivate func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func setupNavigationController() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        hideNavigationBar()
    }
    
    fileprivate func topAppBarIsShow() -> Bool {
        return topAppBarShowLeftBtn() || topAppBarShowTitle() || topAppBarShowRightBtn()
    }
    
    fileprivate func topAppBarShowLeftBtn() -> Bool {
        let btnImages = topAppBarLeftBtnImage()
        let btnText = topAppBarLeftBtnText()
        let isShow = (btnImages.0 != nil) || (btnImages.1 != nil) || (btnText != nil)
        return isShow
    }
    
    fileprivate func topAppBarShowTitle() -> Bool {
        return topAppBarTitleText() != nil
    }
    
    fileprivate func topAppBarShowImage() -> Bool {
        return topAppBarTitleImage() != nil
    }
    
    fileprivate func topAppBarShowRightBtn() -> Bool {
        let btnImages = topAppBarRightBtnImage()
        let btnText = topAppBarRightBtnText()
        let isShow = (btnImages.0 != nil) || (btnImages.1 != nil) || (btnText != nil)
        return isShow
    }
    
    /*
     MARK: Error Handler
     
     case DATA_IS_NULL([String: Any], Data?)
     case JSON_PARSING_FAIL([String: Any], Data?)
     case RESPONSE_FAIL(String)
     case RESPONSE_DATA_IS_NULL(String?)
     case NETWORK_CONNECTION(String)
     */
    
    func errorHandling<T>(_ errorInfo: ErrorInfo<T>) {
        if let apiError = errorInfo.error as? ApiError {
            switch apiError {
            case .ACCESS_TOKEN_DENIND:
                UserdefaultsManager.shared.accessToken = nil
                showBeenLogoutAlert()
            default:
                showErrorMsg(error: errorInfo.error)
            }
            return
        }
    }
    
    func showErrorMsg(error: Error) {
        var msg: String
        
        switch error as? ApiError {
        case .NETWORK_CONNECTION:
            msg = "네트워크 연결상태를\n확인 후 다시 시도해 주세요."
        case .RESPONSE_FAIL(let errorMsg):
            if errorMsg.isNotEmpty { msg = errorMsg }
            else { fallthrough }
        default:
            msg = "서버와 통신이 불안정합니다.\n잠시 후 다시 시도해 주세요."
        }
        
        systemPopupManager.showToast(vc: self, message: msg)
    }
    
    func showNetworkAlert(error: Error) {
        var errorTitle: String = "서버 통신 불안정"
        var errorMsg: String = "잠시 후에 다시 시도해 주세요."
        
        if let error = error as? ApiError {
            switch error {
            case .NETWORK_CONNECTION(_):
                errorTitle = "네트워크 연결"
                errorMsg = "네트워크 연결상태를\n확인 후 다시 시도해 주세요."
            default: break
            }
        }
        
        systemPopupManager
            .showAlert(vc: self,
                       title: errorTitle,
                       message: errorMsg,
                       defaultAction: UIAlertAction(title: "확인", style: .destructive, handler: { _ in
                        exit(0)
                       }))
    }
    
    func showBeenLogoutAlert() {
        let defaultLocationAuthMsg = "다른 기기에서 로그인하여 로그아웃 되었습니다.\n본인이 로그인한 것이 아니라면 관리자에게 문의해 주세요."
        systemPopupManager.showAlert(vc: self,
                                     style: .alert,
                                     title: "로그아웃 되었습니다.",
                                     message: defaultLocationAuthMsg,
                                     defaultAction: UIAlertAction(title: "확인",
                                                                  style: .default,
                                                                  handler: { [weak self] _ in
                                                                    self?.appDelegate?.logout()
                                                                  }))
    }
    
    /*
     * MARK: Setup LayoutGuideView
     */
    
    fileprivate func setupLayoutGuideView() {
        view.backgroundColor = viewBgColor()
        
        view.addSubview(layoutGuideView)
        layoutGuideView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.left.equalTo(view.safeAreaInsets.left)
            $0.right.equalTo(view.safeAreaInsets.right)
            $0.bottom.equalTo(view.safeAreaInsets.bottom)
        }
        
        layoutGuideView.addSubview(customTopNavigationBarView)
        layoutGuideView.addSubview(contentView)
        
        customTopNavigationBarView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(topAppBarIsShow() ? 60 : 0)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(customTopNavigationBarView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(layoutGuideView)
        }
    }
    
}

// MARK: - UIGestureRecognizerDelegate, UIScrollViewDelegate
extension BaseVC: UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return
            (navigationController?.viewControllers.count ?? 0 > 1)
            && isEnableNavigationGesture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        appDelegate?.window?.endEditing(true)
    }
    
}

// MARK: - UIApplication + Extension
extension UIApplication {
    
    public var firstKeyWindow: UIWindow? {
        let keyWindow: UIWindow?
        
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows
                .filter { $0.isKeyWindow }.first
        } else {
            // Fallback on earlier versions
            keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        
        return keyWindow
    }
    
}

// MARK: - PrefixManager
extension PrefixManager {
    
    static var toastViewTag = Int.max
    
}
