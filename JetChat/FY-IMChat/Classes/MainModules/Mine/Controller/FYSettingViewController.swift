//
//  FYSettingViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYSettingViewController: FYBaseConfigViewController {

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"
        
        makeUI()
    }
    
    override func makeUI() {
        super.makeUI()
        
        let language = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "语言设置")
                .content(text: "简体中文")
                .contentState(state: .highlight)
                .clickClosure({ [weak self] in
                    
                }).last(isLine: true)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            make.height.equalTo(50)
        })
        
        _ = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "版本")
                .content(text: "版本号:\(majorVersion)")
                .contentState(state: .normal)
                .clickClosure({
                    MBHUD.showImageError("已是最新版本")
                }).last(isLine: true)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(language.snp_bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(language)
        })
    }
}

