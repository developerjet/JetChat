//
//  FYMessageViewModel.swift
//  FY-JetChat
//
//  Created by fangyuan on 2020/1/3.
//  Copyright © 2020 iOS.Jet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HandyJSON
import YBImageBrowser

public enum ChatDataType {
    case none
    case text
    case image
    case video
    case autoSend
}

public enum BrowserTypeData {
    case none
    case image
    case video
}

class FYMessageViewModel: BaseViewModel, ViewModelType {
    
    /// 消息类型
    var messageType = BehaviorRelay<ChatDataType>(value: .none)
    /// 浏览图片&视频类型
    var browserType = BehaviorRelay<BrowserTypeData>(value: .none)
    
    /// 文本
    var content = BehaviorRelay<String>(value: "")
    /// 图片索引
    var imageIndex = BehaviorRelay<Int>(value: 0)
    
    var tableView: UITableView?
    var chatModel: FYMessageChatModel?
    
    /// 图片视频浏览
    var dataSource = BehaviorRelay<[FYMessageItem]>.init(value: [])
    var browserIndexs = BehaviorRelay<[Int: Int]>.init(value: [:])
    
    // MARK: - Transform
    
    struct Input {
        let makeMessage: Observable<Void>
        let makeBrowser: Observable<Void>
    }
    
    struct Output {
        let message: BehaviorRelay<FYMessageItem>
        let browser: BehaviorRelay<[AnyObject]>
    }
    
    func transform(input: FYMessageViewModel.Input) -> FYMessageViewModel.Output {
        let outMessage = BehaviorRelay<FYMessageItem>(value: FYMessageItem())
        let outBrowsers = BehaviorRelay<[AnyObject]>(value: [])
        
        // 发送消息
        input.makeMessage.flatMapLatest ({ [weak self]() -> Single<FYMessageItem> in
            guard let self = self else {
                return Single.never()
            }
        
            if (self.messageType.value == .text) {
                return self.makeChatTextMessage().trackActivity(self.loading).asSingle()
            }else if (self.messageType.value == .image) {
                return self.makeChatImageMessage().trackActivity(self.loading).asSingle()
            }else if (self.messageType.value == .video) {
                return self.makeChatVideoMessage().trackActivity(self.loading).asSingle()
            }else if (self.messageType.value == .autoSend) {
                return self.makeChatGroupAutoSend().trackActivity(self.loading).asSingle()
            }else {
                return Single.never()
            }
        })
            .asObservable()
            .subscribe(onNext: { (data) in
                outMessage.accept(data)
            }).disposed(by: rx.disposeBag)
        
        // 浏览图片
        input.makeBrowser.flatMapLatest ({ [weak self]() -> Single<[AnyObject]> in
            guard let self = self else {
                return Single.never()
            }
            
            if (self.browserType.value == .image) {
                return self.makeBrowserImagesData().trackActivity(self.loading).asSingle()
            }else if (self.browserType.value == .video) {
                return self.makeBrowserVideosData().trackActivity(self.loading).asSingle()
            }else {
                return Single.never()
            }
        })
            .asObservable()
            .subscribe(onNext: { (objects) in
                outBrowsers.accept(objects)
            }).disposed(by: rx.disposeBag)
        
        return Output(message: outMessage, browser: outBrowsers)
    }
    
    // MARK: - init
    
    init(chatModel: FYMessageChatModel) {
        super.init()
        
        self.chatModel = chatModel
    }
}

// MARK: - Configuration Message

extension FYMessageViewModel {
    
