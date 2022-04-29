//
//  LWLanguageManager.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/3/4.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import Foundation
import Localize_Swift
import Rswift

public enum kLanguageType: String {
    
    case kEnglish = "en"
    case kChinese = "zh-Hans"
    
    static let allLanguages = [kEnglish, kChinese]
    static let alllocalizedStr = allLanguages.map { (type) -> String in
        return type.rawValue
    }
    
    func serverLanguage() -> String {
        switch self {
        case .kEnglish:
            return "en"
        default:
            return "cn"
        }
    }
    
    func getLanguageRaw() -> String {
        switch self {
        case .kEnglish:
            return "English"
        default:
            return "简体中文"
        }
    }
}

class LanguageManager: NSObject {
    
    /// 单利
    static let manager = LanguageManager()
    
    /// 当前已选语言
    var selectedLanguage = kLanguageType(rawValue: "zh-Hans")

    /// 当前所有语言
    var currentLanguages: [String] {
        return ["简体中文".rLocalized(), "英文".rLocalized()]
    }
    
    override init() {}
    
    
    /// 初始化设置
    func initConfig() {
        let languageCode = Localize.defaultLanguage()
        
        let language = UserDefaults.standard.string(forKey: kAppLanguageUserDefaultsKey) ??
           languageCode
        self.selectedLanguage = kLanguageType.init(rawValue: language)
        Localize.setCurrentLanguage(language)
    }
    
    /// 切换语言
    ///
    /// - Parameter type: 语言类型
    func setCurrentLanguage(_ languageType: kLanguageType) {
        if languageType == self.selectedLanguage {
            return
        }
        
        UserDefaults.standard.set(languageType.rawValue, forKey: kAppLanguageUserDefaultsKey)
        UserDefaults.standard.synchronize()
        
        LanguageManager.manager.selectedLanguage = languageType
        Localize.setCurrentLanguage(languageType.rawValue)
        
        // rest
        restRootController()
    }
    
    // 切换根控制器
    private func restRootController() {
        let tabBar = FYBaseTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = tabBar
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        
        // FPS
        AppDelegate.app.setupFPSStatus()
    }
}

// MARK: - R.string.localizable

typealias Lca = R.string.localizable

extension String {
    
    /// r优化的国际化语言
    ///
    /// - Returns: 对应国际化语言
    func rLocalized() -> String {
        return self.localized()
    }
}

