//
//  FYMomentNavBar.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 MacOsx. All rights reserved.
//

import UIKit

class FYMomentNavBar: UIView {
    
    var onClick: ((Int)->Void)?
    
    lazy var navBarView: UIView = {
        let v = UIView(frame: bounds)
        v.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1.0)
        v.alpha = 0
        return v
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "朋友圈".rLocalized()
        label.alpha = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_back_white"), for: .normal)
        btn.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        btn.tag = 100;
        return btn
    }()
    
    lazy var camareBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_camera_white"), for: .normal)
        btn.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        btn.tag = 200
        return btn
    }()
    
    var isScrollUp: Bool = false {
        didSet {
            let backImage = isScrollUp ? "nav_back_black" : "nav_back_white"
            let cameraImage = isScrollUp ? "nav_camera_black" : "nav_camera_white"
            
            backBtn.setImage(UIImage(named: backImage), for: .normal)
            camareBtn.setImage(UIImage(named: cameraImage), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


fileprivate extension FYMomentNavBar {
    
    func makeUI() {
        addSubview(navBarView)
        addSubview(titleLabel)
        addSubview(backBtn)
        addSubview(camareBtn)
        
        navBarView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(44)
            make.centerX.equalTo(self);
        }
        
        backBtn.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(44)
            make.width.height.equalTo(30)
        }
        
        camareBtn.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self.backBtn)
            make.width.height.equalTo(30)
        }
    }
    
    @objc func clickAction(_ btn: UIButton) {
        onClick?(btn.tag)
    }
}
