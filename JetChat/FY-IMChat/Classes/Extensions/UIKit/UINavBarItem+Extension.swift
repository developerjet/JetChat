//
//  NavBarItem+Extension.swift
//  SwiftStudy
//
//  Created by iOS.Jet on 2019/2/20.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation
import UIKit

/// 便捷方法拓展
extension UIBarButtonItem {

    /// 设置导航栏侧边内容(只设置图片)
    ///
    /// - Parameters:
    ///   - image: 普通状态下图片
    ///   - action: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setNavItemImage(_ image: UIImage, target: Any?, action: Selector) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        customButton.setImage(image, for: .normal)
        customButton.setTitleColor(.appThemeHexColor(), for: .normal)
        customButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        customButton.sizeToFit()
        customButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    /// 设置导航栏侧边内容(设置普通&高亮图片)
    ///
    /// - Parameters:
    ///   - image: 普通状态下图片
    ///   - hightImage: 高亮状态下图片
    ///   - action: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setNavItemHightImage(_ image: UIImage, hightImage: UIImage, target: Any?, action: Selector) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        customButton.setImage(image, for: .normal)
        customButton.setImage(hightImage, for: .highlighted)
        customButton.setTitleColor(.appThemeHexColor(), for: .normal)
        customButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        customButton.sizeToFit()
        customButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    /// 设置导航栏侧边内容(设置普通&高亮图片)
    ///
    /// - Parameters:
    ///   - image: 普通状态下图片
    ///   - selectedImage: 选中状态下图片
    ///   - action: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setNavItemSelectedImage(_ image: UIImage, selectedImage: UIImage, target: Any?, action: Selector) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        customButton.setImage(image, for: .normal)
        customButton.setImage(selectedImage, for: .selected)
        customButton.setTitleColor(.appThemeHexColor(), for: .normal)
        customButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        customButton.sizeToFit()
        customButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    /// 设置导航栏侧边内容(只设置文字)
    ///
    /// - Parameters:
    ///   - title: 普通状态下文字
    ///   - selector: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setNavItemTitle(_ title: String, target: Any?, selector: Selector) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(.appThemeHexColor(), for: .normal)
        customButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        customButton.sizeToFit()
        customButton.addTarget(target, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    
    /// 设置导航栏侧边内容(只设置文字)
    ///
    /// - Parameters:
    ///   - title: 普通状态下文字
    ///   - color: 普通状态下文字颜色
    ///   - action: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setTitleWithColor(_ title: String, color: UIColor, target: Any?, selector: Selector) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(color, for: .normal)
        customButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        customButton.sizeToFit()
        customButton.addTarget(target, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    /// 设置导航栏侧边内容(设置图片+文字)
    ///
    /// - Parameters:
    ///   - image: 普通状态下图片
    ///   - title: 普通状态下文字
    ///   - action: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setNavItemImageOrTitle(_ image: UIImage, title: String, target: Any, action: Selector) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        customButton.setImage(image, for: .normal)
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(.appThemeHexColor(), for: .normal)
        customButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        customButton.sizeToFit()
        customButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    /// 设置导航栏侧边内容(设置高亮图片+文字)
    ///
    /// - Parameters:
    ///   - hightImage: 高亮状态下图片
    ///   - title: 普通状态下文字
    ///   - action: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setNavItemHightImageOrTitle(_ hightImage: UIImage, title: String, target: Any?, action: Selector) -> UIBarButtonItem {
        let customButton = UIButton(type: .custom)
        customButton.setTitle(title, for: .normal)
        customButton.setImage(hightImage, for: .highlighted)
        customButton.setTitleColor(.appThemeHexColor(), for: .normal)
        customButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        customButton.sizeToFit()
        customButton.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: customButton)
    }
    
    
    /// 设置导航栏侧边内容(自定义按钮)
    ///
    /// - Parameters:
    ///   - button: 自定义按钮
    ///   - action: 添加的点击事件
    /// - Returns: 自定义设置导航栏侧边内容
    class func setNavItemCustomView(_ button : UIButton, target: Any?, action: Selector) -> UIBarButtonItem {
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
}


