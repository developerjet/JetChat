//
//  Notification+Name.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/10/10.
//  Copyright © 2019 MacOsx. All rights reserved.
//  通知便捷使用

import Foundation

// MARK: - NSNotificationName

extension NSNotification.Name {
    
    /// 主题更改
    public static let kThemeDidChanged = Notification.Name("kThemeDidChanged")
    
    /// 网络状态监听
    public static let kReachabilityChanged = Notification.Name(rawValue:"ReachabilityChangedNotification")
    
    /// 刷新消息列表
    public static let kNeedRefreshSesstionList = Notification.Name(rawValue:"kNeedRefreshSesstionList")
    
    /// 退出群聊
    public static let kNeedRefreshChatInfoList = Notification.Name(rawValue:"kNeedRefreshChatInfoList")
}


// MARK: - NotificationCenter

public typealias NotiCenter = NotificationCenter

extension NotificationCenter {
    
    /// 发送通知内容
    static func postNoti(_ name: NSNotification.Name, object: Any? = nil) {
        self.default.post(name: name, object: nil)
    }
    
    /// 发送通知传递实体内容
    static func postNotiWithUserInfo(_ name: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable : Any] = [AnyHashable : Any]()) {
        self.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
    
    func observe(name: NSNotification.Name?, object: Any?, queue: OperationQueue?, using block: @escaping (Notification) ->()) -> NotificationToken {
          let token = addObserver(forName: name, object: object, queue: queue, using: block)
          return NotificationToken(notificationCenter: self, token: token)
    }
    
    class func addObserve(target: Any, action: Selector, name: NSNotification.Name?, object: Any? = nil) {
        self.default.addObserver(target, selector: action, name: name, object: object)
    }
}


final class NotificationToken: NSObject {
      let notificcationCenter: NotificationCenter
      let token: Any
      
      init(notificationCenter: NotificationCenter = .default, token: Any) {
            self.notificcationCenter = notificationCenter
            self.token = token
      }
    
      deinit {
        notificcationCenter.removeObserver(token)
      }
}


