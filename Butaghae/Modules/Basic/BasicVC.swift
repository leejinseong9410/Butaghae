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

class BasicVC: UIViewController {
    
    // MARK: - Views
    
    lazy var contentView: UIView = { [weak self] in
        let v = UIView()
        v.backgroundColor = self?.contentViewBgColor() ?? .white
        
        return v
    }()
    
    lazy var layoutGuideView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        
        return v
    }()
    
    lazy var customTopNavigationBarView: CustomTopNavigationBarView = { [weak self] in
        let v = CustomTopNavigationBarView()
        
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
    
    // MARK: - Properties
    
    public var appDelegate: AppDelegate? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            return appDelegate
        }
    }
    private var moveViewWhenKeyabordShow = false
    public let systemPopupManager = SystemPopupManager()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayoutGuideView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController()
        enableUserInteraction()
    }
    
    // MARK: NavigationBar
    
    func topAppBarBottomBorderLineColor() -> UIColor {
        return .lightGray
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
    
    // MARK: View Bg Color (Must Override)
    
    func viewBgColor() -> UIColor {
        return .white
    }
    
    // MARK: ContentView Bg Color (Must Override)
    
    func contentViewBgColor() -> UIColor {
        return .white
    }
    

    // MARK: Enable/Disable Gesture
    
    func isEnableNavigationGesture() -> Bool {
        return true
    }
    
    func enableUserInteraction() {
        UIApplication.shared.firstKeyWindow?.isUserInteractionEnabled = true
    }
    
    // MARK: Add Keyboard Observer
    
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
    
    
     // MARK: Add Keyboard Observer
     
    
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
    @objc
    func keyboardDidShow(notification: Notification) {
        
    }
    
    @objc
    func keyboardDidHide(notification: Notification) {
        
    }
    
    
    // MARK: Remove Keyboard Observer
    
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
    
    // MARK: FirstResponder Event
    
    func becomeFirstResponder(_ view: UIView, withDuration: TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + withDuration) {
            view.becomeFirstResponder()
        }
    }
    
    // MARK: Page Events
    
    func pushViewController(_ vc: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            self?.navigationController?.pushViewController(vc, animated: animated)
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
    }
    
    func presentFullScreen(_ vc: UIViewController,
                           animated flag: Bool = true,
                           completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            let vc = UINavigationController(rootViewController: vc)
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: flag, completion: completion)
        }
    }
    
    func presentCrossDissolve(_ vc: UIViewController, withNavigationController: Bool = true, animated: Bool = false) {
        let naviVC = withNavigationController ? UINavigationController(rootViewController: vc) : vc
        naviVC.modalTransitionStyle = .crossDissolve
        naviVC.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            self?.present(naviVC, animated: animated, completion: nil)
        }
    }
    
    func presentModal(_ vc: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate?.window?.endEditing(true)
            
            let vc = UINavigationController(rootViewController: vc)
            vc.modalPresentationStyle = .popover
            self?.present(vc, animated: true, completion: nil)
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
    
    // MARK: Setup LayoutGuideView
    
    fileprivate func setupLayoutGuideView() {
        view.backgroundColor = viewBgColor()
        
        view.addSubview(layoutGuideView)
        
        layoutGuideView.addSubview(customTopNavigationBarView)
        layoutGuideView.addSubview(contentView)
        
        layoutGuideView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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

extension BasicVC: UIGestureRecognizerDelegate {
    
    fileprivate func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func setupNavigationController() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        hideNavigationBar()
    }
    
}
