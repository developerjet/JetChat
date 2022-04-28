//
//  FYMineViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/8/18.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import RxSwift

class FYMineViewController: FYBaseViewController {

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "我".rLocalized()
    }
    
    override func makeUI() {
        super.makeUI()
    
        let moments = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "朋友圈".rLocalized())
                .contentState(state: .highlight)
                .clickClosure({ [weak self] in
                    self?.momentsAction()
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
                .title(text: "设置".rLocalized())
                .contentState(state: .highlight)
                .clickClosure({ [weak self] in
                    self?.settingAction()
                }).last(isLine: true)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(moments.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(moments)
        })
    }
    

    // MARK: - Action
    
    private func momentsAction() {
        let momentsVc = FYMomentsViewController()
        navigationController?.pushViewController(momentsVc)
    }

    private func settingAction() {
        let settingVC = FYSettingViewController()
        navigationController?.pushViewController(settingVC)
    }
}

