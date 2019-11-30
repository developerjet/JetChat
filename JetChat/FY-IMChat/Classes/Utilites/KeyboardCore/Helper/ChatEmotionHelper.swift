//
//  ChatEmotionHelper.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/21.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class ChatEmotionHelper: NSObject {
    
    // MARK:- 获取Apple表情模型数组
    class func getAppleAllEmotions() -> [ChatEmoticon] {
        var emotions: [ChatEmoticon] = [ChatEmoticon]()
        let root = NSDictionary(contentsOf: .kAppleEmojiURL)
        let array = root?["emoticons"] as! [[String : String]]
        var index = 0
        for dict in array {
            emotions.append(ChatEmoticon(dict: dict))
            index += 1
            if index == 23 {
                // 添加删除表情
                emotions.append(ChatEmoticon(isDelete: true))
                index = 0
            }
        }
        
        // 添加空白表情
        emotions = self.addEmptyEmotion(emotiions: emotions)
        
        return emotions
    }
    
    // MARK: - 获取WeChat表情模型数组
    class func getWeChatAllEmotions() -> [ChatEmoticon] {
        var emotions: [ChatEmoticon] = [ChatEmoticon]()
        let plistPath = Bundle.main.path(forResource: "Expression", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        
        var index = 0
        for dict in array {
            emotions.append(ChatEmoticon(dict: dict))
            index += 1
            if index == 23 {
                // 添加删除表情
                emotions.append(ChatEmoticon(isDelete: true))
                index = 0
            }
        }
        
        // 添加空白表情
        emotions = self.addEmptyEmotion(emotiions: emotions)
        
        return emotions
    }
    
    // 添加空白表情
    fileprivate class func addEmptyEmotion(emotiions: [ChatEmoticon]) -> [ChatEmoticon] {
        var emos = emotiions
        let count = emos.count % 24
        if count == 0 {
            return emos
        }
        for _ in count..<23 {
            emos.append(ChatEmoticon(isSpace: true))
        }
        emos.append(ChatEmoticon(isDelete: true))
        return emos
    }
    
    class func getImagePath(emotionName: String?) -> String? {
        if emotionName == nil {
            return nil
        }
        return Bundle.main.bundlePath + "/Expression.bundle/" + emotionName! + ".png"
    }
}
