//
//  FYMessageUserModel.swift
//  FY-IMChat
//
//  Created by fangyuan on 2019/12/14.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import WCDBSwift

class FYMessageUserModel: FYMessageBaseModel, TableCodable {
        
    /// 主键自增id
    var identifier: Int? = nil
    /// 用户id
    var uid: Int? = nil
    /// 用户名称
    var name: String? = nil
    /// 用户头像
    var avatar: String? = nil
    /// 备注名（昵称）
    var nickName: String? = nil
        
    enum CodingKeys: String, CodingTableKey {
        typealias Root = FYMessageUserModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier = "id"
        case uid
        case name
        case avatar
        case nickName
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .identifier: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
}
