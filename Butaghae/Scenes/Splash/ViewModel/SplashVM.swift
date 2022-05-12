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
    
    // MARK: Init
    
    init(dependency: Dependency) {
        self.dependency = dependency
        
        rxBind()
    }
    
    // MARK: - Helpers
    
    private func rxBind() {
        input.checkUserData
            .bind(with: self, onNext: { owner, _ in
                owner.userDataCheck()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - API Request

extension SplashVM {
    
    private func userDataCheck() {
        dependency.coreDataManager
            .getCoreDataAllData()
            .do(onError: { [weak self] e in
                self?.output.error.accept((e, .requestError))
            })
                .subscribe(with: self, onNext: { owner, res in
                    print("DEBUG: UserDataCheck Method💛\(res)")
                })
                .disposed(by: disposeBag)
    }
    
}

// MARK: - ViewModel Structure

extension SplashVM {
    
    enum ErrorResult: Error {
        case requestError
    }
    
    struct Dependency {
       let coreDataManager = CoreDataManager()
    }
    
    struct Input {
        let checkUserData = PublishRelay<Void>()
    }
    
    struct Output {
        
        let error = PublishRelay<ErrorInfo<ErrorResult>>()
    }
    
    struct Bothways {
        let userInteraction = PublishRelay<Bool>()
        let loading = PublishRelay<Bool>()
    }
    
}
