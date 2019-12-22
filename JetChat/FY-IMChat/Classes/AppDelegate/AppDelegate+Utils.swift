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
import SwiftTheme


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
            showReachability("当前网络已断开")
        }
    }
    
    func showReachability(_ message: String) {
        //MBConfiguredHUD.showImageError(message)
        MessagesAlert.showTopTips(message)
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
    
    // MARK:- 登入&登出动画
    public func logInOrOut(_ type: AppLogInOutType) {
//        let animation = CATransition()
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//        switch type {
//        case .logIn:
//            animation.subtype = CATransitionSubtype(rawValue: "fromRight")
//        case .logOut:
//            animation.subtype = CATransitionSubtype(rawValue: "fromLeft")
//        }
//        animation.type = CATransitionType(rawValue: "oglFlip") //翻转
//        animation.duration = 0.6
//        animation.startProgress = 0.25
//        animation.endProgress = 1
//
//        AppDelegate.app.window?.layer.add(animation, forKey: "")
//
//        switch type {
//        case .logIn:
//            let tabBarVC = LWBaseTabBarController()
//            AppDelegate.app.window?.rootViewController = tabBarVC
//        case .logOut:
//            let startVC = LWUserNameLoginController()
//            let nav = LWBaseNavigationController(rootViewController: startVC)
//            AppDelegate.app.window?.rootViewController = nav
//        }
        
//        AppDelegate.app.window?.makeKeyAndVisible()
    }
    
    // MARK:- 设置窗口根控制器
    func setupViewController() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let tabBar = FYBaseTabBarController()
        AppDelegate.app.window?.rootViewController = tabBar
        
        // 第一次显示引导页
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
//            if self.isFirstLaunch() == true {
//                let launchVC = self.setupLaunchController()
//                AppDelegate.app.window?.rootViewController = launchVC
//            }else {
//                if UserInfoManager.shared.userInfo?.token.isEmpty == false {
//                    let pinvc = LWSetPINController()
//                    pinvc.type = .EnterPIN
//                    AppDelegate.app.window?.rootViewController = pinvc
//                }else {
//                    let startVC = LWUserNameLoginController()
//                    let nav = LWBaseNavigationController(rootViewController: startVC)
//                    AppDelegate.app.window?.rootViewController = nav
//                }
//            }
//        }
        
        AppDelegate.app.window?.makeKeyAndVisible()
    }
    
    /// 设置新特性启动页
//    func setupLaunchController() -> UIViewController {
//        let launchVC = FYLaunchBrowseController()
//        launchVC.currentPageIndicatorTintColor = .white
//        launchVC.pageIndicatorTintColor = .textPlaceholderColor()
//        let launchImages = [SBLaunchConfig(image: R.image.icon_launch_01(),
//                                           title: Lcazero_app_guide_one.rLocalized()),
//                            SBLaunchConfig(image: R.image.icon_launch_02(),
//                                           title: Lcazero_app_guide_two.rLocalized()),
//                            SBLaunchConfig(image: R.image.icon_launch_03(),
//                                           title: Lcazero_app_guide_three.rLocalized())]
//        launchVC.launchImages = launchImages
//
//        return launchVC
//    }
    
    // MARK:- App Launch record
    func isFirstLaunch() -> Bool {
        let isLaunch = UserDefaults.standard.bool(forKey: kAppLaunchUserDefaultsKey)
        if (isLaunch == false) {
            UserDefaults.standard.set(true, forKey: kAppLaunchUserDefaultsKey)
            UserDefaults.standard.synchronize()
            return true
        }else {
            return false
        }
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
    
    func appInitializes() {
        /// Themes
        setupAppTheme()
        
        startRegisterSDK()
        keyboardManager()
        checkCommonState()
        appearanceSetting()
        networkStatusListener()
        LanguageManager.manager.initConfig()
    }
    
    func setupAppTheme() {
        switch AppThemes.lastSetedTheme() {
        case .light:
            // default theme
            ThemeManager.setTheme(plistName: "Light", path: .mainBundle)
        default:
            ThemeManager.setTheme(plistName: "Night", path: .mainBundle)
        }
        
        // status bar
        UIApplication.shared.theme_setStatusBarStyle("UIStatusBarStyle", animated: true)
    }
    
    
    /// 第三方SDK注册
    func startRegisterSDK() {
        // 初始化腾讯Bugly
        //Bugly.start(withAppId: HttpApiConfig.buglyId)
    }
    
    /// 主要状态更新检测
    func checkCommonState() {
        UserDefaults.standard.removeObject(forKey: kUserAccountSaveUserDefaultsKey)
        UserDefaults.standard.synchronize()
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


