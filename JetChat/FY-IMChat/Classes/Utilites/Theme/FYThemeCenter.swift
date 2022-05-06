//
//  FYThemeCenter.swift
//  FY-JetChat
//
//  Created by Jett on 2022/4/30.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit
import RxSwift
import RxTheme

let themeService = ThemeType.service(initial: .dark)

public enum FYThemeMode: Int {
    /// 跟随系统
    case system = 0
    /// 白天模式
    case light = 1
    /// 黑夜模式
    case dark = 2
}

protocol Theme {
    
    // MARK: - 导航栏
    /// 导航栏背景色   黑-> 10171B 白-> 696969
    var FYColor_Nav_BackgroundColor: UIColor { get }
    
    // MARK: - TabBar
    /// TabBar背景色 黑-> 181D21 白-> FFFFFF
    var FYColor_Tab_BackgroundColor: UIColor { get }
    
    // MARK: - 背景色
    /// 一级模块背景色     黑 -> 181D21 白 -> FFFFFF
    var FYColor_BackgroundColor_V1: UIColor { get }
    
    /// 二级模块背景色     黑 -> 252D33 白 -> F6F6F6
    var FYColor_BackgroundColor_V2: UIColor { get }
    
    /// 三级级模块背景色   黑 -> FFFFFF 白 -> 000000
    var FYColor_BackgroundColor_V3: UIColor { get }
    
    /// 黑 -> FFFFFF 白 -> F6F6F6
    var FYColor_BackgroundColor_V4: UIColor { get }
    
    /// 黑 -> 252D33 白 -> FFFFFF
    var FYColor_BackgroundColor_V5: UIColor { get }
    
    /// 黑 -> 2B343B 白 -> 384955
    var FYColor_BackgroundColor_V6: UIColor { get }
    
    /// 黑 -> 10171B 白 -> C0C0C0
    var FYColor_BackgroundColor_V7: UIColor { get }
    
    /// 黑 -> 000000 白 -> F6F6F6
    var FYColor_BackgroundColor_V8: UIColor { get }
    
    /// 黑 -> 10171B 白 -> 2C363E
    var FYColor_BackgroundColor_V9: UIColor { get }
    
    /// 黑 -> 2C363E 白 -> F6F6F6
    var FYColor_BackgroundColor_V10: UIColor { get }
    
    /// 黑 -> 0F1317 白 -> F6F6F6
    var FYColor_BackgroundColor_V11: UIColor { get }
    
    /// 黑 -> 2C363E 白 -> FFFFFF
    var FYColor_BackgroundColor_V12: UIColor { get }
    
    /// 黑 -> 272D34 白 -> F7F7F7
    var FYColor_BackgroundColor_V13: UIColor { get }
    
    /// 黑 -> 272D34 白 -> F8F8F8
    var FYColor_BackgroundColor_V14: UIColor { get }
    
    /// 黑 -> 10171B 白 -> CCCCCC
    var FYColor_BackgroundColor_V15: UIColor { get }
    
    //MARK: - 边框颜色
    /// 黑 -> 1E2328 白 -> E5E5E5
    var FYColor_BorderColor_V1: UIColor { get }
    
    /// 黑 -> 5A636D 白 -> E5E5E5
    var FYColor_BorderColor_V2: UIColor { get }
    
    /// 黑 -> 12171B 白 -> F6F6F6
    var FYColor_BorderColor_V3: UIColor { get }
    
    /// 黑 -> 181D21 白 -> E5E5E5
    var FYColor_BorderColor_V4: UIColor { get }
    
    /// 黑 -> FFFFFF 白 -> E5E5E5
    var FYColor_BorderColor_V5: UIColor { get }
    
    /// 黑 -> 1E2328 白 -> F6F6F6
    var FYColor_BorderColor_V6: UIColor { get }
    
    /// 黑 -> 272E37 白 -> E5E5E5
    var FYColor_BorderColor_V7: UIColor { get }
    
