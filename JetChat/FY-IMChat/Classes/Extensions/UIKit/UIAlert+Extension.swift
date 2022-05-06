//
//  EasyAlertView.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class EasyAlertView: NSObject {
    
    override init() { }
    
    /// 点击不响应提示框
    class func sureActionAlert(title: String, message: String, vc: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let sureAction = UIAlertAction(title: "确定".rLocalized(), style: .default) { (UIAlertAction) in
            
        }
        
        alertVC.addAction(sureAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 默认带确认&取消事件响应的提示框
    class func confirmAlert(title: String, message: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "确定".rLocalized(), style: .default) { (UIAlertAction) in
            source()
        }
        let cancleAction = UIAlertAction(title: "取消".rLocalized(), style: .default, handler: nil)

        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    class func defaultConfirm(title: String, message: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "确认".rLocalized(), style: .default) { (UIAlertAction) in
            source()
        }

        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 默认只带确认事件响应的提示框
    class func sheetAction(title: String, message: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let confirmAction = UIAlertAction(title: "确定".rLocalized(), style: .default) { (UIAlertAction) in
            source()
        }

        let cancleAction = UIAlertAction(title: "取消".rLocalized(), style: .default, handler: nil)
        alertVC.addAction(cancleAction)
        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 完全自定义样式的Alert
    class func customAlert(title: String, message: String, confirm: String, cancel: String, vc: UIViewController, confirmBlock: @escaping () -> Void, cancelBlock: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirm, style: .default) { (UIAlertAction) in
            confirmBlock()
        }
        let cancelAction = UIAlertAction(title: cancel, style: .default) { (UIAlertAction) in
            cancelBlock()
        }

        alertVC.addAction(confirmAction)
        alertVC.addAction(cancelAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    class func customConfirm(title: String, message: String, confirm: String, vc: UIViewController, source: @escaping () -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: confirm, style: .default) { (UIAlertAction) in
            source()
        }

        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }

    /// 带文本输入的提示框
    func textFiledAlert(title: String, message: String, placeholder: String, vc: UIViewController, source: @escaping (_ text: String) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertVC.addTextField { (textFiled: UITextField) in
            textFiled.placeholder = placeholder
        }

        let cancelAction = UIAlertAction(title: "确定".rLocalized(), style: .default, handler: nil)
        let confirmAction = UIAlertAction(title: "取消".rLocalized(), style: .default) { (UIAlertAction) in
            let login = alertVC.textFields![0]
            source(login.text!)
            printLog("输入的是：\(String(describing: login.text))")
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }
}
