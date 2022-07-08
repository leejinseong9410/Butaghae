//
//  BasicNaviView.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/04/27.
//

import Foundation
import UIKit

//MARK: - NavigationBar Action Protocol
public protocol CustomTopNavigationBarViewAction: AnyObject {
    func titlePressed()
    func leftButtonPressed()
    func rightButtonPressed()
}

class CustomNavigationBarView: UIView {
    
    //MARK: - Views
    lazy var leftImageButton: UIButton = {
        var confi = UIButton.Configuration.filled()
        confi.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3.0, bottom: 0, trailing: 0)
        let btn = UIButton(configuration: confi)
        btn.titleLabel?.textAlignment = .center
        
        return btn
    }()
    
    lazy var rightImageButton: UIButton = {
        var confi = UIButton.Configuration.filled()
        confi.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3.0)
        let btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Title_Text"
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    lazy var titleImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        
        return v
    }()
    
    lazy var bottomBorderLine: UIView = {
        let v = UIView()

        return v
    }()
    
    // MARK: - Properties
    weak var delegate: CustomTopNavigationBarViewAction? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAppBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup App Navigation Bar
    private func setupAppBar() {
        addSubview(leftImageButton)
        addSubview(rightImageButton)
        addSubview(titleLabel)
        addSubview(titleImageView)
        addSubview(bottomBorderLine)
        
        leftImageButton.translatesAutoresizingMaskIntoConstraints = false
        rightImageButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderLine.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftImageButton_top = NSLayoutConstraint(item: leftImageButton,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: self,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0)
        
        let leftImageButton_left = NSLayoutConstraint(item: leftImageButton,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .left,
                                                      multiplier: 1.0,
                                                      constant: 0)
        
        let leftImageButton_bottom = NSLayoutConstraint(item: leftImageButton,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .bottom,
                                                        multiplier: 1.0,
                                                        constant: 0)
        
        let leftImageButton_width = NSLayoutConstraint(item: leftImageButton,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: leftImageButton,
                                                       attribute: .height,
                                                       multiplier: 1.0,
                                                       constant: 0)
        
        let rightImageButton_top = NSLayoutConstraint(item: rightImageButton,
                                                      attribute: .top,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .top,
                                                      multiplier: 1.0,
                                                      constant: 0)
        
        let rightImageButton_right = NSLayoutConstraint(item: rightImageButton,
                                                        attribute: .right,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .right,
                                                        multiplier: 1.0,
                                                        constant: 0)
        
        let rightImageButton_bottom = NSLayoutConstraint(item: rightImageButton,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .bottom,
                                                         multiplier: 1.0,
                                                         constant: 0)
        
        let rightImageButton_width = NSLayoutConstraint(item: rightImageButton,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: rightImageButton,
                                                        attribute: .height,
                                                        multiplier: 1.0,
                                                        constant: 0)
        
        let titleLabel_top = NSLayoutConstraint(item: titleLabel,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .top,
                                                multiplier: 1.0,
                                                constant: 0)
        
        let titleLabel_left = NSLayoutConstraint(item: titleLabel,
                                                 attribute: .left,
                                                 relatedBy: .equal,
                                                 toItem: leftImageButton,
                                                 attribute: .right,
                                                 multiplier: 1.0,
                                                 constant: 10)
        
        let titleLabel_bottom = NSLayoutConstraint(item: titleLabel,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .bottom,
                                                   multiplier: 1.0,
                                                   constant: 0)
        
        let titleLabel_right = NSLayoutConstraint(item: titleLabel,
                                                  attribute: .right,
                                                  relatedBy: .equal,
                                                  toItem: rightImageButton,
                                                  attribute: .left,
                                                  multiplier: 1.0,
                                                  constant: -10)
        
        let titleImageView_top = NSLayoutConstraint(item: titleImageView,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .top,
                                                    multiplier: 1.0,
                                                    constant: 0)
        
        let titleImageView_bottom = NSLayoutConstraint(item: titleImageView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .bottom,
                                                       multiplier: 1.0,
                                                       constant: 0)
        
        let titleImageView_center = NSLayoutConstraint(item: titleImageView,
                                                       attribute: .centerX,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .centerX,
                                                       multiplier: 1.0,
                                                       constant: 0)
        
        let bottomBorderLine_left = NSLayoutConstraint(item: bottomBorderLine,
                                                       attribute: .left,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .left,
                                                       multiplier: 1.0,
                                                       constant: 0)
        
        let bottomBorderLine_bottom = NSLayoutConstraint(item: bottomBorderLine,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: self,
                                                         attribute: .bottom,
                                                         multiplier: 1.0,
                                                         constant: 0)
        
        let bottomBorderLine_right = NSLayoutConstraint(item: bottomBorderLine,
                                                        attribute: .right,
                                                        relatedBy: .equal,
                                                        toItem: self,
                                                        attribute: .right,
                                                        multiplier: 1.0,
                                                        constant: 0)
        
        let bottomBorderLine_height = NSLayoutConstraint(item: bottomBorderLine,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1.0,
                                                         constant: 1)
        
        NSLayoutConstraint.activate([leftImageButton_top, leftImageButton_left, leftImageButton_bottom, leftImageButton_width,
                                     rightImageButton_top, rightImageButton_right, rightImageButton_bottom, rightImageButton_width,
                                     titleLabel_top, titleLabel_left, titleLabel_right, titleLabel_bottom,
                                     titleImageView_top, titleImageView_bottom, titleImageView_center,
                                     bottomBorderLine_left, bottomBorderLine_bottom, bottomBorderLine_right, bottomBorderLine_height])
    }
    
}
