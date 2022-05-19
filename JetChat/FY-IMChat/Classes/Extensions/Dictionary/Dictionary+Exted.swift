//
//  Dictionary+EXTension.swift
//  SZBookMall
//
//  Created by fisland on 2017/11/20.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
        for (k, v) in right {
            left.updateValue(v, forKey: k)
        }
    }
    
    func toJSONString() -> String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    
    func toData() -> Data {
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        return data!
    }
}
