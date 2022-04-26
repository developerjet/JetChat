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

    func localizedStr() -> String {
        switch self {
        case .kEnglish:
            return "en"
        default:
            return "zh"
        }
    }
    
    func serverLanguage() -> String {
        switch self {
        case .kEnglish:
            return "en"
        default:
            return "cn"
        }
    }
    
    func codePath() -> String {
        return Bundle.main.path(forResource: "code_\(self.localizedStr())", ofType: "plist") ?? ""
    }
    
    func languageStr() -> String {
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

