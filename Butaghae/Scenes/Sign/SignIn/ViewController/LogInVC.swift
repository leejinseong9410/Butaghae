//
//  SignInVC.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/09.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class LogInVC: BasicVC {
    
    // MARK: Views
    
    private lazy var customInputView = CustomInputView(inputType: .inputPhoneNumber,
                                                  isNeedUnderLine: true).then {
        $0.numberTextField.delegate = self
    }
    
    private let authProblemLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = Fonts.regular(13)
        let attribute = NSMutableAttributedString(string: "본인 인증에 문제가 있나요? 문의하기")
            .apply(word: "문의하기", attrs: [.font: Fonts.bold(13)])
        attribute.addAttribute(NSAttributedString.Key.underlineStyle,
                               value: 1,
                               range: NSRange(location: attribute.length - 4, length: 4))
        $0.attributedText = attribute
        $0.minimumScaleFactor = 1.0
        $0.adjustsFontSizeToFitWidth = false
    }
    
    private let cleanProblemButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private let customConfirmView = CustomConfirmView(title: "다음")
    
    // MARK: Properties
    
    private var phoneNumber: String?
    private let disposeBag = DisposeBag()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        rxBind()
        becomeFirstResponder(customInputView.numberTextField)
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
    
    private func rxBind() {
        customInputView.numberTextField
            .rx
            .text
            .orEmpty
            .changed
            .distinctUntilChanged()
            .map { text in
                return text.count >= UserInputType.inputPhoneNumber.limitCount
            }
            .bind(to: customConfirmView.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        customConfirmView.confirmButton
            .rx
            .tap
            .bind(with: self, onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func sendCodeUserPhone() {
        guard let phoneNumber = customInputView.numberTextField.text else {
            return
        }
        self.phoneNumber = phoneNumber
        
    }
    
}

// MARK: ConfigureUI

extension LogInVC {
    
    private func configureUI() {
        contentView.addSubview(customInputView)
        contentView.addSubview(authProblemLabel)
        contentView.addSubview(customConfirmView)
        contentView.addSubview(cleanProblemButton)
        
        customInputView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        authProblemLabel.snp.makeConstraints {
            $0.bottom.equalTo(customConfirmView.snp.top).offset(-21)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        customConfirmView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(Layouts.CONTAINER_BOTTOM_BUTTON_HEIGHT)
        }
        cleanProblemButton.snp.makeConstraints {
            $0.top.right.bottom.equalTo(authProblemLabel)
            $0.width.equalTo(authProblemLabel.snp.width).multipliedBy(0.3)
        }
    }
    
}

// MARK: - UITextFieldDelegate Extension

extension LogInVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard let _text = textField.text,
              let rangeOfTextToReplace = Range(range, in: _text) else {
            return false
        }
        let substringToReplace = _text[rangeOfTextToReplace]
        let count = _text.count - substringToReplace.count + string.count
        
        textField.text = _text.toPhoneNumberFormatted()
        
        return count <= customInputView.inputType.limitCount
    }
    
}
