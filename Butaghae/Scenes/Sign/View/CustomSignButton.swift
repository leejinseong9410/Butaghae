//
//  SignButton.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/09.
//

import Foundation
import UIKit
import Then
import SnapKit

class CustomSignButton: UIView {
    
    // MARK: SignButtonType
    
    enum SignType {
        case signIn
        case signUp
    }
    
    // MARK: Views
    
     lazy var signButton = UIButton(type: .custom).then {
        switch signType {
        case .signIn:
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.layer.cornerRadius = 8
            $0.setTitle(text: "로그인")
        case .signUp:
            $0.backgroundColor = .clear
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            let attributedText = NSMutableAttributedString(string: "계정이 없으신가요?",
                                                           attributes: [.font: Fonts.bold(16), .foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: " 가입하기",
                                                     attributes: [.font: Fonts.bold(16),
                                                                  .foregroundColor: UIColor.blue]))
            $0.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    // MARK: Properties
    
    private var signType: SignType
    
    // MARK: Init
    
    init(signType: SignType) {
        self.signType = signType
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: ConfiguteUI

extension CustomSignButton {
    
    private func configureUI() {
        addSubview(signButton)
        
        signButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
