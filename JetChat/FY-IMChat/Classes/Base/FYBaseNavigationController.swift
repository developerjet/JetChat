//
//  FYBaseNavigationController.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit
import RxTheme
import RxSwift
import RxCocoa

class FYBaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var titleTextAttributes: [NSAttributedString.Key : NSObject] {
        return [NSAttributedString.Key.font:UIFont.PingFangMedium(17),
                NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.theme.buttonImage(from: themed { $0.nav_back_image }, for: .normal)
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
        
        settingNavBarStyle()
        
        // 设置代理
        delegate = self
        self.navigationBar.isTranslucent = false
        self.interactivePopGestureRecognizer?.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    private func addThemeChangedNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(settingNavBarStyle), name: .kTraitCollectionDidChange, object: nil)
    }

    // MARK: - Notification
    
    @objc private func settingNavBarStyle() {
        
        themeService.typeStream.subscribe ({ theme in
            
            if #available(iOS 13, *) {
                let appearance = UINavigationBarAppearance()
                // 重置导航栏背景颜色和阴影
                appearance.configureWithOpaqueBackground()
                appearance.shadowImage = UIImage()
                appearance.shadowColor = nil
                appearance.titleTextAttributes = self.titleTextAttributes
                
                switch theme.event.element {
                case .light:
                    // 设置背景色
                    appearance.theme.backgroundColor = themed { $0.FYColor_Nav_BackgroundColor }
                    self.navigationBar.standardAppearance = appearance
                    self.navigationBar.scrollEdgeAppearance = appearance
                    
                default:
                    // 设置背景色
                    appearance.theme.backgroundColor = themed { $0.FYColor_Nav_BackgroundColor }
                    self.navigationBar.standardAppearance = appearance
                    self.navigationBar.scrollEdgeAppearance = appearance
                }
            }
            else {
                // 导航栏背景颜色
                self.navigationBar.theme.backgroundColor = themed { $0.FYColor_Nav_BackgroundColor }
            }
            
            self.navigationBar.theme.barTintColor = themed { $0.FYColor_Nav_BackgroundColor }
            self.navigationBar.titleTextAttributes = self.titleTextAttributes
            self.navigationBar.tintColor = .Color_White_FFFFFF
            
        }).disposed(by: rx.disposeBag)
        
    }
}


// MARK: - UINavigationControllerDelegate

extension FYBaseNavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            // 隐藏tabBar
            viewController.hidesBottomBarWhenPushed = true
            
            let backItem = UIBarButtonItem(customView: self.backButton)
            viewController.navigationItem.leftBarButtonItem = backItem
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
