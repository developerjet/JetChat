//
//  UIView+Extend.swift
//  UIView拓展
//
//  Created by Mac on 2018/8/16.
//  Copyright © 2018年 iOS. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    /// x
    public var x : CGFloat {
        
        get {
            return self.frame.origin.x
        }
        set (x) {
            var frame = self.frame
            frame.origin.x = x
            self.frame = frame
        }
    }
    
    
    /// y
    public var y : CGFloat {
        
        get {
            return self.frame.origin.y
        }
        set (y) {
            var frame = self.frame
            frame.origin.y = y
            self.frame = frame
        }
    }
    
    
    /// maxX
    public var maxX : CGFloat {
        
        get {
            return self.frame.maxX
        }
        set(maxX) {
            self.frame.origin.x = maxX - self.frame.size.width
        }
    }
    
    /// maxY
    public var maxY : CGFloat {
        
        get {
            return self.frame.maxY
        }
        set(maxY) {
            self.frame.origin.y = maxY - self.frame.size.height
        }
    }
    
    
    /// width
    public var width : CGFloat {
        
        get {
            return self.frame.size.width
        }
        set (width) {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    
    /// height
    public var height : CGFloat {
        
        get {
            return self.frame.size.height
        }
        set (height) {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    
    /// centerX
    public var centerX : CGFloat {
        
        get {
            return self.center.x
        }
        set (centerX) {
            var center = self.center
            center.x = centerX
            self.center = center
        }
    }
    
    
    /// centerY
    public var centerY : CGFloat {
        
        get {
            return self.center.y
        }
        set (centerY) {
            var center = self.center
            center.y = centerY
            self.center = center
        }
    }
    
    
    /// size
    public var size : CGSize {
        
        get {
            return self.frame.size
        }
        set (size) {
            var newSize = self.frame.size
            newSize = CGSize(width: size.width, height: size.height)
            self.frame.size = newSize
        }
    }
    
    
    /// origin
    public var origin : CGPoint {
        
        get {
            return self.frame.origin
        }
        set (origin) {
            var newOrigin = self.frame.origin
            newOrigin = CGPoint(x: origin.x, y: origin.y)
            self.frame.origin = newOrigin
        }
    }
    
    
    /// cornerRadius
    public var radius: CGFloat {
        
        get {
            return self.layer.cornerRadius;
        }
        set (radius){
            self.layer.cornerRadius = radius
            
            guard self.layer.masksToBounds else {
                return
            }
            self.layer.masksToBounds = true
        }
    }
    
    
    /// borderWidth
    public var borderWidth: CGFloat {
        
        get {
            return self.layer.borderWidth
        }
        set (borderWidth){
            self.layer.borderWidth = borderWidth
            
            guard self.layer.masksToBounds else {
                return
            }
            self.layer.masksToBounds = true
        }
    }
    
    
    /// 指定方向设置圆角
    ///
    /// - Parameters:
    ///   - size: 圆角大小
    ///   - type: 圆角方向
    public func makeLayerRadius(_ size: CGSize?, type: UIRectCorner) {
        guard let size = size else {
            return
        }
        
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: type, cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = bezierPath.cgPath
        self.layer.mask = maskLayer
    }
    
    
    /// 设置view的阴影
    ///
    /// - Parameters:
    ///   - radius: 阴影的模糊半径
    ///   - color: 阴影颜色
    ///   - size: 阴影的偏移量
    public func makeLayerShadow(_ size: CGSize?, radius: CGFloat, color: UIColor, opacity: Float) {
        guard let size = size else {
            return
        }
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity //阴影透明度(默认为1 | 0为不显示)
    }
    
    /// 设置view的阴影 带圆角
    ///
    /// - Parameters:
    ///   - size: 大小  默认CGSize(width: 0, height: 3)
    ///   - radius: 阴影的模糊半径 默认 4
    ///   - color: 阴影颜色 默认 黑色 0.5
    ///   - opacity: 阴影 渲染 默认1
    ///   - corner: 圆角 默认18
    
    public func makeLayerShadowCorner(size: CGSize = CGSize(width: 0, height: 3),
                                      radius: CGFloat = 4,
                                      color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
                                      opacity: Float = 1,
                                      corner: CGFloat = 18) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.cornerRadius = corner
    }
    
    /// 设置view的阴影 带圆角 背景色
    ///
    /// - Parameters:
    ///   - size: 大小  默认CGSize(width: 0, height: 2)
    ///   - radius: 阴影的模糊半径 默认 3
    ///   - color:  阴影颜色 默认 黑色 0.3
    ///   - opacity: 阴影 渲染 默认1
    ///   - corner: 圆角 默认8
    ///   - bgColor: 背景色
    public func setShadowCornerBgColor(size: CGSize = CGSize(width: 0, height: 2),
                                       radius: CGFloat = 3,
                                       color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3),
                                       opacity: Float = 1,
                                       corner: CGFloat = 8,
                                       bgColor: UIColor) {
        self.layer.cornerRadius = corner
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = opacity
        self.layer.backgroundColor = bgColor.cgColor
    }
    
    
    /// 设置view的渐变颜色背景
    ///
    /// - Parameter colors: 渐变色颜色数组
    public func makeGradientLayer(_ colors: [Any]?) {
        guard let colors = colors else {
            return
        }
        
        let gradientLayer = CAGradientLayer()
        let sizeWidth = UIScreen.main.bounds.size.width
        gradientLayer.frame = CGRect(x: 0, y: 0, width: sizeWidth, height: self.height)
        gradientLayer.startPoint = CGPoint(x: -0.03, y: -0.1)
        gradientLayer.endPoint = CGPoint(x: 0.96, y: 0.96)
        gradientLayer.locations = [0, 1.0]
        //设置渐变的主颜色
        gradientLayer.colors = colors
        //将gradientLayer作为子layer添加到主layer上
        self.layer.addSublayer(gradientLayer)
        self.layer.masksToBounds = true
    }
    
    
    /// 设置view默认的渐变颜色(3E9EF7 ~ 185DFF)
    public func makeDefaultGradient() {
        let colors = [UIColor.colorWithHexStr("3E9EF7").cgColor,
                      UIColor.colorWithHexStr("185DFF").cgColor]
        
        let gradientLayer = CAGradientLayer()
        let sizeWidth = UIScreen.main.bounds.size.width
        gradientLayer.frame = CGRect(x: 0, y: 0, width: sizeWidth, height: self.height)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.93, y: 0.92)
        gradientLayer.locations = [0, 1.0]
        //设置渐变的主颜色
        gradientLayer.colors = colors
        //将gradientLayer作为子layer添加到主layer上
        self.layer.addSublayer(gradientLayer)
        self.layer.masksToBounds = true
    }
    
    
    /// 设置边距宽度和颜色
    func makeLayerBoards(at width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

protocol ViewChainable {}
extension ViewChainable where Self: UIView {
    @discardableResult
    func config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}



extension UIView: ViewChainable {
    
    func adhere(toSuperView: UIView) -> Self {
        toSuperView.addSubview(self)
        return self
    }
    
    @discardableResult
    func layout(snapKitMaker: (ConstraintMaker) -> Void) -> Self {
        self.snp.makeConstraints { (make) in
            snapKitMaker(make)
        }
        return self
    }
}

extension UIView {
    
    func cropView(with rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width, height: rect.size.height), _: false, _: 0.0) //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
        } //renderInContext呈现接受者及其子范围到指定的上下文
        let viewImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext() //返回一个基于当前图形上下文的图片
        UIGraphicsEndImageContext() //移除栈顶的基于当前位图的图形上下文
        //    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
        return viewImage
    }
    
}

