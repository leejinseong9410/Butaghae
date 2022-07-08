//
//  SignUpVC.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/09.
//

import Foundation
import SnapKit
import UIKit
import Then

class PasswordVC: BaseVC {
    
    // MARK: Views
    
    private lazy var customInputView = CustomInputView(inputType: .inputPassword).then {
        $0.numberTextField.delegate = self
        $0.phoneNumber = phoneNumber
        $0.numberTextField.returnKeyType = .done
    }
    
    private let problemLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = Fonts.semibold(13)
        let attribute = NSMutableAttributedString(string: "로그인에 문제가 있나요? 문의하기")
            .apply(word: "문의하기",
                   attrs: [.font: Fonts.bold(13)])
        attribute.addAttribute(NSAttributedString.Key.underlineStyle,
                               value: 1,
                               range: NSRange(location: attribute.length - 4, length: 4))
        $0.attributedText = attribute
        $0.minimumScaleFactor = 1.0
        $0.adjustsFontSizeToFitWidth = false
    }
    
    private let customConfirmView = CustomConfirmView(title: "다음")
    
    // MARK: Properties
    
    private let phoneNumber: String
    
    // MARK: Init
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        customConfirmView.setShadow(shadowColor: UIColor(white: 0, alpha: 0.1),
                                         offSet: CGSize(width: 0, height: -10),
                                         opacity: 0.3,
                                         shadowRadius: 5,
                                         cornerRadius: 5,
                                         corners: .allCorners,
                                         fillColor: .white)
    }
    
    // MARK: Helpers
    
    private func setNotiMessage(text: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.customInputView.verifyWaringHelper(text: text)
            guard let _ = text else { return }
            self?.customConfirmView.confirmButton.isEnabled = false
        }
    }
    
    
}

    // MARK: ConfigureUI

extension PasswordVC {
    
    private func configureUI() {
        contentView.addSubview(customInputView)
        contentView.addSubview(problemLabel)
        contentView.addSubview(customConfirmView)
        
        customInputView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        problemLabel.snp.makeConstraints {
            $0.bottom.equalTo(customConfirmView.snp.top).offset(-21)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        customConfirmView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }

    }
    
}

    // MARK: - UITextFieldDelegate

extension PasswordVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setNotiMessage(text: nil)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        setNotiMessage(text: nil)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        setNotiMessage(text: nil)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if customConfirmView.confirmButton.isEnabled {
            customConfirmView.confirmButton.sendActions(for: .touchUpInside)
        }
        return true
    }
    
}


