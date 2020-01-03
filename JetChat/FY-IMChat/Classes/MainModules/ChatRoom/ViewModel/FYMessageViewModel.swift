//
//  FYMessageViewModel.swift
//  FY-IMChat
//
//  Created by fangyuan on 2020/1/3.
//  Copyright © 2020 iOS.Jet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import HandyJSON

public enum ChatDataType {
    case text
    case image
    case video
    case autoSend
}

class FYMessageViewModel: BaseViewModel, ViewModelType {
    
    /// 消息类型
    var messageType = BehaviorRelay<ChatDataType>(value: .text)
    /// 文本
    var content = BehaviorRelay<String>(value: "")
    
    var chatModel: FYMessageChatModel?
    
    
    // MARK: - Handler
    
    struct Input {
        let makeMessage: Observable<Void>
    }
    
    struct Output {
        let message: BehaviorRelay<FYMessageItem>
    }
    
    func transform(input: FYMessageViewModel.Input) -> FYMessageViewModel.Output {
        let outMessage = BehaviorRelay<FYMessageItem>(value: FYMessageItem())
        
        input.makeMessage.flatMapLatest ({ [weak self]() -> Single<FYMessageItem> in
            guard let self = self else {
                return Single.just(FYMessageItem())
            }
        
            if (self.messageType.value == .text) {
                return self.makeChatTextMessage().trackActivity(self.headerLoading).asSingle()
            }else if (self.messageType.value == .image) {
                return self.makeChatImageMessage().trackActivity(self.headerLoading).asSingle()
            }else if (self.messageType.value == .video) {
                return self.makeChatVideoMessage().trackActivity(self.headerLoading).asSingle()
            }else {
                return self.makeChatGroupAutoSend().trackActivity(self.headerLoading).asSingle()
            }
        })
            .asObservable()
            .subscribe(onNext: { (data) in
                outMessage.accept(data)
            }).disposed(by: rx.disposeBag)
        
        return Output(message: outMessage)
    }
    
    // MARK: - init
    
    init(chatModel: FYMessageChatModel) {
        super.init()
        
        self.chatModel = chatModel
    }
}

// MARK: - Configuration message

extension FYMessageViewModel {
    
    /// 文本消息
    func makeChatTextMessage() -> Single<FYMessageItem> {
        return Single<FYMessageItem>.create { single in
            let random = arc4random() % 9
            let msgItem = FYMessageItem()
            msgItem.message = self.content.value
            msgItem.chatId = self.chatModel?.uid
            if self.chatModel?.chatType == 1 {
                msgItem.sendType = random % 2 == 0 ? 1 : 0
                if self.chatModel?.nickName.isBlank == false {
                    msgItem.name = random % 2 == 0 ? self.chatModel?.nickName : "逆流而上"
                }else {
                    msgItem.name = random % 2 == 0 ? self.chatModel?.name : "逆流而上"
                }
                msgItem.avatar = random % 2 == 0 ? self.chatModel?.avatar : "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
            }else {
                msgItem.sendType = 0
                msgItem.name = "逆流而上"
                msgItem.avatar = "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
            }
            
            msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
            msgItem.msgType = 1 //文字
            msgItem.chatType = self.chatModel?.chatType
        
            single(.success(msgItem))
            return Disposables.create()
        }
    }
    
    
    /// 图片消息
    func makeChatImageMessage() -> Single<FYMessageItem> {
        return Single<FYMessageItem>.create { single in
            let random = arc4random() % 9
            let msgItem = FYMessageItem()
            msgItem.chatId = self.chatModel?.uid
            
            if self.chatModel?.chatType == 1 {
                msgItem.sendType = random % 2 == 0 ? 1 : 0
                if self.chatModel?.nickName.isBlank == false {
                    msgItem.name = random % 2 == 0 ? self.chatModel?.nickName : "逆流而上"
                    msgItem.nickName = random % 2 == 0 ? self.chatModel?.nickName : "逆流而上"
                }else {
                    msgItem.name = random % 2 == 0 ? self.chatModel?.name : "逆流而上"
                }
                msgItem.avatar = random % 2 == 0 ? self.chatModel?.avatar : "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
            }else {
                msgItem.sendType = 0
                msgItem.name = "逆流而上"
                msgItem.avatar = "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
            }
            
            msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
            msgItem.image = random % 2 == 0 ? "http://attachments.gfan.com/forum/attachments2/day_120501/1205012009f594464a3d69a145.jpg" : "http://gss0.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/aec379310a55b31905caba3b43a98226cffc1748.jpg"
            msgItem.msgType = 2 //图片
            msgItem.message = "【图片】"
            msgItem.chatType = self.chatModel?.chatType
            
            
            single(.success(msgItem))
            return Disposables.create()
        }
    }
    
    
    /// 视频消息
    func makeChatVideoMessage() -> Single<FYMessageItem> {
        return Single<FYMessageItem>.create { single in
            let random = arc4random() % 9
            let msgItem = FYMessageItem()
            msgItem.chatId = self.chatModel?.uid
            
            if self.chatModel?.chatType == 1 {
                msgItem.sendType = random % 2 == 0 ? 1 : 0
                if self.chatModel?.nickName.isBlank == false {
                    msgItem.name = random % 2 == 0 ? self.chatModel?.nickName : "逆流而上"
                    msgItem.nickName = random % 2 == 0 ? self.chatModel?.nickName : "逆流而上"
                }else {
                    msgItem.name = random % 2 == 0 ? self.chatModel?.name : "逆流而上"
                }
                msgItem.avatar = random % 2 == 0 ? self.chatModel?.avatar : "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
            }else {
                msgItem.sendType = 0
                msgItem.name = "逆流而上"
                msgItem.avatar = "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
            }
            
            msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
            msgItem.image = random % 2 == 0 ? "https://ss3.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2015696643,3638800543&fm=26&gp=0.jpg" : "https://i-3-qqxzb.qqxzb.com/2018/3/20/9b26bc6b-a037-4a93-b875-480e7253dd4c.jpg?imageView2/2/q/85"
            msgItem.video = random % 2 == 0 ? "localVideo0.mp4" : "https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4"
            msgItem.msgType = 3 //视频
            msgItem.message = "【视频】"
            msgItem.chatType = self.chatModel?.chatType
            
            
            single(.success(msgItem))
            return Disposables.create()
        }
    }
    
    
    /// 模拟群组群员自动发送消息
    func makeChatGroupAutoSend() -> Single<FYMessageItem> {
        return Single<FYMessageItem>.create { single in
            let random = arc4random() % 20
            let msgItem = FYMessageItem()
            msgItem.message = random % 2 == 0 ? "😬😬😬😬😬😬你觉得今天天气如何呢？" : "周末一起去郊游吧😸😸😸😸😸"
            msgItem.chatId = self.chatModel?.uid
            msgItem.sendType = 1
            msgItem.name = random % 2 == 0 ? "彩虹天堂🌈" : "惊鸿一面🍎"
            msgItem.avatar = random % 2 == 0 ? "https://img2.woyaogexing.com/2019/11/23/593796f9c01c43ca8c44b6501a45db90!400x400.jpeg" : "https://img2.woyaogexing.com/2019/11/11/4f3352cc750c4648a1c7e320cf045fbc!400x400.jpeg"
            msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
            msgItem.msgType = 1 //文字
            msgItem.chatType = self.chatModel?.chatType
            
            single(.success(msgItem))
            return Disposables.create()
        }
    }
}
