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
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V10 }
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
        

        let version = FYFastGridListView().config { (view) in
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
        
        let imageCache = FYFileSizeManager.manager.cacheSize()
        let caches = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "清除图片缓存".rLocalized())
                .content(text: imageCache)
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.beginClearCaches()
                }).last(isLine: true)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(version.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(version)
        })
        
        let lastThemeMode = FYThemeCenter.shared.readSelectedTheme()
        _ = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "主题模式".rLocalized())
                .content(text: lastThemeMode == .light ? "白天模式".rLocalized() : "黑夜模式".rLocalized())
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.themeSelection()
                }).last(isLine: false)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(caches.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(caches)
        })
    }
    
    // MARK: - Action
    
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
    
    private func beginClearCaches() {
        MBHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            FYFileSizeManager.manager.clearImageCaches {
                MBHUD.showSuccess("清除成功".rLocalized())
            }
        }
    }
    
    private func themeSelection() {
        let themeVc = FYThemeSelectionListVC()
        navigationController?.pushViewController(themeVc)
    }
}


