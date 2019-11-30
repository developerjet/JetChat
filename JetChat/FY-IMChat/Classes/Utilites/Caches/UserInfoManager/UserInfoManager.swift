//
//  UserInfoManager.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/3/8.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import CryptoSwift
import Moya
import RxSwift
import RxCocoa

private let USER_AES_KEY = "fy.imchat.ios"

class UserInfoManager: NSObject {
    
    /// 管理单利
    static let shared = UserInfoManager()
    
    /// 是否已设置支付密码
    var isPaySeted: Bool = false
    
    
    /// 开始缓存
    func cacheUserInfo(_ userInfo: [String: Any]?) {
        guard !((userInfo?.isEmpty)!) else {
            return
        }
        // 存储信息
        handyJSONWithDictionary(userInfo!)
    }
    
    /// 清除用户信息缓存
    func clearChaches() {
        UserDefaults.standard.removeObject(forKey: kUserInfoSaveUserDefaultsKey)
        UserDefaults.standard.removeObject(forKey: kUserAccountSaveUserDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    /// (中心化)用户数据模型
    var userInfo: LWUserInfo? {
        get {
            if let encryptedBase64: String = UserDefaults.standard.value(forKey: kUserInfoSaveUserDefaultsKey) as? String {
                do {
                    let aes = try AES(key: Padding.zeroPadding.add(to: USER_AES_KEY.bytes, blockSize: AES.blockSize),
                                      blockMode: ECB())
                    //开始解密（从加密后的base64字符串解密）
                    let decrypted = try encryptedBase64.decryptBase64ToString(cipher: aes)
                    //字符串转成字典
                    let dictionary = String().getDictionaryFromJSONString(decrypted)
                    //转成模型
                    if let result = LWUserInfo.deserialize(from: dictionary) {
                        return result
                    }
                }catch {
                    
                    printLog(error.localizedDescription)
                }
            }
            
            return LWUserInfo()
        }
    }
    
    
    /// 用户是否登入
    var isEnter: Bool? {
        get {
            guard ((self.userInfo?.id) != nil) else {
                return false
            }
            
            return true
        }
    }
    
    // 字典null值处理
    private func handyJSONWithDictionary(_ dictionary: [String: Any]) {
        var object = JSON(dictionary).dictionaryObject
        for (key, value) in object! {
            if (value is NSNull) {
                object?.updateValue("", forKey: key)
            }
        }
        
        encryptionToAES(String().getJSONStringFromDictionary(object! as NSDictionary))
    }
    
    required override init() {
        super.init()
    }
}


// MARK:- Build ViewModel

extension UserInfoManager {
    
//    /// 更新弹框
//    func showSBlockAlert(update: SBAppUpdate){
//
//        let mobileVersion = majorVersion.replacingOccurrences(of: ".", with: "").int ?? 0
//        let serverVersion = update.mobile_version.replacingOccurrences(of: ".", with: "").int ?? 0
//
//        let toVersion = "V\(update.mobile_version)"
//        var title = Lcax_common_update_title.rLocalized()
//        title = title.replacingOccurrences(of: "[SBlock]", with: toVersion)
//
//        let major = update.major_update == 1
//        if serverVersion > mobileVersion && !update.mobile_version.isEmpty {
//            // 更新提示处理
//            let alert = AppUpdateAlert(isUpdate: major)
//            alert.title = title
//            alert.show()
//            alert.didUpdateClosure = {
//                if let url = URL(string: update.link) {
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                }
//            }
//        }
//    }
}


extension UserInfoManager {
    
    func encryptionToAES(_ JSONString: String) {
        guard !(JSONString.isEmpty) else {
            return
        }
        
        do {
            //使用AES-128-ECB加密模式
            let aes = try AES(key: Padding.zeroPadding.add(to: USER_AES_KEY.bytes, blockSize: AES.blockSize),
                              blockMode: ECB())
            let encrypted = try aes.encrypt(JSONString.bytes)
            //将加密结果转成base64形式
            if let encryptedBase64 = encrypted.toBase64() {
                UserDefaults.standard.set(encryptedBase64, forKey: kUserInfoSaveUserDefaultsKey)
                UserDefaults.standard.synchronize()
            }
        }catch {
            
            printLog(error.localizedDescription)
        }
    }
}

// MARK:- SupportsAlternateIcons

extension UserInfoManager {
    
    func changedAppIcon() {
        // 测试环境
        if HttpApiConfig == .Test {
            let isChangedIcon: Bool = UserDefaults.standard.bool(forKey: kChangedAppIocnUserDefaultsKey)
            if isChangedIcon == false {
                if #available(iOS 10.3, *) {
                    // 判断是否支持替换图标
                    guard UIApplication.shared.supportsAlternateIcons else { return }
                    //如果支持(替换app图标)
                    UIApplication.shared.setAlternateIconName("beatIcon") { (error) in
                        if error != nil {
                            printLog("更换icon发生错误")
                        } else {
                            // 设置成功
                            UserDefaults.standard.set(true, forKey: kChangedAppIocnUserDefaultsKey)
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
            }
        }
    }
}
