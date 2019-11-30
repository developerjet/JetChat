//
//  FYFastGridListView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/8/18.
//  Copyright © 2019 development. All rights reserved.
//  快速实现列表栏

import UIKit
import RxSwift

/**
 用例:（Example）
 
 let language = FYFastGridListView().config { (view) in
 view.isHiddenArrow(isHidden: false)
 .title(text: "语言设置")
 .content(text: "简体中文")
 .contentState(state: .highlight)
 .clickClosure({ [weak self] in
 })
 .last(isLine: true)
 }
 .adhere(toSuperView: self.view)
 .layout(snapKitMaker: { make in
 make.top.equalTo(self.view)
 make.left.right.equalTo(self.view)
 make.height.equalTo(50)
 })
 
 */

class FYFastGridListView: UIView {

    fileprivate var didClickClosure : (()->Void)?
    
    // MARK:- Lazy var
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.theme_textColor = "Global.textColor"
        label.font = UIFont.PingFangRegular(14)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWithHexStr("A6A6A6")
        label.font = UIFont.PingFangRegular(14)
        return label
    }()
    
    lazy var arrowView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.icon_arrow_right()
        return imageView
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.theme_backgroundColor = "Global.lineColor"
        return view
    }()
    
    // MARK:- Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        self.theme_backgroundColor = "Global.backgroundColor"
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.arrowView)
        self.addSubview(self.lineView)

        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
        }
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-30)
        }
        
        self.arrowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-15)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
            make.left.equalTo(self).offset(14)
            make.right.equalTo(self)
        }
        

        let tap = UITapGestureRecognizer()
        tap.rx.event.throttle(0.5, scheduler: MainScheduler.instance).subscribe {[weak self] (event) in
            self?.didClickClosure?()
        }.disposed(by: rx.disposeBag)
        self.addGestureRecognizer(tap)
    }
}


enum CustomContentColorState {
    case normal
    case highlight
    
    func stateColor() -> UIColor {
        switch self {
        case .normal:
            return UIColor.colorWithHexStr("A6A6A6")
        case .highlight:
            return UIColor.colorWithHexStr("0000EE")
        }
    }
}

protocol CustomContentProtocal { }

extension CustomContentProtocal where Self: FYFastGridListView {
    @discardableResult
    func config(_ config:(Self)->Void) -> Self {
        config(self)
        return self
    }
}


extension FYFastGridListView: CustomContentProtocal {
    @discardableResult

    func title(text: String) -> Self {
        self.titleLabel.text = text
        return self
    }
    
    func content(text: String) -> Self {
        self.contentLabel.text = text
        return self
    }
    
    func titleColor(color: UIColor) -> Self {
        self.titleLabel.textColor = color
        return self
    }
    
    func contentColor(color: UIColor) -> Self {
        self.contentLabel.textColor = color
        return self
    }
    
    func contentState(state:CustomContentColorState) -> Self {
        self.contentLabel.textColor = state.stateColor()
        return self
    }
    
    
    func clickClosure(_ closure:@escaping ()->Void) -> Self {
        didClickClosure = closure
        self.isUserInteractionEnabled = true
        return self
    }
    
    func isHiddenArrow(isHidden: Bool) -> Self {
        if (isHidden) {
            // 隐藏箭头
            self.arrowView.isHidden = true
            
            self.contentLabel.snp.updateConstraints{ (make) in
                make.right.equalTo(self).offset(-15)
            }
            
        }else {
            // 显示箭头
            self.arrowView.isHidden = false
            
            self.contentLabel.snp.updateConstraints { (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(self).offset(-30)
            }
            
            self.arrowView.snp.updateConstraints { (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(self).offset(-15)
            }
        }
        
        self.updateConstraints()
        
        return self
    }
    
    //最后
    func last(isLine: Bool) {
        if (isLine) {
            self.lineView.isHidden = false
        }else {
            self.lineView.isHidden = true
        }
    }
    
}
