//
//  SignButtonType.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/09.
//

import Foundation
import UIKit

// MARK: Input Type Enum

enum UserInputType {
    case inputPhoneNumber
    case inputVerifyCode
    case inputPassword
    
    var guideText: String {
        switch self {
        case .inputPhoneNumber:
            return "본인 인증을 위해 전화번호를 입력해 주세요."
        case .inputVerifyCode:
            return "\n전송한 인증번호를 입력해 주세요."
        case .inputPassword:
            return " 계정이 확인되었습니다\n비밀번호를 입력해 주세요"
        }
    }
    
    var placeHolderText: String {
        switch self {
        case .inputPhoneNumber:
            return "숫자만 입력해 주세요."
        case .inputVerifyCode:
            return "인증번호 6자리 를 입력 해주세요."
        case .inputPassword:
            return "비밀번호 입력"
        }
    }
    
    var limitCount: Int {
        switch self {
        case .inputPhoneNumber:
            return 13
        case .inputVerifyCode, .inputPassword:
            return 6
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .inputPhoneNumber, .inputVerifyCode:
            return .numberPad
        default:
            return .default
        }
    }
    
    var isShowCountLabel: Bool {
        return self == .inputVerifyCode
    }
    
}
