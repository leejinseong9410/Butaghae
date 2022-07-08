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

class SplashVC: BasicVC {
    
    // MARK: Views
    
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
        viewModel.input.checkUserData
            .bind(with: self, onNext: { owner, res in
                owner.showNextVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func showNextVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.presentFullScreen(LogInVC())
        }
    }
    
}
// MARK: ConfigureUI

extension SplashVC {
    
    private func configureUI() {
        contentView.addSubview(splashLogoImageView)
        
        splashLogoImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(100)
        }
    }
    
}
