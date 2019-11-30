//
//  MBConfiguredHUD.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation


/// 弹框缩写
typealias MBHUD = MBConfiguredHUD

/// 弹框显示时间
fileprivate let kAfterDelay: TimeInterval = 1.5

class MBConfiguredHUD: NSObject {

    fileprivate static let kRegularFont = UIFont.PingFangRegular(14)
    
    /// 获取用于显示提示框的view
    class func hudWindow() -> UIWindow {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for newWindow in windowArray {
                if newWindow.windowLevel == UIWindow.Level.normal {
                    window = newWindow
                    break
                }
            }
        }
        return window!
    }
    
    // MARK:- 具体样式设置
    
    /// 普通的菊花HUD(需要手动隐藏)
    class func show() {
        DispatchQueue.main.async {
            let window = hudWindow()
            MBProgressHUD.hide(for: window, animated: false)
            // create
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.mode = .indeterminate
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.bezelView.style = .solidColor
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf:
                [MBProgressHUD.self]).color = .white //设置菊花颜色为白色
            hud.bezelView.color = .hudBackgroundColor()
            hud.isUserInteractionEnabled = false
            hud.removeFromSuperViewOnHide = true
        }
    }
    
    /// 带文字的菊花HUD（需手动隐藏）
    class func showStatus(_ status: String, view: UIView = hudWindow()) {
        DispatchQueue.main.async {
            let window = view
            MBProgressHUD.hide(for: window, animated: false)
            // create
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.label.text = status
            hud.mode = .indeterminate
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.animationType = .zoom
            hud.contentColor = .white //文字和菊花颜色
            hud.bezelView.style = .solidColor
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf:
                [MBProgressHUD.self]).color = .white
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = .hudBackgroundColor()
            hud.removeFromSuperViewOnHide = true
        }
    }
    
    /// 普通文本提示HUD（自动隐藏）
    class func showMessage(_ message: String) {
        DispatchQueue.main.async {
            let window = hudWindow()
            MBProgressHUD.hide(for: window, animated: false)
            // create
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.mode = .text
            hud.label.text = message
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.bezelView.style = .solidColor
            hud.margin = 5
            hud.animationType = .zoom
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = .hudBackgroundColor()
            //hud.bezelView.cornerRadius = 4
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: kAfterDelay)
        }
    }
    
    /// 长类型文本提示HUD（自动隐藏）
    class func showLongMessage(_ message: String) {
        DispatchQueue.main.async {
            let window = hudWindow()
            MBProgressHUD.hide(for: window, animated: false)
            // create
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.mode = .text
            hud.label.text = message
            hud.label.numberOfLines = 0
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.bezelView.style = .solidColor
            hud.margin = 5
            hud.animationType = .zoom
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = .hudBackgroundColor()
            //hud.bezelView.cornerRadius = 4
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: kAfterDelay)
        }
    }
    
    /// 成功提示HUD + 图片
    class func showSuccess(_ success: String) {
        DispatchQueue.main.async {
            let window = hudWindow()
            MBProgressHUD.hide(for: window, animated: false)
            // create
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            let imageView = UIImageView(image: UIImage(named: "HUDAssets.bundle/icon_hud_success"))
            hud.mode = .customView
            hud.label.text = success
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.bezelView.layer.masksToBounds = false;
            hud.bezelView.style = .solidColor
            hud.animationType = .zoom
            hud.customView = imageView
            //hud.minSize = CGSize(width: 231, height: 123) //弹框大小设置
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = .hudBackgroundColor()
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: kAfterDelay)
        }
    }
    
    /// 失败提示HUD + 图片
    class func showFailure(_ success: String) {
        DispatchQueue.main.async {
            let window = hudWindow()
            MBProgressHUD.hide(for: window, animated: false)
            // create
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            let imageView = UIImageView(image: UIImage(named: "HUDAssets.bundle/icon_hud_failure"))
            hud.mode = .customView
            hud.label.text = success
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.animationType = .zoom
            hud.bezelView.layer.masksToBounds = false;
            hud.bezelView.style = .solidColor
            hud.customView = imageView
            //hud.minSize = CGSize(width: 231, height: 123) //弹框大小设置
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = .hudBackgroundColor()
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: kAfterDelay)
        }
    }
    
    /// 错误提示HUD + 图片
    class func showImageError(_ error: String) {
        DispatchQueue.main.async {
            let window = hudWindow()
            MBProgressHUD.hide(for: window, animated: false)
            // create
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            let imageView = UIImageView(image: UIImage(named: "HUDAssets.bundle/icon_hud_error"))
            hud.mode = .customView
            hud.label.text = error
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.animationType = .zoom
            hud.bezelView.layer.masksToBounds = false;
            hud.bezelView.style = .solidColor
            hud.customView = imageView
            //hud.minSize = CGSize(width: 231, height: 123) //弹框大小设置
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = .hudBackgroundColor()
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: kAfterDelay)
        }
    }
    
    
    /// HUD立即消失
    class func hide(_ view: UIView = hudWindow()) {
        DispatchQueue.main.async {
            view.isUserInteractionEnabled = true
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    /// HUD指定时间消失
    class func hideWithDelay(_ view: UIView = hudWindow(), delay: TimeInterval = kAfterDelay) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            view.isUserInteractionEnabled = true
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}


extension MBConfiguredHUD {
    
    /// 指定父视图提示HUD
    class func showMessageInView(_ message: String, view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
            // create
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .text
            hud.label.text = message
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.bezelView.style = .solidColor
            hud.margin = 5
            hud.animationType = .zoom
            hud.isUserInteractionEnabled = false
            hud.bezelView.color = .hudBackgroundColor()
            //hud.bezelView.cornerRadius = 4
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: kAfterDelay)
        }
    }
    
    /// 指定父视图成功提示HUD
    class func showSuccessInView(_ success: String, view: UIView) {
        MBConfiguredHUD.hide()
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
            // create
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            let imageView = UIImageView(image: UIImage(named: "HUDAssets.bundle/icon_hud_success"))
            hud.mode = .customView
            hud.label.text = success
            hud.label.textColor = .white
            hud.label.font = self.kRegularFont
            hud.contentColor = .white //文字和菊花颜色
            hud.animationType = .zoom
            hud.bezelView.layer.masksToBounds = false;
            hud.bezelView.style = .solidColor
            hud.customView = imageView
            //hud.minSize = CGSize(width: 231, height: 123) //弹框大小设置
            hud.isUserInteractionEnabled = true
            hud.bezelView.color = .hudBackgroundColor()
            hud.removeFromSuperViewOnHide = true
            hud.hide(animated: true, afterDelay: kAfterDelay)
        }
    }

}
