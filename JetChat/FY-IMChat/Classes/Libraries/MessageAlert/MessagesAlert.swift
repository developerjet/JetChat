//
//  MessagesAlert.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/8/20.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import SwiftMessages

//布局样式
enum LayoutType: String {
    case MessageView
    case CardView
    case TabView
    case StatusLine
    case CenteredView
}


/// 弹框显示时间
fileprivate let kShowDuration: TimeInterval = 1.5

class MessagesAlert: NSObject {
    
    /// 自定义显示样式
    class func showMessage(layoutType: LayoutType = .MessageView, themeType: Theme = .warning, presentationContext: SwiftMessages.PresentationContext = .automatic, iconImageType: IconStyle = .default, presentationStyle:SwiftMessages.PresentationStyle = .center, title:String = "", body:String = "", isHiddenBtn: Bool = true, seconds: TimeInterval = kShowDuration) {
        
        var view = MessageView.viewFromNib(layout: .messageView)
        
        switch layoutType {
        case .CardView:
            view = MessageView.viewFromNib(layout: .cardView)
        case .TabView:
            view = MessageView.viewFromNib(layout: .tabView)
        case .StatusLine:
            view = MessageView.viewFromNib(layout: .statusLine)
        default:
            view = try! SwiftMessages.viewFromNib()
        }
        
        switch themeType {
        case .success:
            view.configureTheme(.success, iconStyle:iconImageType)
        case .warning:
            view.configureTheme(.warning, iconStyle:iconImageType)
        case .error:
            view.configureTheme(.error, iconStyle:iconImageType)
        default:
            view.configureTheme(.warning, iconStyle:iconImageType)
        }
        
        // 是否隐藏按钮
        view.button?.isHidden = isHiddenBtn
        // 背景颜色
        view.backgroundView.backgroundColor = .hudBackgroundColor()
        // 字体
        view.bodyLabel?.font = UIFont.PingFangMedium(15)
        // 图片
        view.iconImageView?.image = Icon.warning.image
        // 内容
        view.titleLabel?.text = title
        view.bodyLabel?.text = body
        
        var infoConfig = SwiftMessages.Config()
        infoConfig.presentationContext = presentationContext
        infoConfig.presentationStyle = presentationStyle
        infoConfig.duration = .seconds(seconds: kShowDuration)
        
        SwiftMessages.show(config: infoConfig, view: view)
    }
    
    
    class func showTopTips(_ text: String, themeType: Theme = .warning) {
        self.showMessage(layoutType: .CardView, themeType: .warning, presentationContext: .window(windowLevel: UIWindow.Level.statusBar), iconImageType: .none, presentationStyle: .top, body: text, isHiddenBtn: true, seconds: kShowDuration)
    }
    
    
    class func showBottomTips(_ text: String, themeType: Theme = .warning) {
        self.showMessage(layoutType: .CardView, themeType: .info, presentationContext: .window(windowLevel: UIWindow.Level.statusBar), iconImageType: .none, presentationStyle: .bottom, body: text, isHiddenBtn: true, seconds: kShowDuration)
    }
    
    class func showCenterTips(_ text: String, title: String = "", isHandle: Bool = false) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        
        messageView.configureContent(title: title, body: text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        messageView.button?.isHidden = true
        //messageView.configureBackgroundView(width: 230)
        messageView.configureTheme(.warning, iconStyle: .none)
        messageView.backgroundView.backgroundColor = .hudBackgroundColor()
        messageView.backgroundView.layer.cornerRadius = 10
        
        // configure
        var config = SwiftMessages.Config()
        config.presentationStyle = .center
        //config.dimMode = .blur(style: .dark, alpha: 0.25, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .seconds(seconds: kShowDuration)
        SwiftMessages.show(config: config, view: messageView)
    }
}
