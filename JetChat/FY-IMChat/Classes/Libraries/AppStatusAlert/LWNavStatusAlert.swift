//
//  LWNavStatusAlert.swift
//  SwiftStudy
//
//  Created by iOS.Jet on 2018/7/16.
//  Copyright © 2018年 iOS. All rights reserved.
//

import UIKit

/// 申明闭包
typealias didMessageClosure = () ->Void

class LWNavStatusAlert: UIView {
    
    var image : String = ""
    var message : String = ""
    
    private let kStatusSpace = kNavigaH
    private let kAlertHeight = kNavigaH
    
    // 将声明的闭包定位为属性
    var didMessageBlock: didMessageClosure?
    
    /// 提示语
    lazy var contentLabel: UILabel = {
        let x : CGFloat = 10
        let w = self.frame.size.width - 2 * x
        let frame = CGRect(x: x, y: (self.frame.size.height-21)/2, width: w, height: 21)
        let label = UILabel.init(frame: frame)
        label.font = UIFont.PingFangRegular(14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentView: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.clear
        button.frame = self.bounds
        button.addTarget(self, action: #selector(didMessageClick), for: .touchUpInside)
        return button;
    }()
    
    lazy var swipeGesture : UISwipeGestureRecognizer = {
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeDidEvent(_:)))
        return swipe
    }()
    
    
    // MARK:- Life cycle
    
    convenience init(message: String) {
        self.init(frame: CGRect.zero)
        self.message = message
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .hudBackgroundColor()
        self.frame = CGRect(x: 0, y: -kStatusSpace, width: kScreenW, height: kAlertHeight)
        self.alpha = 0.0;
        
        contentView.addSubview(contentLabel)
        addSubview(contentView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func swipeDidEvent(_ gesture: UISwipeGestureRecognizer) {
        let direction = gesture.direction
        switch direction {
        case .up:
            self.dissmiss()
            break
        default:
            break
        }
    }
}

// MARK:- Action

extension LWNavStatusAlert {
    
    func viewToShow() -> UIWindow {
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
    
    public func show()  {
        for view in self.viewToShow().subviews {
            if view == self {
                return
            }else {
                fadeInAnima()
            }
        }
    }
    
    func fadeInAnima() {
        self.alpha = 1.0
        self.viewToShow().addSubview(self)
        
        contentLabel.text = message;
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = .init(translationX: 0, y: self.kStatusSpace) // 向下位移
        }) { (finished) -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.dissmiss()
            }
        }
    }
    
    func dissmiss() {
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = .identity //恢复位置
        }) { (finished) -> Void in
            self.alpha = 0.0
            self.removeFromSuperview()
        }
    }

    @objc public func didMessageClick() {
        self.alpha = 0.0
        self.removeFromSuperview()
        
        if (didMessageBlock != nil) {
            didMessageBlock?()
        }
    }
}