    /// 黑 -> 12171B 白 -> E5E5E5
    var FYColor_BorderColor_V8: UIColor { get }
    
    /// 黑 -> 2C363E 白 -> E5E5E5
    var FYColor_BorderColor_V9: UIColor { get }
    
    // MARK: - 文本颜色 (Placeholder)
    /// 黑 -> 919191 白 -> B4B4B4
    var FYColor_Placeholder_Color_V1: UIColor { get }
    
    /// 黑 -> 6D777C 白 -> 999999
    var FYColor_Placeholder_Color_V2: UIColor { get }
    
    /// 黑 -> FFFFFF 白 -> 999999
    var FYColor_Placeholder_Color_V3: UIColor { get }
    
    // MARK: - 文本颜色 (TextColor)
    /// 黑 -> FFFFFF 白 -> 000000
    var FYColor_Main_TextColor_V1: UIColor { get }
    
    /// 黑 -> 5A636D 白 -> 77808A
    var FYColor_Main_TextColor_V2: UIColor { get }
    
    /// 黑 -> FFFFFF 白 -> 77808A
    var FYColor_Main_TextColor_V3: UIColor { get }
    
    /// 黑 -> 919191 白 -> 1D1E34
    var FYColor_Main_TextColor_V4: UIColor { get }
    
    /// 黑 -> 000000 白 -> FFFFFF
    var FYColor_Main_TextColor_V5: UIColor { get }
    
    /// 黑 -> 000000 白 -> 000000
    var FYColor_Main_TextColor_V6: UIColor { get }
    
    /// 黑 -> 5A636D 白 -> B4B4B4
    var FYColor_Main_TextColor_V7: UIColor { get }
    
    /// 黑 -> FFBF27 白 -> 000000
    var FYColor_Main_TextColor_V8: UIColor { get }
    
    /// 黑 -> FFFFFF 白 -> 666666
    var FYColor_Main_TextColor_V9: UIColor { get }
    
    /// 黑 -> 9BA1A4 白 -> 666666
    var FYColor_Main_TextColor_V10: UIColor { get }
    
    /// 黑 -> FFFFFF 白 -> 1A1F24
    var FYColor_Main_TextColor_V11: UIColor { get }
    
    /// 黑 -> FFFFFF 白 -> 1890FF
    var FYColor_Main_TextColor_V12: UIColor { get }
}

enum ThemeType: ThemeProvider {

    case light
    case dark

    var associatedObject: Theme {
        switch self {
        case .light:
            return FYLightTheme()
        case .dark:
            return FYDarkTheme()
        }
    }
}

func themed<T>(_ mapper: @escaping ((Theme) -> T)) -> ThemeAttribute<T> {
    return themeService.attribute(mapper)
}

// MARK: - Center Manager

class FYThemeCenter: NSObject {
    
    /// 单利
    static let shared = FYThemeCenter()
    
    override init() { }
    
    
    /// 保存当前所选主题模式
    /// - Parameters:
    ///   - themeMode: 主题模式
    ///   - isRestWindow: 是否重新载入窗口
    func saveSelectionTheme(mode: FYThemeMode, isRestWindow: Bool = false) {
        UserDefaults.standard.set(mode.rawValue, forKey: kThemeSettingUserDefaultKey)
        UserDefaults.standard.synchronize()
        
        if (isRestWindow) {
            self.resetAppWindow()
        }
    }
    
    
    /// 当前已选主题模式
    /// - Returns: 已选主题模式
    var currentTheme: FYThemeMode {
        if let lastTheme = UserDefaults.standard.value(forKey: kThemeSettingUserDefaultKey) as? Int {
            return FYThemeMode(rawValue: lastTheme) ?? .light
        }else {
            return .light
        }
    }
    
    /// 切换根控制器
    private func resetAppWindow() {
        let tabBar = FYBaseTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = tabBar
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
        // FPS
        AppDelegate.app.setupFPSStatus()
    }
    
}
