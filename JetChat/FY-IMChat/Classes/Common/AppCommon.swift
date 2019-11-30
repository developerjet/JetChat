//
//  AppCommon.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/27.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import Reachability
import SnapKit


// MARK:- 常用距离
public let kScreen  = UIScreen.main.bounds
public let kScreenW = UIScreen.main.bounds.size.width
public let kScreenH = UIScreen.main.bounds.size.height

public let kMargin = kFitScale(AT: 10)
public let kLineMargin = kFitScale(AT: 1)

public let isIphoneX = { () -> Bool in
    var isX = false
    if #available(iOS 11.0, *) {
        isX = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > CGFloat(0.0)
    }
    return isX
}

public let kWindowSafeAreaInset = { () -> UIEdgeInsets in
    var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *) {
        insets = UIApplication.shared.keyWindow?.safeAreaInsets ?? insets
    }
    return insets
}

public let kSafeAreaTop = kWindowSafeAreaInset().top == 0 ? 20 : kWindowSafeAreaInset().top
public let kSafeAreaBottom = kWindowSafeAreaInset().bottom
public let kStatusH = kWindowSafeAreaInset().top
public let kNavigaH = 44 + kStatusH
public let kTabBarH = 49 + kSafeAreaBottom

// MARK:- 动画执行时间
let kDuration: TimeInterval = 3.0

// MARK:- 偏好设置存储
/// 应用是否首次启动
public let kAppLaunchUserDefaultsKey = "kAppLaunchUserDefaultsKey"
/// 应用当前语言设置
public let kAppLanguageUserDefaultsKey = "kAppLanguageUserDefaultsKey"
/// 用户基本信息
public let kUserInfoSaveUserDefaultsKey = "kUserInfoSaveUserDefaultsKey"
/// 用户名存储显示
public let kUserAccountSaveUserDefaultsKey = "kUserAccountSaveUserDefaultsKey"
/// 更换AppIcon
public let kChangedAppIocnUserDefaultsKey = "kChangedAppIocnUserDefaultsKey"
/// 白天夜间模式
public let kThemeSettingUserDefaultKey = "kThemeSettingUserDefaultKey"


// MARK: - FileManager Path
public let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
public let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]


// MARK:- 当前窗口
let kCurrentWindow = UIApplication.shared.keyWindow

// MARK:- 自定义打印日志
func printLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    //文件名、方法、行号、打印信息
    #if DEBUG
    print("方法:\(methodName)\n行号:\(lineNumber)\n打印信息:\(message)");
    #endif
}


// MARK:- 系统信息相关
let infoDictionary = Bundle.main.infoDictionary!
/// 程序名称
let appDisplayName = infoDictionary["CFBundleDisplayName"] as! String
/// 主程序版本号
let majorVersion = infoDictionary["CFBundleShortVersionString"] as! String //主程序版本号

/// 设备唯一标识码
public let kDeviceUUID = { () -> String in
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    }
    return ""
}



// MARK:- 屏幕适配375 | 6s尺寸
func kFitScale(AT: CGFloat) -> CGFloat {
    return (UIScreen.main.bounds.width / 375) * AT
}

