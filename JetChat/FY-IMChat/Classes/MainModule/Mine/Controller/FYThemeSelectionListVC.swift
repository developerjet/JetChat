//
//  FYThemeSelectionListVC.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/30.
//  Copyright © 2022 MacOsx. All rights reserved.
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
        
        let lastThemeMode = FYThemeCenter.shared.readSelectedTheme()
        
        let lightTheme = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: lastThemeMode == .light ? false : true)
                .title(text: "白天模式".rLocalized())
                .contentState(state: .highlight)
                .clickClosure({ [weak self] in
                    self?.themeSelection(mode: .light)
                }).last(isLine: true)
        }
            .adhere(toSuperView: self.view)
            .layout(snapKitMaker: { make in
                make.top.equalTo(self.view)
                make.left.right.equalTo(self.view)
                make.height.equalTo(50)
            })
        
        
        let drakTheme = FYFastGridListView().config { (view) in
            view.isHiddenArrow(isHidden: lastThemeMode == .drak ? false : true)
                .title(text: "黑夜模式".rLocalized())
                .contentState(state: .normal)
                .clickClosure({ [weak self] in
                    self?.themeSelection(mode: .drak)
                }).last(isLine: true)
        }
            .adhere(toSuperView: self.view)
            .layout(snapKitMaker: { make in
                make.top.equalTo(lightTheme.snp.bottom)
                make.left.right.equalTo(self.view)
                make.height.equalTo(lightTheme)
            })
        
        lightTheme.rightImageView.image = R.image.ic_list_selection()
        drakTheme.rightImageView.image = R.image.ic_list_selection()
    }
    
    // MARK: - Action
    
    private func themeSelection(mode: FYThemeMode) {
        
        switch mode {
        case .light:
            themeService.switch(.light)
        default:
            themeService.switch(.dark)
        }

        navigationController?.popToRootViewController(animated: false)
        FYThemeCenter.shared.saveSelectionTheme(mode: mode, isRestWindow: true)
    }
}
