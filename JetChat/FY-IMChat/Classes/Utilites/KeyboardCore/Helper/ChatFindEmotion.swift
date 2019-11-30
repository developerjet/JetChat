//
//  ChatFindEmotion.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/22.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class ChatFindEmotion: NSObject {
    // MARK:- 单例
    static let shared: ChatFindEmotion = ChatFindEmotion()
    
    // MARK:- 查找属性字符串的方法
    func findAttrStr(text: String?, font: UIFont) -> NSMutableAttributedString? {
        guard let text = text else {
            return nil
        }
        
        let pattern = "\\[.*?\\]" // 匹配表情
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let resutlts = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        let attrMStr = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : font])
        
        for (_, result) in resutlts.enumerated().reversed() {
            let emojiCode = (text as NSString).substring(with: result.range)
            guard let imgPath = findImagePath(emojiCode: emojiCode) else {
                return nil
            }
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: imgPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        
        return attrMStr
    }
    
    
    func findImagePath(emojiCode: String) -> String? {
        for emotion in ChatEmotionHelper.getWeChatAllEmotions() {
            if emotion.text! == emojiCode {
                return emotion.imgPath
            }
        }
        return nil
    }
}
