//
//  CustomConfirmButton.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit

class CustomConfirmButton: UIButton {

    // MARK: Properties
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? enableColor : disabelColor
            setTitleColor(color: .white)
        }
    }
    
    private var disabelColor: UIColor
    private var enableColor: UIColor
    private var textFont: UIFont
    private var isEnable: Bool
    
    // MARK: Init
    
    init(disabelColor: UIColor = Colors.BUTTON_DISABLE_COLOR,
         enableColor: UIColor = Colors.BUTTON_ENABLE_COLOR,
         textFont: UIFont = Fonts.bold(18),
         isEnable: Bool = false) {
        self.disabelColor = disabelColor
        self.enableColor = enableColor
        self.textFont = textFont
        self.isEnable = isEnable
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

    // MARK: ConfigureUI

extension CustomConfirmButton {
    
    private func configureUI() {
        titleLabel?.font = textFont
        isEnabled = isEnable
    }
    
}
