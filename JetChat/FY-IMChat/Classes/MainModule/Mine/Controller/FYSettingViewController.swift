//
//  FYSettingViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYSettingViewController: FYBaseViewController {

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "设置".rLocalized()
    }
    
    override func makeUI() {
        super.makeUI()
        
        let languageCode = LanguageManager.manager.selectedLanguage
        
        let language = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "语言设置".rLocalized())
                .content(text: (languageCode?.getLanguageRaw().rLocalized())!)
                .contentState(state: .highlight)
                .clickClosure({ [weak self] in
                    self?.showLanguageAction()
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
                .title(text: "版本".rLocalized())
                .content(text: "版本号:".rLocalized() + majorVersion)
                .contentState(state: .normal)
                .clickClosure({
                    MBHUD.showImageError("已是最新版本".rLocalized())
                }).last(isLine: true)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(language.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(language)
        })
    }
    
    
    private func showLanguageAction() {
        
        let titles = LanguageManager.manager.currentLanguages
        let actionSheet = PGActionSheet(isShowCancel: true, actionTitles: titles)
        self.present(actionSheet, animated: true)
        
        actionSheet.handler = { index in
            if (index == 0) {
                LanguageManager.manager.setCurrentLanguage(.kChinese)
            }else {
                LanguageManager.manager.setCurrentLanguage(.kEnglish)
            }
            self.navigationController?.popViewController(animated: false)
        }
    }
}


