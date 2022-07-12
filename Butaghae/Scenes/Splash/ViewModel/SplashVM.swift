//
//  SplashViewModel.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/04/28.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class SplashVM {
    
    // MARK: Properties
    
    private(set) var input = Input()
    private(set) var output = Output()
    private(set) var dependency: Dependency
    let bothways = Bothways()
    
    private let disposeBag = DisposeBag()
    private let appConfigApiModel: AppConfigApiModel
    
    // MARK: Init
    
    init(dependency: Dependency,
         appConfigApiModel: AppConfigApiModel = AppConfigApiModel()) {
        self.dependency = dependency
        self.appConfigApiModel = appConfigApiModel
        
        rxBind()
    }
    
    // MARK: - Helpers
    
    private func rxBind() {
        // 앱 버전 확인 후
        input.checkAppVersion
            .bind(with: self, onNext: { owner, _ in
                owner.getAppConfig()
            })
            .disposed(by: disposeBag)
        
        // 유저 정보 조회 하기
        input.checkAccessToken
            .bind(with: self, onNext: { owner, _ in
                owner.getUserInfo()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - AppConfigure
    func getAppConfig() {
        let req = BaseGetRequest<AppVersion_Req>(query: AppVersion_Req())
        appConfigApiModel
            .getAppVersion(req: req)
            .do(onError: { [weak self] error in
                self?.output.error.accept((error, .appVersion))
            })
            .subscribe(with: self, onNext: { owner, res in
                if res.code == 0 {
                    owner.output.appVersion.accept(res)
                } else {
                    owner.output.error.accept((ApiError.RESPONSE_FAIL(res.msg ?? ""), .appVersion))
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Check User Info
    private func getUserInfo() {
        let req = BaseGetRequest<UserInfo_Req>(query: UserInfo_Req())
        
        dependency.signModel
            .getUserInfo(req: req)
            .do(onError: { [weak self] error in
                self?.output.error.accept((error, .requestAccessToken))
            })
            .subscribe(with: self, onNext: { owner, res in
                owner.output.accessToken.accept(res)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - API Request

extension SplashVM {
    
    
}

// MARK: - ViewModel Structure

extension SplashVM {
    
    enum ErrorResult: Error {
        case requestAppConfig
        case requestAccessToken
        case appVersion
    }
    
    struct Dependency {
        let signModel = SignModel()
    }
    
    struct Input {
        let checkAppVersion = PublishRelay<Void>()
        let checkAccessToken = PublishRelay<Void>()
    }
    
    struct Output {
        let error = PublishRelay<ErrorInfo<ErrorResult>>()
        
        let appVersion: PublishRelay<AppVersion> = PublishRelay()
        let accessToken: PublishRelay<UserInfoRes?> = PublishRelay()
    }

    struct Bothways {
        let userInteraction = PublishRelay<Bool>()
        let loading = PublishRelay<Bool>()
    }
    
}
