//
//  SplashVC.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/04/28.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SplashVC: BaseVC {
    
    // MARK: Views
    // SplashVC 는 LaunchScreen 과 동일하게 가져가는게 이질감이 없다.
    private let splashLogoImageView = UIImageView().then {
        guard let _image = UIImage(named: "butaghea_logo") else {
            return
        }
        $0.image = _image
        $0.contentMode = .scaleAspectFit
        $0.isHidden = false
    }
    
    // MARK: Properties

    private let viewModel = SplashVM(dependency: .init())
    private let commonUtil = CommonUtil()
    private let schemeUtil = SchemeUtil()
    private let disposeBag = DisposeBag()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rxBind()
        configureUI()
    }
    
    override func viewBgColor() -> UIColor {
        return .white
    }
    
    override func contentViewBgColor() -> UIColor {
        return .white
    }
    
    // MARK: Helpers
    
    private func rxBind() {
        viewModel.output.appVersion
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self, onNext: { owner, appVersion in
                UserSingletone.shared.appVersion = appVersion
                // appVersion 에 따라 대응하는 함수
                owner.appVersionRes(res: appVersion)
            })
            .disposed(by: disposeBag)
        
        // error 대응
        viewModel.output.error
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, error in
                owner.errorHandling(error)
            })
            .disposed(by: disposeBag)
        
        // token
        viewModel.output.accessToken
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self, onNext: { owner, res in
                if res?.code == 0 {
                    // token 이 전달되면 userInfo data에 바인딩
                    UserSingletone.shared.userData.userInfo = res?.userInfo
                }
                // MainVC 로 이동 (UserData | 바인딩 완료)
                owner.presentCrossDissolve(MainVC())
            })
            .disposed(by: disposeBag)
        
        viewModel.input.checkAppVersion.accept(())
    }
    
    // 앱 버전의 따른 대응 해주기.
    private func appVersionRes(res: AppVersion) {
        if res.code == 0 {
            // 문제 없으면 타입에 따라 반응하기
            let check: CommonUtil.UpdateType = commonUtil.checkUpdate(latestVersion: res.latestVersion ?? "0.0.0", requireVersion: res.minVersion ?? "0.0.0")
            switch check {
            case .optional:
                systemPopupManager.showAlert(vc: self,
                                             style: .alert,
                                             title: "업데이트 알림",
                                             message: "새로운 버전이 출시되었습니다.\n업데이트를 하지 않는 경우 서비스에 이용 제한이 있을 수 있습니다.\n업데이트를 진행하시겠습니까?",
                                             defaultAction: UIAlertAction(title: "지금 업데이트 하기", style: .default, handler: { [weak self] _ in
                                                self?.schemeUtil.open(link: Targets.getTarget().getStoreLink(), completion: { isSuccess in
                                                    if isSuccess { exit(0) }
                                                })
                                             }),
                                             destructiveAction: UIAlertAction(title: "나중에 하기", style: .destructive, handler: { [weak self] _ in
                                                self?.showNextVC()
                                             }))
            case .required:
                systemPopupManager.showAlert(vc: self,
                                             style: .alert,
                                             title: "업데이트 알림",
                                             message: "새로운 버전이 출시되었습니다.\n업데이트를 하지 않는 경우 앱을 실행할 수 없습니다.\n업데이트를 진행하시겠습니까?",
                                             defaultAction: UIAlertAction(title: "지금 업데이트 하기", style: .default, handler: { [weak self] _ in
                                                self?.schemeUtil.open(link: Targets.getTarget().getStoreLink(), completion: { isSuccess in
                                                    if isSuccess { exit(0) }
                                                })
                                             }),
                                             destructiveAction: UIAlertAction(title: "나중에 하기", style: .destructive, handler: { _ in
                                                exit(0)
                                             }))
            case .none:
                // none 일시
                showNextVC()
            }
        } else {
            showNetworkAlert(error: ApiError.RESPONSE_DATA_IS_NULL(""))
        }
    }
    
    private func showNextVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.presentFullScreen(LogInVC())
        }
    }
    
    private func checkAccessToken() {
        /*
         토큰이 없으면 로그아웃 상태로 메인화면으로 이동
         토큰이 있으면 회원정보 조회 후
         성공 -> 로그인 정보 저장 후 메인이동 (로그인성공)
         실패 -> 로그아웃 상태로 메인이동
         */
        let jwt = JwtStorage.shared
        guard jwt.accessToken != "",
              jwt.refreshToken != "" else {
                  presentCrossDissolve(MainVC())
                  return
              }
        viewModel.input.checkAccessToken.accept(())
    }
    
    override func errorHandling<T>(_ errorInfo: ErrorInfo<T>) {
        switch errorInfo.type as? SplashVM.ErrorResult {
        case .requestAppConfig, .requestAccessToken:
            showNetworkAlert(error: errorInfo.error)
        default:
            showNetworkAlert(error: errorInfo.error)
        }
    }
    
}

