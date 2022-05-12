//
//  AppleLoginButton.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation
import AuthenticationServices
import SnapKit
import Then

class SocialContainer: UIView {
    
    // MARK: Views
    
    private lazy var socialLoginStackView = UIStackView(arrangedSubviews: [appleLoginButton])
    
    private let appleLoginManager = AppleLoginManager()
    
    private lazy var appleLoginButton = ASAuthorizationAppleIDButton(type: .signIn,
                                                                     style: .black).then {
        if let vc = viewController {
            appleLoginManager.setAppleLoginPresentationAnchorView(vc)
        }
        $0.addTarget(self, action: #selector(handleAppleLoginButtonClicked), for: .touchUpInside)
    }
    
    private var viewController: UIViewController?
    
    // MARK: Init
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    func handleAppleLoginButtonClicked() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleLoginManager
        controller.presentationContextProvider = appleLoginManager
        controller.performRequests()
    }
    
}

// MARK: ConfigureUI

extension SocialContainer {
    
    private func configureUI() {
        addSubview(socialLoginStackView)
        
        socialLoginStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
