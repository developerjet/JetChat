//
//  FYBaseNavigationController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit

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
        
        didInitialize()
    }
    
    // 初始化导航栏
    func didInitialize() {
        
        self.navigationBar.shadowImage = UIImage()
        
        // 导航栏的背景颜色
        self.navigationBar.backgroundColor = .colorWithHexStr("696969")
        
        let titleTextAttributes = [NSAttributedString.Key.font:UIFont.PingFangMedium(17),
                                   NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let navBackgroundColor = UIColor.colorWithHexStr("696969")
        
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            //重置导航栏背景颜色和阴影
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = navBackgroundColor
            appearance.shadowImage = UIImage()
            appearance.shadowColor = nil
            appearance.titleTextAttributes = titleTextAttributes
            
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }else {
            self.navigationBar.barTintColor = navBackgroundColor
            self.navigationBar.titleTextAttributes = titleTextAttributes
            
            let backgroundImage = UIImage.imageWithColor(navBackgroundColor)
            self.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        
        // 设置代理
        delegate = self
        self.navigationBar.isTranslucent = false
        self.interactivePopGestureRecognizer?.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
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
