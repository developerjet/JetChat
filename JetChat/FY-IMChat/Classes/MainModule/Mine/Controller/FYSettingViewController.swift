//
//  FYSettingViewController.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class FYSettingViewController: FYBaseViewController {
    
    // MARK: - Private
    
    private var languageView: FYFastGridListView!
    private var versionView: FYFastGridListView!
    private var cachesView: FYFastGridListView!
    private var themeView: FYFastGridListView!
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "设置".rLocalized()
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V10 }
    }
    
    override func makeUI() {
        super.makeUI()
        
        let languageCode = LanguageManager.manager.selectedLanguage
        languageView = FYFastGridListView().config { (view) in
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
        

        versionView = FYFastGridListView().config { (view) in
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
            make.top.equalTo(languageView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(languageView)
        })
        

        cachesView = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "清除图片缓存".rLocalized())
                .content(text: "\(fileCachesSize())")
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.beginClearCaches()
                }).last(isLine: true)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(versionView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(versionView)
        })
        
        
        var themeTitle: String = ""
        let lastThemeMode = FYThemeCenter.shared.currentTheme
        switch lastThemeMode {
        case .light:
            themeTitle = "白天模式".rLocalized()
        case .dark:
            themeTitle = "黑夜模式".rLocalized()
        default:
            themeTitle = "跟随系统".rLocalized()
        }
        
        themeView = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: false)
                .title(text: "主题模式".rLocalized())
                .content(text: themeTitle )
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.themeSelection()
                }).last(isLine: false)
        }
        .adhere(toSuperView: self.view)
        .layout(snapKitMaker: { make in
            make.top.equalTo(cachesView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(cachesView)
        })
    }
    
    private func fileCachesSize() -> String {
        return FYFileSizeManager.manager.cacheSize()
    }
    
    // MARK: - Action
    
    private func showLanguageAction() {
        
        let titles = LanguageManager.manager.currentLanguages
        let actionSheet = FYActionSheet(isShowCancel: true, actionTitles: titles)
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
                self.cachesView.contentLabel.text = self.fileCachesSize()
            }
        }
    }
    
    private func themeSelection() {
        let themeVc = FYThemeSelectionListVC()
        navigationController?.pushViewController(themeVc)
    }
}


