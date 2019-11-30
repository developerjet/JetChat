//
//  UIFont+PingFang.swift
//  FY-IMChat
//
//  Created by fisker.zhang on 2019/3/6.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation

extension UIFont {
    
    /// 苹方-简 常规体 PingFangSC-Regular
    static func PingFangRegular(_ size:CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    /// 苹方-简 中黑体 PingFangSC-Medium
    static func PingFangMedium(_  size:CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    /// 苹方-简 中粗体 PingFangSC-Semibold
    static func PingFangSemibold(_  size:CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    /// 苹方 特粗体 PingFang-SC-Heavy
    static func PingFangHeavy(_  size:CGFloat) -> UIFont {
        return UIFont(name: "PingFang-SC-Heavy", size: size) ?? UIFont.systemFont(ofSize:size)
    }
}
