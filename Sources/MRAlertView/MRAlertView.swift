//
//  MRAlertView.swift
//  Easy Stylish AlertView for Swift
//
//  Created by MohammadReza Khatibi on 4/29/2020.
//  Copyright © 2020 MohammadReza Khatibi. All rights reserved.
//

import UIKit
import SnapKit

public class MRAlertView: UIView {
    
    private var dimView                 : UIView!
    
    private let screenSize              = UIScreen.main.bounds.size
    
    public var dismissOnOutsideTouch    : Bool? = false
    public var dismissOnButtonPress     : Bool?  = true
    
    private var alertViewFrame          : CGRect!
    
    private var defaultSpacing          : CGFloat!
    private var defaultHeight           : CGFloat!
    
    private var alertViewContents       : UIView!
    
    private var isShowing               : Bool? = false
    
    private var titleLabel              : UILabel!
    private var subtitle                : UILabel!
    private var icon                    : UIImageView!
    
    private var doneButton              : UIButton!
    private var secondButton            : UIButton!
    
    public var cornerRadius             : CGFloat?
    public var viewContentsBackground   : UIColor?
    
    
    public var titleFont                : UIFont?
    public var subtitleFont             : UIFont?
    
    public var titleTextColor           : UIColor?
    public var subtitleTextColor        : UIColor?
    
    public var doneButtonBackgroundColor: UIColor?
    public var secondButtonBackgroundColor: UIColor?
    
    public var doneButtonTitleColor     : UIColor?
    public var secondButtonTitleColor   : UIColor?
    
    public var buttonCornerRadius       : CGFloat?
    public var buttonFont               : UIFont?
    
    public var direction                : UISemanticContentAttribute? = .forceLeftToRight
    
