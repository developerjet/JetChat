//
//  AppUpdateAlert.swift
//  SwiftStudy
//
//  Created by Mac on 2018/8/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

import UIKit
import RxSwift


let DEFAULT_LINE_WIDTH = kFitScale(AT: 0.65)
 
class AppUpdateAlert: UIView {
    
    /// 版本号
    var title : String? {
        didSet {
            guard title?.isEmpty == false else {
                return
            }
            self.titleLabel.text = title
        }
    }
    
    var didUpdateClosure : (()->Void)?
    
    /// 是否强制更新
    var isUpdate: Bool = false
    
    // MARK:- var lazy
    
    lazy var alertTopView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_update_top"))
        return imageView
    }()
    
    lazy var footerInView : UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHexStr("F8F8F8")
        return view
    }()
    
    lazy var alertBgView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_update_bg"))
        imageView.isUserInteractionEnabled = true
        imageView.cornerRadius = 14
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.PingFangRegular(15)
        label.textColor = UIColor.textPrimaryColor()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var cancelButton : UIButton = {
        let cancelBtn = UIButton(type: .custom)
        //cancelBtn.setTitle(Lca.tip_logout_cancel.rLocalized(), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.PingFangRegular(15)
        cancelBtn.backgroundColor = .backGroundWhiteColor()
        cancelBtn.setTitleColor(.textPrimaryColor(), for: .normal)
        cancelBtn.rxTapClosure { [weak self] in
            guard let self = self else { return }
            self.dismiss()
        }
        return cancelBtn
    }()
    
    lazy var updateButton : UIButton = {
        let updateBtn = UIButton(type: .custom)
        //updateBtn.setTitle(Lca.x_common_update_go.rLocalized(), for: .normal)
        updateBtn.backgroundColor = .backGroundWhiteColor()
        updateBtn.titleLabel?.font = UIFont.PingFangRegular(15)
        updateBtn.setTitleColor(.appThemeHexColor(), for: .normal)
        updateBtn.rxTapClosure { [weak self] in
            guard let self = self else { return }
            self.update()
        }
        return updateBtn
    }()

    
    // MARK:- life cycle
    
    convenience init(isUpdate: Bool) {
        self.init(frame: CGRect.zero)
        self.isUpdate = isUpdate
        
        makeUI()
        makeLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
        makeLayout()
    }
    
    func makeUI() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        
        // Configuration
        if isUpdate == true {
            cancelButton.isHidden = true
            updateButton.isHidden = false
        }else {
            cancelButton.isHidden = false
            updateButton.isHidden = false
        }
        
        alertBgView.addSubview(titleLabel)
        alertBgView.addSubview(footerInView)
        
        footerInView.addSubview(updateButton)
        footerInView.addSubview(cancelButton)
        
        addSubview(alertBgView)
        addSubview(alertTopView)
    }
    
    func makeLayout() {
        
        let lineMargin : CGFloat = DEFAULT_LINE_WIDTH
        
        let k_alert_h = kFitScale(AT: 250)
        let k_alert_w = kScreenW - kFitScale(AT: 100)
        alertBgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(k_alert_w)
            make.height.equalTo(k_alert_h)
        }
        
        let k_top_h = kFitScale(AT: 114)
        let k_top_w = kFitScale(AT: 38)
        alertTopView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(alertBgView.snp_top).offset(k_top_h * 0.5)
            make.width.equalTo(k_top_w)
            make.height.equalTo(k_top_h)
        }
        
        let k_footer_h = kFitScale(AT: 47)
        footerInView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(k_footer_h)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(footerInView.snp_top).offset(-20)
            make.left.equalTo(kFitScale(AT: 22))
            make.right.equalTo(kFitScale(AT: -22))
        }
        
        let k_button_w = k_alert_w * 0.5 - lineMargin * 2
        let k_button_h = k_footer_h-lineMargin
        
        let k_cancel_w = isUpdate ? 0 : k_button_w
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(lineMargin)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(k_cancel_w)
            make.height.equalTo(k_button_h)
        }
        
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(lineMargin)
            make.right.bottom.equalToSuperview()
            if isUpdate {
                make.left.equalTo(cancelButton.snp_right)
            }else {
                make.left.equalTo(cancelButton.snp_right).offset(lineMargin)
            }
            make.height.equalTo(k_button_h)
        }
    }
}


// MARK:- Action

extension AppUpdateAlert {
    
    /// 获取用于显示提示框的view
    func showInWindow() -> UIWindow {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for newWindow in windowArray {
                if newWindow.windowLevel == UIWindow.Level.normal {
                    window = newWindow
                    break
                }
            }
        }
        return window!
    }
    
    @objc func show() {
        // add superView
        showInWindow().addSubview(self)
        // anima
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = CFTimeInterval(0.5)
        var values = [AnyHashable]()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        alertBgView.layer.add(animation, forKey: nil)
    }
    
   @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alertBgView.alpha = 0.0;
            self.alpha = 0.0
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    
    @objc func update() {
        if didUpdateClosure != nil {
            didUpdateClosure?()
        }
    }
}

