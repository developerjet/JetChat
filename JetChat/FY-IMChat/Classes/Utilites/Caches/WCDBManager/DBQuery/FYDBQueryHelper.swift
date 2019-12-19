//
//  FYDBQueryHelper.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/27.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import WCDBSwift

class FYDBQueryHelper: NSObject {
    
    /// 操作单利
    static let shared = FYDBQueryHelper.init()
    
    override init() {
        super.init()
    }
    
    // MARK: - 消息缓存处理
    
    /// 添加当前消息
    /// - Parameter objects: 消息实体
    func insertFromMessage(_ object: FYMessageItem) {
        WCDataBaseManager.shared.insertToDb(objects: [object], intoTable:kTABLE.message)
    }
    
    /// 查询对应的消息列表
    /// - Parameter chatId: 会话id
    func qureyFromMessagesWithChatId(_ chatId: Int) -> [FYMessageItem] {
        var sesstions: [FYMessageItem] = []
        let query = FYMessageItem.Properties.chatId == chatId
        if let dbData = WCDataBaseManager.shared.qureyFromDb(fromTable: kTABLE.message, cls: FYMessageItem.self, where: query) {
            sesstions.append(contentsOf: dbData)
        }
        return sesstions
    }
    
    /// 查询单个消息
    /// - Parameter sesstionId: 消息id
    func qureyFromMessageId(_ messageId: Int) -> FYMessageItem {
        var sesstion = FYMessageItem()
        let query = FYMessageItem.Properties.messageId == messageId
        if let dbData = WCDataBaseManager.shared.qureyFromDb(fromTable: kTABLE.message, cls: FYMessageItem.self, where: query) {
            if (dbData.count > 0) {
                sesstion = dbData.map{ $0 }.first!
            }
        }
        return sesstion
    }
    
    /// 删除单个消息
    /// - Parameter messageId: 消息id
    func deleteFromMessageId(_ messageId: Int) {
        let query = FYMessageItem.Properties.messageId == messageId
        WCDataBaseManager.shared.deleteFromDb(fromTable: kTABLE.message, where: query)
    }
    
    
    /// 更新某个消息
    /// - Parameters:
    ///   - message: 消息
    ///   - messageId: 消息id
    func updateFromMessageWithId(_ message: FYMessageItem, messageId: Int) {
        let query = FYMessageItem.Properties.messageId == messageId
        WCDataBaseManager.shared.updateToDb(table: kTABLE.chat, on: FYMessageChatModel.Properties.all, with: message, where: query)
    }
    
    /// 根据聊天类型删除消息列表
    /// - Parameter chatType: （聊天类型：1：单聊；2：群聊）
    func deleteFromMessagesWithType(_ chatType: Int) {
        let query = FYMessageItem.Properties.chatType == chatType
        WCDataBaseManager.shared.deleteFromDb(fromTable: kTABLE.message, where: query)
    }
    
    /// 删除对应的消息列表
    /// - Parameter chatId: 会话id
    func deleteFromMesssageWithId(_ chatId: Int) {
        let query = FYMessageItem.Properties.chatId == chatId
        WCDataBaseManager.shared.deleteFromDb(fromTable: kTABLE.message, where: query)
    }
    
    
    /// 查询当前的消息会话列表
    func qureyFromLastSesstions() -> [FYMessageItem] {
        let chats = FYDBQueryHelper.shared.queryFromAllChats()
        var sesstions: [FYMessageItem] = []
        for chat in chats {
            if let chatId = chat.uid {
                let messages = FYDBQueryHelper.shared.qureyFromMessagesWithChatId(chatId)
                if messages.count > 0 {
                    if let model = messages.last {
                        model.name = chat.name
                        model.nickName = chat.nickName //备注名称
                        model.avatar = chat.avatar
                        model.chatType = chat.chatType
                        model.unReadCount = chat.unReadCount
                        sesstions.append(model) //获取最后一条消息
                    }
                }
                
            }
        }
        
        
        
        // 排序处理
        return sesstions.sorted {
            return $0.date?.stringToTimeStamp().doubleValue ?? 0 >= $1.date?.stringToTimeStamp().doubleValue ?? 0
        }
    }
    
    
    /// 获取当前的未读消息总数
    func queryFromSesstionsUnReadCount() -> Int {
        var badge: Int = 0
        let chats = FYDBQueryHelper.shared.queryFromAllChats()
        for chat in chats {
            if let unReadCount = chat.unReadCount {
                badge += unReadCount
            }
        }
        
        return badge
    }

    // MARK: - 用户或者群列表缓存处理
    
    /// 添加聊天用户或者群
    /// - Parameter chat: 用户或者群
    func insertFromChat(_ chat: FYMessageChatModel) {
        WCDataBaseManager.shared.insertToDb(objects: [chat], intoTable:kTABLE.chat)
    }
    
    
    /// 更新好友群信息
    /// - Parameters:
    ///   - chat: 好友或者群
    ///   - uid: 好友或群id
    func updateFromChatModel(_ chat: FYMessageChatModel, uid: Int) {
        let query = FYMessageChatModel.Properties.uid == uid
        WCDataBaseManager.shared.updateToDb(table: kTABLE.chat, on: FYMessageChatModel.Properties.all, with: chat, where: query)
    }
    
    /// 删除所有单聊用户或者群聊
    /// - Parameter chatType: （聊天类型：1：单聊；2：群聊）
    func deleteFromChatsWithType(_ chatType: Int) {
        let query = FYMessageChatModel.Properties.chatType == chatType
        WCDataBaseManager.shared.deleteFromDb(fromTable: kTABLE.chat, where: query)
    }
    
    /// 删除单个好友或者群
    /// - Parameter uid: 好友或群id
    func deleteFromChatWithId(_ uid: Int) {
        let query = FYMessageChatModel.Properties.uid == uid
        WCDataBaseManager.shared.deleteFromDb(fromTable: kTABLE.chat, where: query)
    }
    
    
    /// 查询当前好友或者群列表
    /// - Parameter chatType: 聊天类型
    func qureyFromChatsWithType(_ chatType: Int) -> [FYMessageChatModel] {
        var sesstions: [FYMessageChatModel] = []
        let query = FYMessageChatModel.Properties.chatType == chatType
        if let dbData = WCDataBaseManager.shared.qureyFromDb(fromTable: kTABLE.chat, cls: FYMessageChatModel.self, where: query) {
            sesstions.append(contentsOf: dbData)
        }
        return sesstions
    }
    
    /// 查询当前所有好友或者群列表
    func queryFromAllChats() -> [FYMessageChatModel] {
        var sesstions: [FYMessageChatModel] = []
        let query = FYMessageChatModel.Properties.all.count
        if let dbData = WCDataBaseManager.shared.qureyFromDb(fromTable: kTABLE.chat, cls: FYMessageChatModel.self, where: query) {
            sesstions.append(contentsOf: dbData)
        }
        return sesstions
    }
    
    
    /// 查询单个好友或者群
    /// - Parameter uid: 好友或群ID
    func qureyFromChatId(_ uid: Int) -> FYMessageChatModel {
        var chat = FYMessageChatModel()
        let query = FYMessageChatModel.Properties.uid == uid
        if let dbData = WCDataBaseManager.shared.qureyFromDb(fromTable: kTABLE.chat, cls: FYMessageChatModel.self, where: query) {
            if dbData.count > 0 {
                chat = dbData.map{ $0 }.first!
            }
        }
        return chat
    }
    
}
