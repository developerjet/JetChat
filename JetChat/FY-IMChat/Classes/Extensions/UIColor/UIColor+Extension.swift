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
    
    
    // MARK:- RGB的颜色设置
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
    
    
    // MARK:- 应用控件主题颜色
    /// 48D1CC
    ///
    /// - Returns: 48D1CC
    class func appThemeHexColor() ->UIColor {
        
        return colorWithHexStr("1FB922")
    }
    
    /// 头 / 尾部刷新控件颜色
    class func scrollRefreshColor() ->UIColor {
        
        return colorWithHexStr("FF7F24")
    }
    
    // MARK:- 常用纯白背景色
    /// FFFFFF
    ///
    /// - Returns: FFFFFF
    class func backGroundWhiteColor() ->UIColor {
        
        return colorWithHexStr("FFFFFF")
    }
    
    // MARK:- 灰色背景色
    /// f7f7f7
    ///
    /// - Returns: f7f7f7
    class func backGroundGrayColor() ->UIColor {
        
        return colorWithHexStr("f7f7f7")
    }
    
    // MARK:- 按钮不可点击时颜色
    ///
    /// - Returns: C5C7D2
    class func buttDisableBackgroundColor() ->UIColor {
        
        return colorWithHexStr("C5C7D2")
    }
    
    // MARK:- 按钮不可点击时标题颜色
    class func btnDisableTitleColor() ->UIColor {
        
        return colorWithHexStr("A6A6A6")
    }
    
    // MARK:- 应用常用黑色字体颜色
    class func textDrakHexColor() -> UIColor {
        
        return colorWithHexStr("151515")
    }
    
    // MARK:- 应用常用黑色字体颜色
    /// 1B1B1F
    ///
    /// - Returns: 1B1B1F
    class func textPrimaryColor() -> UIColor {
        
        return colorWithHexStr("1B1B1F")
    }
    
    // MARK:- 应用常用绿色字体颜色
    /// 26D747
    ///
    /// - Returns: 26D747
    class func textGreenColor() -> UIColor {
     
        return colorWithHexStr("26D747")
    }
    
    // MARK:- 应用常用浅色字体颜色
    /// FFFFFF 0.5
    ///
    /// - Returns: FFFFFF 0.5
    class func textPlaceholderColor() -> UIColor {
        return colorWithHexStr("FFFFFF", alpha: 0.5)
    }
    
    // MARK:- 应用子标题字体颜色1
    class func textLightHexColor() -> UIColor {
        
        return colorWithHexStr("707070")
    }
    
    
    class func textGrayHexColor() -> UIColor {
        
        return colorWithHexStr("B5B5B5")
    }
    
    class func textContentHexColor() -> UIColor {
        
        return colorWithHexStr("FFFFFF")
    }
    
    // MARK:- 分割线常用色
    
    class func boardLineColor() -> UIColor {
        
        return colorWithHexStr("D8D8D8")
    }
    
    // MARK:- 开关的常用颜色
    class func switchCurrencyColor() -> UIColor {
        
        return colorWithHexStr("fbb65e")
    }
    
    // MARK:- 常用按钮颜色
    class func buttonCurrencyColor() -> UIColor {
        
        return self.colorWithHexStr("FEE800")
    }
    
    // MARK:- 导航栏背景颜色
    class func navigationBarColor() -> UIColor {
        
        return self.colorWithHexStr("04030D")
    }
    
    // MARK:- HUD的背景颜色
    class func hudBackgroundColor() -> UIColor {
        //return self.colorWithHexStr("000000", alpha: 0.4)
        return UIColor.black.withAlphaComponent(0.7)
    }
    
    // MARK:- tabBar标题未选中颜色
    class func tabBarTitleNormalColor() -> UIColor {
        
        return colorWithHexStr("AAAAAA")
    }
    
    // MARK:- tabBar标题已选中颜色
    class func tabBarTitleSelectColor() -> UIColor {
        
        return colorWithHexStr("1FB922")
    }
}


extension UIColor {
    
    convenience init?(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

