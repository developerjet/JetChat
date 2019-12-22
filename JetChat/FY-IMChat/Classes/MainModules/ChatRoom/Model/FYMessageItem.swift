//
//  FYMessageItem.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/20.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import WCDBSwift

//消息发送类型，我的还是别人的
enum SendType: Int {
    case mine = 0
    case someone = 1
}


class FYMessageItem: FYMessageBaseModel, TableCodable {
    
    /// 消息id（主键 - 自增长）
    var messageId: Int? = nil
    /// 会话id
    var chatId: Int? = nil
    
    var name: String? = nil
    var avatar: String? = nil
    var message: String? = nil
    var image: String? = nil
    var video: String? = nil
    
    /// 消息发送时间
    var date: String? = nil
    /// 消息类型：文字:1；2:图片
    var msgType: Int? = nil
    /// 消息发送方式：0:我的；1:别人
    var sendType: Int? = nil
    /// 聊天类型：1：单聊；2：群聊；3：视频
    var chatType: Int? = nil
    /// 未读数
    var unReadCount: Int? = nil
    
    /// 备注名称
    var nickName: String? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = FYMessageItem
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case messageId = "id"
        case chatId
        case name
        case avatar
        case message
        case date
        case image
        case video
        case sendType
        case msgType
        case chatType
        case unReadCount
        case nickName
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .messageId: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
}
