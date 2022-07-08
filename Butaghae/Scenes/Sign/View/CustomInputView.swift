//
//  CustomInputView.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/09.
//

import Foundation
import UIKit
import SnapKit
import Then

class CustomInputView: UIView {
    
    // MARK: Views
    private lazy var guideTextLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = inputType.guideText
        $0.font = Fonts.bold(16)
        $0.setLineSpacing(value: 8)
    }
    
     lazy var numberTextField = UITextField().then {
         $0.placeholder = inputType.placeHolderText
         $0.keyboardType = inputType.keyboardType
         $0.font = Fonts.bold(16)
         $0.isSecureTextEntry = inputType == .inputPassword
         $0.clearButtonMode = .whileEditing
    }
    
    private lazy var numberUnderLineView = UIView().then {
        $0.backgroundColor = .black
        $0.isHidden = !isNeedUnderLine
    }
    
    private lazy var warningLabel = UILabel().then {
        $0.font = Fonts.semibold(12)
        $0.textColor = Colors.WARNING_COLOR
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    lazy var countLabel = UILabel().then {
        $0.textColor = Colors.WARNING_COLOR
        $0.font = Fonts.semibold(16)
        $0.textAlignment = .right
        $0.text = "3:00"
        $0.isHidden = !(inputType == .inputVerifyCode)
    }
    
    // MARK: Properties
    
    var phoneNumber: String? {
        didSet {
            guideTextLabel.text = "\(phoneNumber ?? "010-1234-5678") (으)로" + inputType.guideText
        }
    }
    
    let inputType: UserInputType
    private let isNeedUnderLine: Bool
    
    // MARK: Init
    
    init(inputType: UserInputType,
         isNeedUnderLine: Bool = true) {
        self.inputType = inputType
        self.isNeedUnderLine = isNeedUnderLine
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    func verifyWaringHelper(text: String?) {
        warningLabel.text = text
        warningLabel.setLineSpacing(value: 5)
        if let _ = text {
            numberUnderLineView.backgroundColor = Colors.WARNING_COLOR
        } else {
            numberUnderLineView.backgroundColor = .black
        }
    }
        
}

    // MARK: ConfigureUI

extension CustomInputView {
    
    private func configureUI() {
        backgroundColor = .white
        addSubview(guideTextLabel)
        addSubview(numberTextField)
        addSubview(numberUnderLineView)
        addSubview(countLabel)
        addSubview(warningLabel)
        
        guideTextLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }
        numberTextField.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().inset(inputType == .inputVerifyCode ? 45 : 0)
            $0.height.equalTo(19)
        }
        numberUnderLineView.snp.makeConstraints {
            $0.top.equalTo(numberTextField.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        countLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(numberTextField)
            $0.right.equalToSuperview().inset(7.5)
        }
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(numberTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
        }
    }
    
}

