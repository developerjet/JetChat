//
//  FYBaseNavigationController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import SwiftTheme

class FYBaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(UIImage(named: "icon_nav_back_white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left:-20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize
        makeNavigation()
        // 设置代理
        delegate = self
        navigationBar.isTranslucent = false
        interactivePopGestureRecognizer?.delegate = self
        automaticallyAdjustsScrollViewInsets = false;
    }
    
    // 初始化导航栏
    func makeNavigation() {
        let navigationBar = UINavigationBar.appearance()
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        
        navigationBar.theme_tintColor = "Global.navBarTitleColor"
        navigationBar.theme_barTintColor = "Global.navBarBgColor"
        navigationBar.theme_titleTextAttributes = ThemeStringAttributesPicker(keyPath: "Global.navBarTitleColor") { value -> [NSAttributedString.Key : AnyObject]? in
            guard let rgba = value as? String else {
                return nil
            }
            
            let color = UIColor(rgba: rgba)
            let shadow = NSShadow(); shadow.shadowOffset = CGSize.zero
            let titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.shadow: shadow
            ]
            
            return titleTextAttributes
        }
    }
}


// MARK:- UINavigationControllerDelegate

extension FYBaseNavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            // 隐藏tabBar
            viewController.hidesBottomBarWhenPushed = true
            
            let leftBarButtonItem = UIBarButtonItem(customView: self.backButton)
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
            // 手势可用
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    /// 返回&出栈
    @objc private func pop() {
        
        self.popViewController(animated: true)
    }
}
