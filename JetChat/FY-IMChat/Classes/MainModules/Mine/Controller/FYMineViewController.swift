//
//  FYMineViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/8/18.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import SwiftTheme
import RxSwift

class FYMineViewController: FYBaseConfigViewController {

    lazy var themeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.theme_setTitleColor("Global.textColor", forState: .normal)
        let current = AppThemes.lastSetedTheme()
        if #available(iOS 13.0, *) {
            let image = UIImage(systemName: current == .light ? "moon.stars" : "sun.min")
            button.setImage(image, for: .normal)
        } else {
            button.setTitle(current == .light ? "夜间" : "白天", for: .normal)
        }
        button.rxTapClosure { [weak self] in
            guard let self = self else { return }
            self.themeChange(button)
        };
        return button
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "我"
        let rightBarButtonItem = UIBarButtonItem(customView: self.themeBtn)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(title: "设置", style: .plain, target: self, action: #selector(settingAction))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

// MARK: - Action

extension FYMineViewController {
    
    @objc func settingAction() {
        let settingVC = FYSettingViewController()
        navigationController?.pushViewController(settingVC)
    }
    
    @objc func themeChange(_ button: UIButton) {
        let current = AppThemes.lastSetedTheme()
        switch current {
        case .light:
            if #available(iOS 13.0, *) {
                button.setImage(UIImage(systemName: "sun.min"), for: .normal)
            } else {
                button.setTitle("白天", for: .normal)
            }
            AppThemes.switchTo(.night)
            break
        default:
            if #available(iOS 13.0, *) {
                button.setImage(UIImage(systemName: "moon.stars"), for: .normal)
            } else {
                button.setTitle("夜间", for: .normal)
            }
            AppThemes.switchTo(.light)
        }
    }
}
