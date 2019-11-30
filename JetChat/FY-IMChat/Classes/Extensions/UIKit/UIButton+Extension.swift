//
//  UIButton+Extension.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/10/11.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import Foundation
import RxSwift

/// 按钮图片和文字对齐方式
enum ButtonStyle {
    ///图片在左，文字在右，整体居中
    case `default`
    ///图片在左，文字在右，整体居中
    case left
    ///图片在右，文字在左，整体居中。
    case right
    ///图片在上，文字在下，整体居中
    case top
    ///图片在下，文字在上，整体居中
    case bottom
    ///图片居中，文字在图片下面。
    case centerTop
    ///图片居中，文字在图片上面
    case centerBottom
    ///图片居中，文字在上距离按钮顶部。
    case centerUp
    ///图片居中，文字在按钮下边。
    case centerDown
    ///图片在右，文字在左，距离按钮两边边距
    case rightLeft
    ///图片在左，文字在右，距离按钮两边边距
    case leftRight
}

// MARK: - Button EdgeInsets

extension UIButton {
    
    /// 按钮图片和文字的排版
    /// - Parameter style: 样式
    /// - Parameter padding: 间距大小
    func setImageButtonStyle(_ style: ButtonStyle, padding: CGFloat){
        
        if imageView?.image != nil && titleLabel?.text != nil {
            //先还原
            titleEdgeInsets = .zero
            imageEdgeInsets = .zero
            
            let imageRect: CGRect = imageView!.frame
            let titleRect: CGRect = titleLabel!.frame
            let totalHeight: CGFloat = (imageRect.size.height) + padding + (titleRect.size.height)
            let selfWidth  = frame.size.width
            let selfHeight = frame.size.height
            
            switch style {
            case .left:
                if padding != 0 {
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: padding / 2, bottom: 0, right: -padding / 2)
                    
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding / 2, bottom: 0, right: padding / 2)
                }
                
                break
                
            case .right:
                //图片在右，文字在左
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -((imageRect.size.width) + padding / 2), bottom: 0, right: ((imageRect.size.width) + padding / 2))
                
                imageEdgeInsets = UIEdgeInsets(top: 0, left: ((titleRect.size.width) + padding / 2), bottom: 0, right: -((titleRect.size.width) + padding / 2))
                
                break
                
            case .top:
                //图片在上，文字在下
                titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y),
                                               left: (selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y),
                                               right: -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - imageRect.origin.y),
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
                
            case .bottom:
                //图片在下，文字在上。
                titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - titleRect.origin.y),
                                               left: (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -((selfHeight - totalHeight) / 2 - titleRect.origin.y),
                                               right: -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: -((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
                
            case .centerTop:
                titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y - padding),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: (titleRect.origin.y - padding),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
                
            case .centerBottom:
                titleEdgeInsets = UIEdgeInsets(top: (selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
                
            case .centerUp:
                titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
                
            case .centerDown:
                titleEdgeInsets = UIEdgeInsets(top: (imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                
                break
                
            case .rightLeft:
                //图片在右，文字在左，距离按钮两边边距
                titleEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -(titleRect.origin.x - padding),
                                               bottom: 0,
                                               right: (titleRect.origin.x - padding))
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth - padding - imageRect.origin.x - imageRect.size.width),
                                               bottom: 0,
                                               right: -(selfWidth - padding - imageRect.origin.x - imageRect.size.width))
                break
                
            case .leftRight:
                //图片在左，文字在右，距离按钮两边边距
                titleEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth - padding - titleRect.origin.x - titleRect.size.width),
                                               bottom: 0,
                                               right: -(selfWidth - padding - titleRect.origin.x - titleRect.size.width))
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -(imageRect.origin.x - padding),
                                               bottom: 0,
                                               right: (imageRect.origin.x - padding))
                break
                
            default:
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                break
            }
        }else {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
}


// MARK: - RxSwift Tap

extension UIButton {
    
    func rxTapClosure(callback:(@escaping() -> ())) {
        self.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).bind {
            callback()
        }.disposed(by: rx.disposeBag)
    }
    
    func rxTapClosure(_ time: TimeInterval = 0.5, callback:(@escaping() -> ())) {
        self.rx.tap.throttle(time, scheduler: MainScheduler.instance).bind {
            callback()
        }.disposed(by: rx.disposeBag)
    }
}
