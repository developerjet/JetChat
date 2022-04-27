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
        
        // Do any additional setup after loading the view.
        let leftBarButtonItem = UIBarButtonItem(title: "设置".rLocalized(), style: .plain, target: self, action: #selector(settingAction))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

// MARK: - Action

extension FYMineViewController {
    
    @objc func settingAction() {
        let settingVC = FYSettingViewController()
        navigationController?.pushViewController(settingVC)
    }
}
