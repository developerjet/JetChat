//
//  FYMessageChatModel.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/28.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import WCDBSwift

class FYMessageChatModel: FYMessageBaseModel, TableCodable {
        
    /// 主键自增id
    var identifier: Int? = nil
    /// 用户id
    var uid: Int? = nil
    /// 用户名称
    var name: String? = nil
    /// 用户头像
    var avatar: String? = nil
    /// 是否显示昵称
    var isShowName: Bool = false
    /// 聊天类型：1：单聊；2：群聊
    var chatType: Int? = nil
    /// 未读数
    var unReadCount: Int? = nil
    /// 备注名（昵称）
    var nickName: String? = nil
        
    enum CodingKeys: String, CodingTableKey {
        typealias Root = FYMessageChatModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier = "id"
        case uid
        case name
        case avatar
        case isShowName
        case chatType
        case unReadCount
        case nickName
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .identifier: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
}
