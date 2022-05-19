//
//  UIColor+Extend.swift
//  UIColor
//
//  Created by TAN on 2018/8/30.
//  Copyright © 2018年 iOS. All rights reserved.
//  UIColor使用拓展

import UIKit

extension UIColor {
    
    /// 16进制转化Color
    ///
    /// - Parameter hex: 16进制
    /// - Returns: Color
    class func colorWithHexStr(_ hex: String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasSuffix("#")) {
            let index = cString.index(cString.startIndex, offsetBy: 1)
            //cString = cString.substring(from: index)
            cString = String(cString[index...]) // Swift 4
        }
        
        if (cString.count != 6) {
            
            return UIColor.red
        }
    
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        //let rString = cString.substring(to: rIndex)
        let rString = String(cString[..<rIndex])
        
        //let otherString = cString.substring(from: rIndex)
        let otherString = String(cString[rIndex...])
        
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        
        //let gString = otherString.substring(to: gIndex)
        let gString =  String(otherString[..<gIndex])
        
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        //let bString = cString.substring(from: bIndex)
        let bString = String(cString[bIndex...])
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: (1))
    }
    
    
    /// 16进制转化Color
    ///
    /// - Parameters:
    ///   - hex: 16进制
    ///   - alpha: 透明度
    /// - Returns: Color
    class func colorWithHexStr(_ hex: String, alpha: CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    
    // MARK: - RGB的颜色设置
    class func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    class func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/1.0)
    }
    
    // MARK: - 随机颜色
    /// 随机颜色
    ///
    /// - Returns: 随机颜色
    class func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256))
        let green = CGFloat(arc4random_uniform(256))
        let blue = CGFloat(arc4random_uniform(256))
        return RGB(r: red, g: green, b: blue)
    }
    
    
    // MARK: - 应用控件主题颜色
    /// 1FB922
    ///
    /// - Returns: 1FB922
    class func appThemeHexColor() ->UIColor {
        return colorWithHexStr("1FB922")
    }
    
    // MARK: - HUD的背景颜色
    class func hudBackgroundColor() -> UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }
    
    // MARK: - tabBar标题未选中颜色
    class func tabBarTitleNormalColor() -> UIColor {
        return colorWithHexStr("AAAAAA")
    }
    
    // MARK: - tabBar标题已选中颜色
    class func tabBarTitleSelectColor() -> UIColor {
        return colorWithHexStr("1FB922")
    }
}


extension UIColor {
    
    convenience init?(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

