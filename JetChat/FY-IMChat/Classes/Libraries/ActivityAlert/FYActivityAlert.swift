//
//  LWActivityAlert.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/4/10.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import RxSwift


/// 转换成当前比例的数
private func kRatio(_ scale: CGFloat) -> CGFloat {
    return CGFloat(scale * (UIScreen.main.bounds.width / 375.0))
}

private let K_DEFAULT_LINE_WIDTH = kRatio(0.65)

class FYActivityAlert: UIView {
    
    /// 通知标题
    var title : String? {
        didSet {
            guard title?.isEmpty == false else {
                return
            }
            self.titleLabel.text = title
        }
    }
    
    var didNotiCallClosure : (()->Void)?
    
    /// 通知具体内容
    private var url: String = ""
    
    // MARK:- var lazy
    
    lazy var footerInView : UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHexStr("F8F8F8")
        return view
    }()
    
    lazy var contentView : UIView = {
        let view = UIView.init()
        view.backgroundColor = .backGroundWhiteColor()
        view.isUserInteractionEnabled = true
        view.cornerRadius = 14
        return view
    }()
    
    lazy var wkWebView: FYConfiguraWebView = {
        let web = FYConfiguraWebView(isSnapLayout: true)
        web.backgroundColor = UIColor.red
        web.isShowProgress = false
        web.isShowRefresh = false
        return web
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel.init()
        label.font = UIFont.PingFangRegular(16)
        label.textColor = UIColor.textPrimaryColor()
        //label.text = Lca.e_wallet_notice_title.rLocalized()
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
        cancelBtn.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  in
                guard let self = self else { return }
                self.dismiss()
            })
            .disposed(by: rx.disposeBag)
        return cancelBtn
    }()
    
    lazy var confirmButton : UIButton = {
        let confirmBtn = UIButton(type: .custom)
        //confirmBtn.setTitle(Lca.sb_c_sblock_mining_ok.rLocalized(), for: .normal)
        confirmBtn.backgroundColor = .backGroundWhiteColor()
        confirmBtn.titleLabel?.font = UIFont.PingFangRegular(15)
        confirmBtn.setTitleColor(.appThemeHexColor(), for: .normal)
        confirmBtn.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  in
                guard let self = self else { return }
                self.dismiss()
            })
            .disposed(by: rx.disposeBag)
        return confirmBtn
    }()
    
    
    // MARK:- life cycle
    
    convenience init(url: String) {
        self.init(frame: CGRect.zero)
        self.url = url
        
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(wkWebView)
        
        footerInView.addSubview(confirmButton)
        contentView.addSubview(footerInView)
        
        addSubview(contentView)
        
        // loading html
        if self.url.isEmpty == false {
            self.wkWebView.url = self.url
        }
    }
    
    func makeLayout() {
        
        let lineMargin : CGFloat = K_DEFAULT_LINE_WIDTH
        
        let k_alert_h = kRatio(300)
        let k_alert_w = kScreenW - kRatio(104)
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(k_alert_w)
            make.height.equalTo(k_alert_h)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kRatio(18))
            make.height.equalTo(kRatio(21))
        }
        
        let k_footer_h = kRatio(47)
        footerInView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(k_footer_h)
        }
        
        let k_button_h = k_footer_h - lineMargin
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(lineMargin)
            make.right.bottom.left.equalToSuperview()
            make.height.equalTo(k_button_h)
        }
        
        wkWebView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(kRatio(6))
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(footerInView.snp_top).offset(-kRatio(10))
        }
    }
}


// MARK:- Action

extension FYActivityAlert {
    
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
        // animation
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = CFTimeInterval(0.5)
        var values = [AnyHashable]()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        contentView.layer.add(animation, forKey: nil)
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.alpha = 0.0;
            self.alpha = 0.0
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
        
        // callback
        if didNotiCallClosure != nil {
            didNotiCallClosure?()
        }
    }
}
