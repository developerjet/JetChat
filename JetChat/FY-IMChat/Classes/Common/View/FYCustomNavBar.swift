//
//  FYCustomNavBar.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/5/22.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FYCustomNavBar: UIView {
    
    var leftItemDidClosure: (()->Void)?
    var rightItemDidClosure: (()->Void)?
    
    // MARK:- Configuration
    
    var title: String = "" {
        didSet {
            guard title.isEmpty == false else {
                return
            }
            
            titleLabel.text = title
        }
    }
    
    var subtitle: String = "" {
        didSet {
            guard subtitle.isEmpty == false else {
                return
            }
            
            rightButton.setTitle(subtitle, for: .normal)
        }
    }
    
    var titleFont: UIFont? {
        didSet {
            guard titleFont != nil else {
                return
            }
            
            titleLabel.font = titleFont
        }
    }
    
    var textFont: UIFont? {
        didSet {
            guard textFont != nil else {
                return
            }
            
            rightButton.titleLabel?.font = textFont
        }
    }
    
    var textColor: UIColor? {
        didSet {
            guard textColor != nil else {
                return
            }
            
            titleLabel.textColor = textColor
            rightButton.setTitleColor(textColor, for: .normal)
        }
    }
    
    // MARK:- var lazy
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.backGroundWhiteColor()
        label.font = UIFont.PingFangRegular(18)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.icon_nav_back_white(), for: .normal)
        button.rx.tap
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  in
                guard let self = self else { return }
                self.leftItemDidClosure?()
            })
            .disposed(by: rx.disposeBag)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.PingFangRegular(14)
        button.rx.tap
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  in
                guard let self = self else { return }
                self.rightItemDidClosure?()
            })
            .disposed(by: rx.disposeBag)
        return button
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
        backgroundColor = UIColor.clear
        
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(rightButton)
        
        
        titleLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12 + kSafeAreaTop)
        }
        
        backButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(titleLabel).offset(-2)
            make.width.height.equalTo(44)
            make.left.equalTo(14)
        }
        
        rightButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(-14)
        }
    }
}
