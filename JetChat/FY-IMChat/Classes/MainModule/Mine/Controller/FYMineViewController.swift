//
//  FYMineViewController.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/8/18.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class FYMineViewController: FYBaseViewController {

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我".rLocalized()
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V10 }
    }
    
    override func makeUI() {
        super.makeUI()
    
        let moments = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "朋友圈".rLocalized())
                .contentState(state: .normal)
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
        
        let settings = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "设置".rLocalized())
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.settingAction()
                }).last(isLine: false)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(moments.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(moments)
        })
        
        _ = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "作者github".rLocalized())
                .content(text: "Jett")
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.openSafariURL(url: "https://github.com/developerjet")
                }).last(isLine: false)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(settings.snp.bottom).offset(10)
            make.left.right.equalTo(self.view)
            make.height.equalTo(settings)
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
    
    
    private func openSafariURL(url: String) {
        if let urlValue = url.URLValue {
            let safariVC = SFSafariViewController(url: urlValue)
            present(safariVC, animated: true, completion: nil)
        }
    }
}

