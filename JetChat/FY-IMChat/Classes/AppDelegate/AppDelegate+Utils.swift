//
//  AppDelegate+Utils.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation
import Reachability
import IQKeyboardManagerSwift
import SnapKit
import Localize_Swift
import RxSwift
import RxCocoa
import NSObject_Rx
import SwifterSwift
import RxTheme

extension AppDelegate {
    
    // MARK:- NetworkStatusListener
    // 开始网络连接状态监听
    func networkStatusListener() {
        // 1.设置网络状态消息监听
        // 2.获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            // 3.开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        // 4.准备获取网络连接信息
        let curReachability = note.object as! Reachability
        // 5.判断网络连接状态A
        switch curReachability.connection {
        case .wifi:
            printLog("Reachable via WiFi")
        case .cellular:
            printLog("Reachable via Cellular")
        case .none:
            printLog("Network not reachable")
            showReachability("当前网络已断开".rLocalized())
        case .unavailable:
            printLog("Network not unavailable")
            showReachability("当前网络已断开".rLocalized())
        }
    }
    
    func showReachability(_ message: String) {
        MBHUD.showImageError(message)
    }
    
    // MARK:- AppearanceSetting
    func appearanceSetting() {
        // iOS 11 及其以上系统运行
        if #available(iOS 11, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().contentInsetAdjustmentBehavior = .never
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }
    
    // MARK:- 设置窗口根控制器
    func setupViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let tabBar = FYBaseTabBarController()
        AppDelegate.app.window?.rootViewController = tabBar
        AppDelegate.app.window?.makeKeyAndVisible()
    }
    
    // MARK:- 键盘管理
    func keyboardManager() {
        //开启键盘监听
        IQKeyboardManager.shared.enable = true
        //控制点击背景是否收起键盘
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //控制键盘上的工具条文字颜色是否用户自定义
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        //IQKeyboardManager.sharedManager().shouldToolbarUsesTextFieldTintColor = true
        //将右边Done改成完成
        //IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        // 控制是否显示键盘上的工具条
        IQKeyboardManager.shared.enableAutoToolbar = true
        //最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘
        IQKeyboardManager.shared.toolbarManageBehaviour = .byPosition
    }
    
    func configTheme() {
        // 上次所选主题
        let lastThemeMode = FYThemeCenter.shared.currentTheme
        if (lastThemeMode == .system) {
            if #available(iOS 13.0, *) {
                // iOS13可跟随系统
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    print("System Dark mode")
                    themeService.switch(.dark)
                }else {
                    print("System Light mode")
                    themeService.switch(.light)
                }
            }
        }else {
            // 自行选择的
            switch lastThemeMode {
            case .light:
                themeService.switch(.light)
            default:
                themeService.switch(.dark)
            }
        }
    }
    
    // FPS
    func setupFPSStatus() {
#if DEBUG
        UIApplication.shared.keyWindow?.addSubview(fpsLabel)
#endif
    }
    
    func appInitializes() {
        configTheme()
        keyboardManager()
        appearanceSetting()
        networkStatusListener()
        LanguageManager.manager.initConfig()
    }
}


extension AppDelegate {
    
    /// 获取window当前导航控制器
    public var currentViewController: UIViewController? {
        get {
            guard UIApplication.shared.keyWindow?.rootViewController != nil else {
                return nil
            }
            
            if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                return nav
            }
            if let tab = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                return tab
            }
            if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                return rootVC
            }
            
            return nil
        }
    }
}


