//
//  FYThemeSelectionListVC.swift
//  FY-JetChat
//
//  Created by Jett on 2022/4/30.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit

class FYThemeSelectionListVC: FYBaseViewController {
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "主题模式".rLocalized()
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V10 }
    }
    
    override func makeUI() {
        super.makeUI()
        
        var isHideSystem: Bool = true
        var systemHeight: CGFloat = 0
        
        // iOS可跟随系统模式
        if #available(iOS 13.0, *) {
            systemHeight = 50
            isHideSystem = false
        }
        
        let lastThemeMode = FYThemeCenter.shared.currentTheme
        let systemTheme = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: lastThemeMode == .system ? false : true)
                .title(text: "跟随系统".rLocalized())
                .content(text: "选取后，将跟随系统设定模式".rLocalized())
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.selectedTheme(mode: .system)
                }).last(isLine: true)
        }
            .adhere(toSuperView: self.view)
            .layout(snapKitMaker: { make in
                make.top.equalTo(self.view)
                make.left.right.equalTo(self.view)
                make.height.equalTo(systemHeight)
            })
        
        let lightTheme = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: lastThemeMode == .light ? false : true)
                .title(text: "白天模式".rLocalized())
                .contentState(state: .highlight)
                .clickClosure({ [weak self] in
                    self?.selectedTheme(mode: .light)
                }).last(isLine: true)
        }
            .adhere(toSuperView: self.view)
            .layout(snapKitMaker: { make in
                make.top.equalTo(systemTheme.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(50)
            })
        
        
        let drakTheme = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: lastThemeMode == .dark ? false : true)
                .title(text: "黑夜模式".rLocalized())
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.selectedTheme(mode: .dark)
                }).last(isLine: false)
        }
            .adhere(toSuperView: self.view)
            .layout(snapKitMaker: { make in
                make.top.equalTo(lightTheme.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(lightTheme)
            })
        
        systemTheme.isHidden = isHideSystem
        systemTheme.rightImageView.image = R.image.ic_list_selection()
        
        lightTheme.rightImageView.image = R.image.ic_list_selection()
        drakTheme.rightImageView.image = R.image.ic_list_selection()
    }
    
    // MARK: - Action
    
    private func selectedTheme(mode: FYThemeMode) {
        
        switch mode {
        case .light:
            themeService.switch(.light)
        case .dark:
            themeService.switch(.dark)
        default:
            if #available(iOS 13.0, *) {
                // iOS13跟随系统
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    print("System Dark mode")
                    themeService.switch(.dark)
                }else {
                    print("System Light mode")
                    themeService.switch(.light)
                }
            }
        }
        
        navigationController?.popToRootViewController(animated: false)
        FYThemeCenter.shared.saveSelectionTheme(mode: mode, isRestWindow: true)
    }
}
