//
//  ChatKeyboardView+Exted.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/14.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import Foundation
import UIKit

let kChatScreenW: CGFloat = UIScreen.main.bounds.size.width
let kChatScreenH: CGFloat = UIScreen.main.bounds.size.height


// MARK: - NSNotificationName

public extension NSNotification.Name {
    /// 获取点击空白处回收键盘的处理通知
    static let kChatTextKeyboardNeedHide = Notification.Name("kChatTextKeyboardNeedHide")
    /// 获取文本输入框值变化
    static let kChatTextKeyboardChanged = Notification.Name("kChatTextKeyboardChanged")
}

// MARK: - UIColor

public extension UIColor {
    
    static var kSendColor: UIColor {
        switch themeService.type {
        case .light:
            return .Color_Blue_0000FF
        default:
            return .Color_White_FFFFFF
        }
    }
    
    static var kContentColor: UIColor {
        switch themeService.type {
        case .light:
            return .Color_Gray_F8F8F8
        default:
            return .Color_Black_272D34
        }
    }
    
    static var kLineColor: UIColor {
        switch themeService.type {
        case .light:
            return Color_Gray_E5E5E5
        default:
            return .Color_Black_2C363E
        }
    }
    
    static var kPlaceholderColor: UIColor {
        switch themeService.type {
        case .light:
            return UIColor(red: 191.0 / 255.0, green: 191.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
        default:
            return .Color_Gray_6D777C
        }
    }
    
    static var kTextColor: UIColor {
        switch themeService.type {
        case .light:
            return .Color_Black_333333
        default:
            return .Color_White_FFFFFF
        }
    }
    
    static var kKeyboardColor: UIColor {
        
        switch themeService.type {
        case .light:
            return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        default:
            return .Color_Black_272D34
        }
    }
    
    static var kUnSelectedColor: UIColor {
        
        switch themeService.type {
        case .light:
            return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        default:
            return .Color_Black_030303
        }
    }
}

// MARK: - Emoji URL

public extension URL {

    static let kAppleEmojiURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Emoticons.bundle/com.apple.emoji/info", ofType:"plist")!)
    
    static let kWeChatEmojiURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Expression.bundle/Expression", ofType:"plist")!)
}

// MARK: - Emoji Scanner

public extension String {
    
    static func scannerEmoji(_ code: String = "") -> String {
        guard code.length > 0 else {
            return "🙂"
        }
        
        
        //创建扫描器
        let scanner = Scanner(string: code)
        var result: UInt32 = 0
        //利用扫描器扫出结果
        scanner.scanHexInt32(&result)
        //将结果转换成字符
        let c = Character(UnicodeScalar(result)!)
        //将字符转换成字符串
        return String(c)
    }
}


// MARK:- 获取textView属性字符串,换成对应的表情字符串

extension UITextView {
    
    func getEmotionString() -> String {
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[.attachment] as? ChatEmotionAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.text!)
            }
        }
        
        return attrMStr.string
    }
    
    /// 添加表情图片
    func insertEmotion(emotion: ChatEmoticon) {
        // 空白
        if emotion.isSpace {
            return
        }
        
        // 删除
        if emotion.isDelete {
            deleteBackward()
            return
        }
        
        // 表情
        let attachment = ChatEmotionAttachment()
        attachment.text = emotion.text
        attachment.image = UIImage(contentsOfFile: emotion.imgPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = selectedRange
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        attributedText = attrMStr
        self.font = font
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
