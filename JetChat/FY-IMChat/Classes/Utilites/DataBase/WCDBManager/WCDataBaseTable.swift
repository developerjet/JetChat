//
//  WCDataBaseTable.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 MacOsx. All rights reserved.
//  本地缓存数据库表名称

import Foundation

typealias kTABLE = WCDataBaseTable

/// 数据库 - 表名称
enum WCDataBaseTable: String {
    case chatTable    = "chatTable"
    case messageTable = "messageTable"
    case sessionTable = "sessionTable"
}

extension WCDataBaseTable {
    
    static var chat : String {
        get {
            return self.chatTable.rawValue
        }
    }
    
    static var message : String {
        get {
            return self.messageTable.rawValue
        }
    }
    
    static var session : String {
        get {
            return self.sessionTable.rawValue
        }
    }
}
