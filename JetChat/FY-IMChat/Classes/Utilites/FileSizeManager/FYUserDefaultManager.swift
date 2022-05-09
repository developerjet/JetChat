//
//  FYUserDefaultManager.swift
//  FY-IMChat
//
//  Created by Jett on 2022/5/7.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit
import Foundation

class FYUserDefaultManager: NSObject {

    /// 存储当前值
    /// - Parameters:
    ///   - object: 需要存储的数据
    ///   - key: 存储数据对应的key
    class func saveObject(_ object: Any, key: String) {
        UserDefaults.standard.setValue(object, forKey: key)
        UserDefaults.standard.synchronize()
    }

    
    /// 获取已存储的值
    /// - Parameter key: 已存储数据对应的key
    class func readObjectForKey(_ key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    // MARK: - Widget
    
    class func saveWidgetObject(_ object: Any, widgetKey: String = "widgetKey", suiteName: String = "group.com.jetchat.2022.JetChatWidget") {
        let userDefaults = UserDefaults(suiteName: suiteName)
        userDefaults?.set(object, forKey: widgetKey)
        userDefaults?.synchronize()
    }
    
    class func readWidgetObject(_ widgetKey: String = "widgetKey", suiteName: String = "group.com.jetchat.2022.JetChatWidget") -> Any? {
        let userDefaults = UserDefaults(suiteName: suiteName)
        if let object = userDefaults?.value(forKey: widgetKey) as? Any {
            return object
        }
        return nil
    }
}