// MARK: ConfigureUI

extension SplashVC {
    
    private func configureUI() {
        contentView.addSubview(splashLogoImageView)
        
        splashLogoImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(splashLogoImageView.snp.width)
            $0.width.equalTo(UIScreen.main.bounds.width * 0.55)
        }
    }
    
}

// MARK: - 위치 | 광고 추적
/**
 checkPushAuthorization - 위치기반 서비스 푸쉬 허용
 afterTrackingAuthorization(isTrackingAuthorization: Bool) - 광고 추적 권한 허용
 checkTrackingAuthorization() - 위치 광고 추적 권한
 */
extension SplashVC {
    
//    private func checkPushAuthorization() {
//        // Notification Push 허용 설정
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: { [weak self] isSuccess, _ in
//                AmplitudeManager
//                    .shared
//                    .setUserProperty(key: AmplitudeKey.pushNotificationAuthorization,
//                                     value: isSuccess)
//
//                EvMixpanelManager
//                    .shared
//                    .setUserProperty(key: .pushNotificationAuthorization,
//                                     value: isSuccess)
//
//                DispatchQueue.main.async { [weak self] in
//                    self?.checkAccessToken()
//                }
//            })
//    }
//
//    private func afterTrackingAuthorization(isTrackingAuthorization: Bool) {
//        // 광고 광고 추적 권한 설정
//        // ios 15 부터 식별자에 대한 권한 요청 필요함.
//
//        AmplitudeManager.shared.setupAmplitude()
//        AmplitudeManager
//            .shared
//            .setUserProperty(key: AmplitudeKey.trackingAuthorization,
//                                      value: isTrackingAuthorization)
//
//        EvMixpanelManager
//            .shared
//            .setUserProperty(key: .trackingAuthorization,
//                             value: isTrackingAuthorization)
//
//        DispatchQueue.main.async { [weak self] in
//
//            self?.checkPushAuthorization()
//
//
//        }
//    }
//
//    private func checkTrackingAuthorization() {
//        var isTrackingAuthorization = true
//        /*
//         Apple의 가이드라인에 따라 iOS 14.5, iPadOS 14.5, 및 tvOS 14.5부터는
//         엔드 유저 데이터를 수집하고 추적/광고 관련 목적으로 이를 제3자와 공유하는
//         모든 앱은 AppTrackingTransparency(ATT) 프레임워크를 사용
//         */
//        if #available(iOS 14, *) {
//            // 추적 승인 요청 및 앱의 추적 승인 상태를 제공하는 클래스
//            // 앱이 설치되고 한번 이루어지기 때문에 추적 승인 상태를 파악
//
//            /*
//             권한 얻지 않고 사용 경우
//             1: 앱의 데이터가 사용자 기기의 third-party데이터에만 연결되고 사용자 또는 기기를 식별할 수 있는 방식으로 기기외부로 전송되지 않는 경우
//             2: 데이터를 공유하는 "data broker"가 사기탐지, 사기 방지, 보안목적으로만 데이터를 사용하는 경우
//             */
//            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
//                // 승인 요청 Function
//                switch status {
//                    // 추적 승인 상태
//                case .authorized:
//                    isTrackingAuthorization = true // 3의 값을 가지며 승인이 되어 있는 상태
//                case .denied: fallthrough // 2의 값을 가지며 추적 접근 승인 요청이 거부된 상태
//                case .notDetermined: fallthrough // 0의 값을 가지며 최초 실행되어 결정되지 않은 상태
//                    // fallthrough 로 예약어 지정 해줘서 탈출시키지 않고 그냥 넘어감.
//                case .restricted: // 1의 값을 가지며 접근 권한이 제한되어 있는 상태
//                    isTrackingAuthorization = false
//                @unknown default: break
//                }
//
//                self?.afterTrackingAuthorization(isTrackingAuthorization: isTrackingAuthorization)
//            }
//        } else {
//            // Fallback on earlier versions
//            afterTrackingAuthorization(isTrackingAuthorization: isTrackingAuthorization)
//        }
//    }
}