    public typealias doneAction                = (()->Void)
    public typealias secondAction              = (()->Void)
    public var donButtonAction                 : doneAction?
    public var secondButtonAction              : secondAction?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        
        self.defaultSpacing = self.configureAVWidth()
        self.defaultHeight = self.configureAVHeight()
        
        
        self.dimView = UIView()
        self.dimView.alpha = 0
        self.dimView.frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height)
        self.dimView.backgroundColor = UIColor.hex("000000", alpha: 0.5)
        
        
        self.alpha = 0
        
        self.alertViewFrame = CGRect(x: self.frame.size.width/2 - ((screenSize.width - defaultSpacing)/2),
                                     y: self.frame.size.height/2 - (170.0/2),
                                     width: screenSize.width - defaultSpacing,
                                     height: defaultHeight - 30)
        
        self.alertViewContents = UIView(frame: alertViewFrame)
        
        self.addSubview(alertViewContents)
        
        self.alertViewContents.layer.cornerRadius = self.cornerRadius ?? 8
        self.alertViewContents.layer.masksToBounds = true
        
        self.alertViewContents.transform = CGAffineTransform.init(scaleX: 1.15, y: 1.15)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.showAlertView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAVWidth() -> CGFloat {
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
        {
            
            if(screenSize.height == 1366) {
                
                return 105.0 + 600.0
            } else {
                
                return 105.0 + 350.0
            }
        }
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
        {
            if(screenSize.height == 480)
            {
                // iPhone Classic
                return 100.0
                
            }
            if(screenSize.height == 568)
            {
                // iPhone 5
                return 64.0
                
            }
            if (screenSize.height == 736)
            {
                // iPhone 6/7 Plus
                return 64.0
            }
            else
            {
                return 64.0
            }
        }
        
        return 64.0
    }
    
    private func configureAVHeight() -> CGFloat {
        return 200.0
    }
 
    
    public func show(title: String, subtitle: String?, doneButton: String?, secondButton: String?,image: String? = nil, view: UIView? = nil) {
        
        
        
        self.alertViewContents.backgroundColor = viewContentsBackground
        self.setAttribiute(title: title, subtitle: subtitle, doneButton: doneButton, secondButton: secondButton)
        
        let window = UIApplication.shared.keyWindow
        
        window?.addSubview(self.dimView)
        window?.addSubview(self)
        
        
        if self.dismissOnOutsideTouch == true
        {
            let tapOutSide = UITapGestureRecognizer(target: self, action: #selector(self.dismissOnOutsideTouchAction))
            self.dimView.isUserInteractionEnabled = true
            self.dimView.addGestureRecognizer(tapOutSide)
        }

        
        self.doneButton.addTarget(self, action: #selector(self.donePressed), for: .touchUpInside)
        
        
        if doneButton != nil && secondButton == nil {
            self.alertViewContents.addSubview(self.doneButton)
            self.doneButton.snp.makeConstraints { (make) in
                make.width.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-16)
                make.height.equalTo(42)
                make.centerX.equalToSuperview()
                
            }
        } else if doneButton != nil && secondButton != nil {
            
            self.alertViewContents.addSubview(self.doneButton)
            self.doneButton.snp.makeConstraints { (make) in
                make.width.equalToSuperview().dividedBy(2).inset(12)
                make.height.equalTo(42)
                if direction == .forceLeftToRight {
                    make.right.equalToSuperview().inset(17)
                } else {
                    make.left.equalToSuperview().offset(17)
                }
                make.bottom.equalToSuperview().offset(-16)
                
            }
            
            self.alertViewContents.addSubview(self.secondButton)
            self.secondButton.snp.makeConstraints { (make) in
                make.width.equalToSuperview().dividedBy(2).inset(12)
                make.height.equalTo(42)
                if direction == .forceLeftToRight {
                    make.left.equalToSuperview().inset(17)
                } else {
                    make.right.equalToSuperview().inset(17)
                }
                make.bottom.equalToSuperview().offset(-16)
                
            }

            self.secondButton.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        }
        
        if let view = view {
            self.alertViewContents.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.top.equalToSuperview()
                //make.height.equalTo(400)
                make.bottom.equalToSuperview().offset(-70)
            }
        } else {
            
            if subtitle != nil {
                
                self.alertViewContents.addSubview(self.titleLabel)
                self.titleLabel.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(20)
                    make.width.equalToSuperview().inset(16)
                    make.centerX.equalToSuperview()
                }
                
                self.alertViewContents.addSubview(self.subtitle)
                self.subtitle.snp.makeConstraints { (make) in
                    make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
                    make.width.equalToSuperview().inset(16)
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(self.doneButton.snp.top).offset(-20)
                }
                
                if image != nil {
                    self.icon = UIImageView()
                    self.alertViewContents.addSubview(self.icon)
                    self.icon.image = UIImage(named: image ?? "")
                    self.icon.snp.makeConstraints { (make) in
                        make.top.equalToSuperview().offset(20)
                        make.width.equalTo(60)
                        make.height.equalTo(60)
                        make.centerX.equalToSuperview()
                    }
                    
                    self.titleLabel.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.icon.snp.bottom).offset(16)
                        make.width.equalToSuperview().inset(16)
                        make.centerX.equalToSuperview()
                    }
                }
                
            }
            
        }
        
        self.alertViewContents.snp.makeConstraints { (make) in
            make.width.equalTo(self.alertViewFrame.width)
            make.center.equalToSuperview()
        }
    }
    
    private func showAlertView() {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.alpha = 1
            self.dimView.alpha = 1
            self.alertViewContents.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self.alertViewContents.frame = CGRect(x: self.alertViewFrame.origin.x,
                                                  y: self.alertViewFrame.origin.y,
                                                  width: self.alertViewFrame.width,
                                                  height: self.alertViewFrame.height)
            
        }) { (done) in
            
        }
    }
    
    
    private func setAttribiute(title: String?, subtitle: String?, doneButton: String?, secondButton: String?) {

        self.titleLabel = UILabel.make(title ?? "", font: titleFont ?? UIFont.systemFont(ofSize: 16, weight: .bold), align: .center, color:  self.titleTextColor ?? UIColor.hex("222222", alpha: 1))
        self.titleLabel.numberOfLines = 0
        
        
        self.subtitle = UILabel.make(subtitle ?? "", font: subtitleFont ?? UIFont.systemFont(ofSize: 13, weight: .regular) , align: .center, color: self.subtitleTextColor ?? UIColor.hex("666666", alpha: 1))
        self.subtitle.numberOfLines = 0

        self.doneButton = UIButton()
        self.doneButton.setTitle(doneButton, for: .normal)
        self.doneButton.backgroundColor = self.doneButtonBackgroundColor
        self.doneButton.setTitleColor(self.doneButtonTitleColor, for: .normal)
        self.doneButton.titleLabel?.font = self.buttonFont
        
        self.doneButton.layer.cornerRadius = self.buttonCornerRadius ?? 0
        
        
        guard let secondButton = secondButton else {
            return
        }

        self.secondButton = UIButton()
        self.secondButton.setTitle(secondButton, for: .normal)
        self.secondButton.backgroundColor = self.secondButtonBackgroundColor
        self.secondButton.setTitleColor(self.secondButtonTitleColor, for: .normal)
        self.secondButton.titleLabel?.font = self.buttonFont
        self.secondButton.layer.cornerRadius = self.buttonCornerRadius ?? 0
    }
    
    @objc private func dismissOnOutsideTouchAction() {
        self.dismissAlertView()
    }
    
    private func dismissAlertView() {
        
        UIView.animate(withDuration: 0.175, animations: {
            self.alpha = 0;
            self.dimView.alpha = 0
            self.alertViewContents.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            
        }) { (done) in
            self.dimView.removeFromSuperview()
            self.removeFromSuperview()
        }
        
    }
    
    
    @objc private func donePressed() {
        
        if self.donButtonAction != nil {
            self.donButtonAction!()
        }
        if self.dismissOnButtonPress ?? true {
            self.dismissAlertView()
        }
    }
    
    @objc private func buttonPressed() {
        
        if self.secondButtonAction != nil {
            self.secondButtonAction!()
        }
        
        if self.dismissOnButtonPress ?? true {
            self.dismissAlertView()
        }
    }
    
    public func doneButtonAcion(action: @escaping doneAction) {
        self.donButtonAction = action
    }
    
    public func secondButonAcion(action: @escaping secondAction) {
        self.secondButtonAction = action
    }
}
