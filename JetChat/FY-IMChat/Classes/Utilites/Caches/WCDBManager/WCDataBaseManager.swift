//
//  WCDataBaseManager.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import Foundation
import WCDBSwift


fileprivate struct WCDataBasePath {
    
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                     .userDomainMask,
                                                     true).last! + "/WCDB/FYIM.db"
}

class WCDataBaseManager: NSObject {
    
    static let shared = WCDataBaseManager()
    
    let dataBasePath = URL(fileURLWithPath: WCDataBasePath().dbPath)
    
    var dataBase: Database?
    
    private override init() {
        super.init()

        dataBase = createDb()
    }
    
    ///创建表
    private func createDb() -> Database {
        debugPrint("数据库路径==\(dataBasePath.absoluteString)")
        return Database(withFileURL: dataBasePath)
    }
    
    
    ///创建表
    func createTable<T: TableDecodable>(table: String, of ttype:T.Type) -> Void {
        do {
            try dataBase?.create(table: table, of:ttype)
        } catch let error {
            debugPrint("create table error \(error.localizedDescription)")
        }
    }
    
    
    ///插入
    func insertToDb<T: TableEncodable>(objects: [T], intoTable table: String) -> Void {
        do {
            try dataBase?.insert(objects: objects, intoTable: table)
        } catch let error {
            debugPrint(" insert obj error \(error.localizedDescription)")
        }
    }
    
    ///修改
    func updateToDb<T: TableEncodable>(table: String, on propertys:[PropertyConvertible],with object:T,where condition: Condition? = nil) -> Void {
        do {
            try dataBase?.update(table: table, on: propertys, with: object, where: condition)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
        }
    }
    
    ///删除
    func deleteFromDb(fromTable: String, where condition: Condition? = nil) -> Void {
        do {
            try dataBase?.delete(fromTable: fromTable, where:condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
    
    ///查询
    func qureyFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where:condition, orderBy:orderList))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    ///删除数据表
    func dropTable(table: String) -> Void {
        do {
            try dataBase?.drop(table: table)
        } catch let error {
            debugPrint("drop table error \(error)")
        }
    }
    
    /// 删除所有与该数据库相关的文件
    func removeDbFile() -> Void {
        do {
            try dataBase?.close(onClosed: {
                try dataBase?.removeFiles()
            })
        } catch let error {
            debugPrint("not close db \(error)")
        }
    }
    
}
