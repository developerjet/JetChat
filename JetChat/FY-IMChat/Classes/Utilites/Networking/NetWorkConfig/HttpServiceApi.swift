//
//  LWHttpServiceApi.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation


/// 主要业务模块功能
let HttpApiConfig : HttpApiConfigType = .Test


/// 请求接口基于环境配置
///
/// - Test: 测试环境
/// - Develop: 正式测试环境
/// - Product: 正式生产环境
enum HttpApiConfigType {
    case Test
    case Develop
    case Product
}

extension HttpApiConfigType {
    
    var baseURL : String {
        switch self {
        case .Test:
            return "http://stagesblock.api.x-block.co"
        case .Develop:
            return "https://stage.api.sblock.com"
        case .Product:
            return "https://api.sblock.com"
        }
    }
    
    var webBaseURL : String {
        switch self {
        case .Test:
            return "http://stagesblock.api.x-block.co/"
        case .Develop:
            return "https://stage.sblock.com/"
        case .Product:
            return "https://appsview.sblock.com/"
        }
    }
    
    /// 腾讯Bugly
    var buglyId : String {
        switch self {
        case .Test:
            return "64862b9996"
        case .Product:
            return "c4504303b1"
        case .Develop:
            return "64862b9996"
        }
    }
    
    /// 切换配置的工作
    func changeEnv() { }
    
}


/*
 https://stage.sblock.com/community?a=1&b=2&c=cn
 https://stage.sblock.com/returns?a=1&b=2&c=cn
 https://stage.sblock.com/agreement
 
 a = xxxxx + base64(userId)
 b = xxxxx + base64(token)
 c = cn/en/...
 d =  base64(username)
 e =  username
 f =  newid
 */

enum HTTPBaseWebType {
    case NewDetail(id:String)
    case FAQ
    case FeedBack
    case Agreement
    case InviteRegister
    
    func webUrl() -> String {
        
        let token = UserInfoManager.shared.userInfo?.token ?? ""
        let uid = UserInfoManager.shared.userInfo?.uid ?? ""
        let a = "\(String.randomCode(length: 5))\(uid.base64Encoded ?? "")"
        let b = "\(String.randomCode(length: 5))\(token.base64Encoded ?? "")"
        let c = LanguageManager.manager.selectedLanguage?.serverLanguage() ?? ""
        let d = UserInfoManager.shared.userInfo?.username.base64Encoded ?? ""
        let e = UserInfoManager.shared.userInfo?.username ?? ""
        
        switch self {
        case .NewDetail(let id):
            let config = "news-details?a=\(a)&b=\(b)&c=\(c)&f=\(id)"
            let configURL = HttpApiConfig.webBaseURL + config
            return configURL
            
        case .InviteRegister:
            let config = "invite-register?a=\(a)&b=\(b)&c=\(c)&d=\(d)&e=\(e)"
            let configURL = HttpApiConfig.webBaseURL + config
            return configURL

        case .FAQ:
            let language = LanguageManager.manager.selectedLanguage == .kChinese ? "cn" : "en"
            let config = "faq?a=\(a)&b=\(b)&c=\(language)"
            let configURL = HttpApiConfig.webBaseURL + config
            return configURL
            
        case .FeedBack:
            let config = "feedback?a=\(a)&b=\(b)&c=\(c)"
            let configURL = HttpApiConfig.webBaseURL + config
            return configURL
            
        case .Agreement:
            let config = "agreement?a=\(a)&b=\(b)&c=\(c)"
            let configURL = HttpApiConfig.webBaseURL + config
            return configURL
        }
    }
}
