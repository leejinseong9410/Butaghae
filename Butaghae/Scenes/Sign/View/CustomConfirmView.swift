//
//  CustomConfirmButton.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/10.
//

import Foundation
import UIKit
import Then
import SnapKit

class CustomConfirmView: UIView {
    
    // MARK: Views
    
    lazy var confirmButton = CustomConfirmButton(disabelColor: disableColor,
                                            enableColor: enableColor,
                                            textFont: textFont,
                                            isEnable: isEnable).then {
        $0.setTitle(text: title)
    }
    // MARK: Properties
    
    private var title: String
    private var disableColor: UIColor
    private var enableColor: UIColor
    private var textFont: UIFont
    private var isEnable: Bool
    
    // MARK: Init
    
    init(title: String,
         disableColor: UIColor = .lightGray,
         enableColor: UIColor = .black,
         textFont: UIFont = Fonts.bold(20),
         isEnable: Bool = false) {
        
        self.title = title
        self.disableColor = disableColor
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

extension CustomConfirmView {
    
    private func configureUI() {
        addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
