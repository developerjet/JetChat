//
//  FYThemeSelectionListVC.swift
//  FY-JetChat
//
//  Created by Jett on 2022/4/30.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit

class FYThemeSelectionListVC: FYBaseViewController {
    
    // MARK: - lazy var
    
    private var systemThemeView: FYFastGridListView!
    private var lightThemeView: FYFastGridListView!
    private var drakThemeView: FYFastGridListView!
    
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
        systemThemeView = FYFastGridListView().config { (view) in
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
        
        lightThemeView = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: lastThemeMode == .light ? false : true)
                .title(text: "白天模式".rLocalized())
                .contentState(state: .highlight)
                .clickClosure({ [weak self] in
                    self?.selectedTheme(mode: .light)
                }).last(isLine: true)
        }
            .adhere(toSuperView: self.view)
            .layout(snapKitMaker: { make in
                make.top.equalTo(systemThemeView.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(50)
            })
        
        
        drakThemeView = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: lastThemeMode == .dark ? false : true)
                .title(text: "黑夜模式".rLocalized())
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.selectedTheme(mode: .dark)
                }).last(isLine: false)
        }
            .adhere(toSuperView: self.view)
            .layout(snapKitMaker: { make in
                make.top.equalTo(lightThemeView.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(lightThemeView)
            })
        
        systemThemeView.isHidden = isHideSystem
        systemThemeView.rightImageView.image = R.image.ic_list_selection()
        
        lightThemeView.rightImageView.image = R.image.ic_list_selection()
        drakThemeView.rightImageView.image = R.image.ic_list_selection()
    }
    
    // MARK: - Action
    
    private func selectedTheme(mode: FYThemeMode) {
        
        switch mode {
        case .light:
            lightThemeView.isHiddenArrow(isHidden: false)
            drakThemeView.isHiddenArrow(isHidden: true)
            systemThemeView.isHiddenArrow(isHidden: true)
            themeService.switch(.light)
            
        case .dark:
            themeService.switch(.dark)
            drakThemeView.isHiddenArrow(isHidden: false)
            lightThemeView.isHiddenArrow(isHidden: true)
            systemThemeView.isHiddenArrow(isHidden: true)
            
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
                
                systemThemeView.isHiddenArrow(isHidden: false)
                lightThemeView.isHiddenArrow(isHidden: true)
                drakThemeView.isHiddenArrow(isHidden: true)
            }
        }
                
        FYThemeCenter.shared.saveSelectionTheme(mode: mode)
    }
}
