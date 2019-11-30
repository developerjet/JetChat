//
//  ChatEmoticon.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/18.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

@objcMembers
class ChatEmoticon: NSObject {
    
    // MARK:- 定义属性
    
    var type: String?
    var chs: String?
    var text: String?
    
    
    var image: String? {   // 表情对应的图片名称
        didSet {
            imgPath = Bundle.main.bundlePath + "/Expression.bundle/" + image! + ".png"
        }
    }
    
    
    var code: String? {
        didSet {
            if let code = code {
                //创建扫描器
                let scanner = Scanner(string: code)
                var result: UInt32 = 0
                //利用扫描器扫出结果
                scanner.scanHexInt32(&result)
                //将结果转换成字符
                let c = Character(UnicodeScalar(result)!)
                //将字符转换成字符串
                emojiCode = String(c)
            }
        }
    }
    
    /// emoji表情解析后的code码
    var emojiCode: String?
    
    /// 图片的绝对路径
    var imgPath: String?
    
    /// 是否是移除键
    var isDelete: Bool = false
    /// 是否是空格
    var isSpace: Bool = false
    
     init(dict: [String: String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    init(isDelete: Bool) {
        super.init()
        self.isDelete = true
    }
    
    init(isSpace: Bool) {
        super.init()
        self.isSpace = true
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

