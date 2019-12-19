//
//  WCDataBaseTable.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 MacOsx. All rights reserved.
//  本地缓存数据库表名称

import Foundation

typealias kTABLE = WCDataBaseTable

class WCDataBaseTable: NSObject, Codable {
    
    /// 数据库 - 表名称
    private enum TableName: String {
        case chatTable    = "chatTable"
        case messageTable = "messageTable"
        case sessionTable = "sessionTable"
    }
    
    static var chat : String {
        get {
            return TableName.chatTable.rawValue
        }
    }
    
    static var message : String {
        get {
            return TableName.messageTable.rawValue
        }
    }
    
    static var session : String {
        get {
            return TableName.sessionTable.rawValue
        }
    }
}
