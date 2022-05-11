//
//  AppDelegate.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/2/27.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit
import Reachability
import WCDBSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// 单利
    static let app: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    let reachability = try! Reachability.init()
    
    var window: UIWindow?

    var lastThemeMode: FYThemeMode {
        return FYThemeCenter.shared.currentTheme
    }
    
    /// fps
    public lazy var fpsLabel: FPSLabel = {
        let label = FPSLabel.init(frame: CGRect.init(x: kScreenW - 80, y: (kScreenH - 30)/2, width: 70, height: 30))
        label.backgroundColor = .red
        label.textColor = .white
        return label
    }()
    
    /// 毛玻璃
    fileprivate lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect.init(style: lastThemeMode == .dark ? .dark : .light)
        let vi = UIVisualEffectView(effect: blurEffect)
        vi.frame = UIScreen.main.bounds
        vi.alpha = 0
        return vi
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // app initialize
        appInitializes()
        // init rootViewController
        setupViewController()
        // create db table
        createWcdbTable()
        // FPS
        setupFPSStatus()
        
        return true
    }

    // 快要进入前台
    func applicationWillResignActive(_ application: UIApplication) {
        reloadWidgetData()
    }
    
    // 已经退到后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        reloadWidgetData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    // 已经进入到前台
    func applicationDidBecomeActive(_ application: UIApplication) {
        reloadWidgetData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // 接收Widget点击交互
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteURL.absoluteString.contains("chatId") {
            let urlString = url.absoluteURL.absoluteString
            let chatObjc = urlString.components(separatedBy:"=")
            if let chatId = chatObjc.last {
                printLog("Widget safe chatId === \(chatId)")
                openWidgetChat(chatId: chatId.int ?? -1)
            }
        }
        
        return true
    }
    
    // MARK: - Widget
    
    private func openWidgetChat(chatId: Int) {
        guard chatId > 0 else { return }
        
        let chatModel = FYDBQueryHelper.shared.qureyFromChatId(chatId)
        let chatVC = FYChatBaseViewController(chatModel: chatModel)
        
        if let tabbar = AppDelegate.app.window?.rootViewController as? UITabBarController {
            if let nav = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController {
                nav.pushViewController(chatVC)
            }
        }
    }
    
    // MARK: -
    
    private func addWindowVisualEffect() {
        
        UIApplication.shared.keyWindow?.addSubview(self.visualEffectView)
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
        }
    }
    
    private func removeWindowVisualEffect() {
        
        if !visualEffectView.isEqual(nil)  {
            UIView.animate(withDuration: 0.25) {
                self.visualEffectView.alpha = 0
            } completion: { finished in
                self.visualEffectView.removeFromSuperview()
            }
        }
    }

    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}



