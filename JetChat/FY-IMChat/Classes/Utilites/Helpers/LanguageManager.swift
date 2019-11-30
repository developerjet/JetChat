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
    case kKorean = "ko"
    case kJapanse = "ja"
    case kVietnamese = "vi"
    case kGerman = "de"
    
    static let allLanguages = [kEnglish, kChinese, kKorean, kJapanse, kVietnamese, kGerman]
    static let alllocalizedStr = allLanguages.map { (type) -> String in
        return type.rawValue
    }

    func localizedStr() -> String {
        switch self {
        case .kEnglish:
            return "en"
        case .kChinese:
            return "zh"
        case .kKorean:
            return "ko"
        case .kJapanse:
            return "ja"
        case .kVietnamese:
            return "vi"
        default:
            return "de"
        }
    }
    
    func serverLanguage() -> String {
        switch self {
        case .kEnglish:
            return "en"
        case .kChinese:
            return "cn"
        case .kKorean:
            return "ko"
        case .kJapanse:
            return "ja"
        case .kVietnamese:
            return "vi"
        default:
            return "de"
        }
    }
    
    func codePath() -> String {
        return Bundle.main.path(forResource: "code_\(self.localizedStr())", ofType: "plist") ?? ""
    }
    
    func languageStr() -> String {
        switch self {
        case .kEnglish:
            return "English"
        case .kChinese:
            return "简体中文"
        case .kKorean:
            return "한국어"
        case .kVietnamese:
            return "Tiếng Việt"
        case .kJapanse:
            return "日本語"
        default:
            return "Deutsch"
        }
    }
}

class LanguageManager: NSObject {
    
    /// 单利
    static let manager = LanguageManager()
    
    var bundle: Bundle?
    
    /// 当前已选语言
    var selectedLanguage = kLanguageType.init(rawValue: "zh-Hans")
    
    override init() {}
    
    
    /// 初始化设置
    func initConfig() {
        var languageCode = Localize.defaultLanguage()
        
        if languageCode.contains("zh") {
            languageCode = "zh-Hans"
        }
        
        if kLanguageType.alllocalizedStr.contains(languageCode) == false {
            languageCode = "en"
        }
        
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
    func restRootController() {
        // 如果用户token存在
        if ((UserInfoManager.shared.userInfo?.token.length)! > 0) {
            let tabBarVC = FYBaseTabBarController()
            UIApplication.shared.keyWindow?.rootViewController = tabBarVC
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            tabBarVC.selectedIndex = 3
        }else {
            let startVC = FYBaseTabBarController()
            let nav = FYBaseNavigationController(rootViewController: startVC)
            UIApplication.shared.keyWindow?.rootViewController = nav
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
}

// MARK: - R.string.localizable

typealias Lca = R.string.localizable
extension StringResource {
    /// r优化的国际化语言
    ///
    /// - Returns: 对应国际化语言
    func rLocalized() -> String {
        return self.key.localized()
    }
}

