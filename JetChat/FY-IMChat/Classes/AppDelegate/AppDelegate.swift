//
//  AppDelegate.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/27.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import Reachability
import WCDBSwift

public protocol SelfAware: class {
    static func awake()
}

enum AppLogInOutType {
    case logIn
    case logOut
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// 单利
    static let app: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    
    let reachability = Reachability()!
    
    var window: UIWindow?
    
    public lazy var fpsLabel: FPSLabel = {
        let label = FPSLabel.init(frame: CGRect.init(x: kScreenW - 80, y: 90, width: 70, height: 30))
        label.textColor = .white
        label.backgroundColor = .red
        return label
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // app initialize
        appInitializes()
        // init rootViewController
        setupViewController()
        // create db table
        createWcdbTabel()
        // FPS
        setupFPSStatus()
        
        return true
    }
    
    private func setupFPSStatus() {
        #if DEBUG
        UIApplication.shared.keyWindow?.addSubview(fpsLabel)
        #endif
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //LWAnalyticsHelper.logAppLaunch()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}