    /// 文本消息
    private func makeChatTextMessage() -> Single<FYMessageItem> {
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
    private func makeChatImageMessage() -> Single<FYMessageItem> {
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
            msgItem.image = random % 2 == 0 ? "http://img2.woyaogexing.com/2022/04/27/76d9d570d2004c9ba326587045dede07!360x640.jpeg" : "http://img2.woyaogexing.com/2022/04/27/fcc7c52df7454e1680a6625cc3fea7b0.jpeg"
            msgItem.msgType = 2 //图片
            msgItem.message = "【图片】"
            msgItem.chatType = self.chatModel?.chatType
            
            single(.success(msgItem))
            return Disposables.create()
        }
    }
    
    
    /// 视频消息
    private func makeChatVideoMessage() -> Single<FYMessageItem> {
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
            msgItem.image = random % 2 == 0 ? "http://img2.woyaogexing.com/2022/04/25/e484edc5029c41fda2e0dbf1b4310818.jpeg" : "http://img2.woyaogexing.com/2022/04/28/69f49803d9ea443c84c88907e8e76879.jpeg"
            msgItem.video = random % 2 == 0 ? "localVideo0.mp4" : "https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4"
            msgItem.msgType = 3 //视频
            msgItem.message = "【视频】"
            msgItem.chatType = self.chatModel?.chatType
            
            
            single(.success(msgItem))
            return Disposables.create()
        }
    }
    
    
    /// 自动发送文本信息
    private func makeChatAutoSendText() -> Single<FYMessageItem> {
        
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
    

    /// 模拟群组群员自动发送消息
    private func makeChatGroupAutoSend() -> Single<FYMessageItem> {
        let random = arc4random() % 3
        
        switch random {
        case 0:
            return makeChatImageMessage()
        case 1:
            return makeChatVideoMessage()
        default:
            return makeChatAutoSendText()
        }
    }
}


// MARK: - Configuration ImageData

extension FYMessageViewModel {
    
    private func makeBrowserImagesData() -> Single<[AnyObject]> {
        return Single<[AnyObject]>.create { single in
            var indexs: [Int: Int] = [:]
            var images: [YBIBImageData] = []
            
            var imageIndex = 0
            for (index, model) in self.dataSource.value.enumerated() {
                if model.msgType == 2 {
                    let data = YBIBImageData()
                    data.imageURL = URL(string: model.image!)
                    data.projectiveView = self.projectiveViewAtRow(self.imageIndex.value)
                    images.append(data)
                    imageIndex += 1 //图片索引
                }
                
                indexs[index] = imageIndex
            }
            
            self.browserIndexs.accept(indexs)
            
            single(.success(images))
            return Disposables.create()
        }
    }
    
    private func makeBrowserVideosData() -> Single<[AnyObject]> {
        return Single<[AnyObject]>.create { single in
            var videos: [YBIBVideoData] = []
            var indexs: [Int: Int] = [:]
            
            var videoIndex = 0
            for (index, model) in self.dataSource.value.enumerated() {
                if model.msgType == 3 {
                    if (model.video?.hasSuffix(".mp4"))! && (model.video?.hasPrefix("http"))! { //网络视频
                        let data = YBIBVideoData()
                        UIImageView().downloadImageWithURL(model.image!, callback: { (result) in
                            printLog("thumbImage\(result)")
                            switch result {
                            case .success(let value):
                                data.thumbImage = value
                            case .failure(let error):
                                printLog("Job failed: \(error)")
                            }
                        })
                        data.videoURL = URL(string: model.video!)
                        data.projectiveView = self.projectiveViewAtRow(self.imageIndex.value)
                        videos.append(data)
                        videoIndex += 1 //图片索引
                    }else {
                        if let path = Bundle.main.path(forResource: model.video?.deletingPathExtension, ofType:model.video?.pathExtension) {
                            let data = YBIBVideoData()
                            UIImageView().downloadImageWithURL(model.image!, callback: { (result) in
                                printLog("thumbImage\(result)")
                                switch result {
                                case .success(let value):
                                    data.thumbImage = value
                                case .failure(let error):
                                    printLog("Job failed: \(error)")
                                }
                            })
                            data.videoURL = URL(fileURLWithPath: path)
                            data.projectiveView = self.projectiveViewAtRow(self.imageIndex.value)
                            videos.append(data)
                            videoIndex += 1 //图片索引
                        }
                    }
                }
                
                indexs[index] = videoIndex
            }
            
            self.browserIndexs.accept(indexs)
            
            single(.success(videos))
            return Disposables.create()
        }
    }
    
    
    private func projectiveViewAtRow(_ row: Int) -> UIView {
        guard let table = tableView else {
            return UIView()
        }
        
        let indexPath = IndexPath(row: row, section: 0)
        if let imageCell = table.cellForRow(at: indexPath) as? FYImageMessageCell {
            return imageCell.pictureView
        }else {
            let videoCell = table.cellForRow(at: indexPath) as? FYVideoMessageCell
            return videoCell?.videoImageView ?? UIView()
        }
    }
}
