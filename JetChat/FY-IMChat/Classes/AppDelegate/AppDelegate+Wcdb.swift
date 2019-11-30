//
//  AppDelegate+Wcdb.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/9.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import Foundation
import WCDBSwift

extension AppDelegate {
    
    /// 创建数据库-表
    func createWcdbTabel()
    {
        WCDataBaseManager.shared.createTable(table: db.chat, of: FYMessageChatModel.self)
        WCDataBaseManager.shared.createTable(table: db.message, of: FYMessageItem.self)
        WCDataBaseManager.shared.createTable(table: db.session, of: FYMessageItem.self)
    }
}
