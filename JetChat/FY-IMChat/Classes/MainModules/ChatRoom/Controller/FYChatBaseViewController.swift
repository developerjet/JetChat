//
//  FYChatBaseViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/13.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SKPhotoBrowser


public enum ChatType: Int {
    case singleChat  = 1
    case groupedChat = 2
}

private let kTextMessageCellIdentifier  = "kTextMessageCellIdentifier"
private let kImageMessageCellIdentifier = "kImageMessageCellIdentifier"

class FYChatBaseViewController: FYBaseConfigViewController {
    
    /// 角标数记录
    private var badge: Int = 0
    
    // 键盘收起/弹出
    private var isBecome: Bool = false
    private var isSended: Bool = true
    private var isTimered: Bool = false
    private let keyboardLastY: CGFloat = 301
    
    private let kToolBarLastH: CGFloat = 52
    private var kToolBarLastY: CGFloat = 551
    private var lastMaxY: CGFloat = 0.0
    
    // MARK: - var lazy
    
    /// 聊天类型（默认单聊）
    var chatType: ChatType? = .singleChat
    var chatModel: FYMessageChatModel? = FYMessageChatModel()
    
    var timer: Timer?
    var imageIndexs: [Int: Int] = [:]
    var dataSource: [FYMessageItem] = []
    
    lazy var keyboardView: ChatKeyboardView = {
        let toolBarY = kScreenH - kNavigaH - kToolBarLastH - kSafeAreaBottom
        let view = ChatKeyboardView(frame: CGRect(x: 0, y: toolBarY, width: kScreenW, height: kToolBarLastH))
        view.delegate = self
        return view
    }()
    
    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 禁止侧滑返回手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        // stop timer
        stopSendTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGroundGrayColor()
        if chatModel?.nickName.isBlank == false {
            navigationItem.title = chatModel?.nickName
        }else {
            navigationItem.title = chatModel?.name
        }
        
        makeUI()
        loadCacheData()
    }
    
    /// 构造聊天会话
    /// - Parameter chatModel: 聊天实体（分单聊、群聊）
    convenience init(chatModel: FYMessageChatModel) {
        self.init()
        
        self.chatModel = chatModel
        if let type = self.chatModel?.chatType {
            self.chatType = ChatType(rawValue: type)
        }
    }
    
    override func makeUI() {
        super.makeUI()
        
        if chatType == .groupedChat {
            let rightBarButtonItem = UIBarButtonItem(title: "退出群", style: .plain, target: self, action: #selector(exitGroupChat))
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        let height = kScreenH - (kToolBarLastH + kSafeAreaBottom + kNavigaH)
        plainTabView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: height)
        plainTabView.dataSource = self
        plainTabView.delegate = self
        plainTabView.separatorStyle = .none
        plainTabView.estimatedRowHeight = 100
        plainTabView.tableFooterView = UIView()
        plainTabView.showsVerticalScrollIndicator = true
        registerCellForTable(plainTabView)
        view.addSubview(plainTabView)
        // 添加聊天键盘
        view.addSubview(keyboardView)
    }
    
    private func startSendTimer() {
        timer = Timer(timeInterval: 20, target: self, selector: #selector(makeGroupAutoSend), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        timer?.fire() // 启动定时器
        
        isTimered = true
    }
    
    private func stopSendTimer() {
        if isTimered {
            timer?.invalidate()
        }
    }
    
    private func registerCellForTable(_ table: UITableView) {
        table.register(FYTextMessageCell.self, forCellReuseIdentifier: kTextMessageCellIdentifier)
        table.register(FYImageMessageCell.self, forCellReuseIdentifier: kImageMessageCellIdentifier)
    }
    
    /// 滚到底部
    private func scrollToBottom(_ animated: Bool = true) {
        if dataSource.count >= 1 {
            plainTabView.scrollToRow(at: IndexPath(row: dataSource.count - 1, section: 0), at: .bottom, animated: animated)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch = touches.first! as UITouch
        let myLocation = myTouch.location(in: self.view)
        if myLocation.y < keyboardLastY {
            NotificationCenter.default.post(name: .kChatTextKeyboardNeedHide, object: nil)
        }
    }
    
    
    /// 退出群聊
    @objc private func exitGroupChat() {
        EasyAlertView.shared.customAlert(title: "确定退出当前群组吗？", message: "", confirm: "确定", cancel: "取消", vc: self, confirmBlock: {
            if let uid = self.chatModel?.uid {
                self.stopSendTimer()
                FYDBQueryHelper.shared.deleteFromChatWithId(uid)
                FYDBQueryHelper.shared.deleteFromMesssageWithId(uid)
                // 退出群
                NotificationCenter.default.post(name: .kNeedRefreshChatInfoList, object: nil)
                
                MBHUD.showMessage("你已退出：\(self.chatModel?.name ?? "")群聊")
                self.navigationController?.popViewController()
            }
        }, cancelBlock: {
            
        })
    }
    
    deinit {
        stopSendTimer()
    }
}


// MARK: - ChatKeyboardViewDelegate

extension FYChatBaseViewController: ChatKeyboardViewDelegate {
    
    func keyboard(_ keyboard: ChatKeyboardView, DidFinish content: String) {
        makeTextMessage(content)
    }
    
    func keyboard(_ keyboard: ChatKeyboardView, DidBecome isBecome: Bool) {
        self.isSended = true
        self.isBecome = isBecome
    }
    
    func keyboard(_ keyboard: ChatKeyboardView, DidMoreMenu type: ChatMoreMenuType) {
        if (type == .album) {
            openAlbum()
        }
    }
    
    func keyboard(_ keyboard: ChatKeyboardView, DidObserver offsetY: CGFloat) {
        //MBHUD.showMessage("输入框y值：\(offsetY)")
        restChatKeyboardSafeTop(offsetY)
    }
    
    private func restChatKeyboardSafeTop(_ offsetY: CGFloat) {
        if (dataSource.count >= 1) {
            let lastIndex = IndexPath(row: dataSource.count - 1, section: 0)
            let rect = plainTabView.rectForRow(at: lastIndex)
            if rect.width > 0 {
                lastMaxY = rect.origin.y + rect.size.height
                if (lastMaxY <= plainTabView.height) {
                    if (lastMaxY >= offsetY) {
                        plainTabView.y = offsetY - lastMaxY
                    }else {
                        plainTabView.y = 0
                    }
                    
                }else {
                    
                    plainTabView.y += offsetY - plainTabView.maxY;
                }
            }else {
                
                printLog("========😁😁😁😁😁😁😁😁")
            }
        }
    }
    
    private func makeTextMessage(_ content: String) {
        let random = arc4random() % 9
        let msgItem = FYMessageItem()
        msgItem.message = content
        msgItem.chatId = chatModel?.uid
        if chatModel?.chatType == 1 {
            msgItem.sendType = random % 2 == 0 ? 1 : 0
            if chatModel?.nickName.isBlank == false {
                msgItem.name = random % 2 == 0 ? chatModel?.nickName : "逆流而上"
            }else {
                msgItem.name = random % 2 == 0 ? chatModel?.name : "逆流而上"
            }
            msgItem.avatar = random % 2 == 0 ? chatModel?.avatar : "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
        }else {
            msgItem.sendType = 0
            msgItem.name = "逆流而上"
            msgItem.avatar = "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
        }
        
        msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        msgItem.msgType = 1 //文字
        msgItem.chatType = chatModel?.chatType
        
        reloadChatData(msgItem)
        
        if chatModel?.chatType == 2 && isTimered == false {
            startSendTimer()
        }
    }

    private func makeImageMessage(_ url: String = "") {
        let random = arc4random() % 9
        let msgItem = FYMessageItem()
        msgItem.chatId = chatModel?.uid
        
        if chatModel?.chatType == 1 {
            msgItem.sendType = random % 2 == 0 ? 1 : 0
            if chatModel?.nickName.isBlank == false {
                msgItem.name = random % 2 == 0 ? chatModel?.nickName : "逆流而上"
                msgItem.nickName = random % 2 == 0 ? chatModel?.nickName : "逆流而上"
            }else {
                msgItem.name = random % 2 == 0 ? chatModel?.name : "逆流而上"
            }
            msgItem.avatar = random % 2 == 0 ? chatModel?.avatar : "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
        }else {
            msgItem.sendType = 0
            msgItem.name = "逆流而上"
            msgItem.avatar = "https://img2.woyaogexing.com/2019/11/27/d1dddb1e1faf4b578f12b28a08b04174!400x400.jpeg"
        }
        
        msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        msgItem.image = random % 2 == 0 ? "http://attachments.gfan.com/forum/attachments2/day_120501/1205012009f594464a3d69a145.jpg" : "http://gss0.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/aec379310a55b31905caba3b43a98226cffc1748.jpg"
        msgItem.msgType = 2 //图片
        msgItem.message = "【图片】"
        msgItem.chatType = chatModel?.chatType
        
        reloadChatData(msgItem)
        
        if chatModel?.chatType == 2 && isTimered == false {
            startSendTimer()
        }
    }
    
    /// 模拟群组聊天自动发送消息
    @objc private func makeGroupAutoSend() {
        let random = arc4random() % 20
        let msgItem = FYMessageItem()
        msgItem.message = random % 2 == 0 ? "😬😬😬😬😬😬你觉得今天天气如何呢？" : "周末一起去郊游吧😸😸😸😸😸"
        msgItem.chatId = chatModel?.uid
        msgItem.sendType = 1
        msgItem.name = random % 2 == 0 ? "彩虹天堂🌈" : "惊鸿一面🍎"
        msgItem.avatar = random % 2 == 0 ? "https://img2.woyaogexing.com/2019/11/23/593796f9c01c43ca8c44b6501a45db90!400x400.jpeg" : "https://img2.woyaogexing.com/2019/11/11/4f3352cc750c4648a1c7e320cf045fbc!400x400.jpeg"
        msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        msgItem.msgType = 1 //文字
        msgItem.chatType = chatModel?.chatType
        
        reloadChatData(msgItem)
    }
    
    
    private func reloadChatData(_ msgItem: FYMessageItem) {
        isSended = true
        dataSource.append(msgItem)
        DispatchQueue.main.async {
            self.plainTabView.reloadData {
                self.scrollToBottom()
                self.beginCacheMessage(msgItem)
                self.restChatKeyboardSafeTop(self.keyboardView.y)
            }
        }
    }
}

// MARK: - MoreMenu Manager

extension FYChatBaseViewController: TZImagePickerControllerDelegate {
    
    private func openAlbum() {
        let imagePicker = TZImagePickerController(maxImagesCount: 1, columnNumber: 5, delegate: self)
        imagePicker?.didFinishPickingPhotosHandle = {(images: [UIImage]?, assets:[Any]?, isSelectOriginalPhoto: Bool) in
            printLog(images)
            self.makeImageMessage()
        }
        
        present(imagePicker!, animated: true, completion: nil)
    }
}

// MARK: - DataBase

extension FYChatBaseViewController {
    
    func beginCacheMessage(_ object: FYMessageItem) {
        FYDBQueryHelper.shared.insertFromMessage(object)
        
        // 更新角标
        self.badge += 1
        if let uid = self.chatModel?.uid {
            self.chatModel?.unReadCount = self.badge
            FYDBQueryHelper.shared.updateFromChatModel(self.chatModel!, uid: uid)
            // 通知刷新会话列表
            NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
        }
    }
    
    func loadCacheData() {
        if let chatId = chatModel?.uid {
            dataSource = FYDBQueryHelper.shared.qureyFromMessagesWithChatId(chatId)
        }
        
        DispatchQueue.main.async {
            self.plainTabView.reloadData {
                self.scrollToBottom(false)
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension FYChatBaseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = dataSource[safe: indexPath.row] {
            if model.msgType == 1 {
                let textCell = tableView.dequeueReusableCell(withIdentifier: kTextMessageCellIdentifier) as! FYTextMessageCell
                textCell.delegate = self
                configureCellModel(cell: textCell, at: indexPath)
                return textCell
            }else {
                let imageCell = tableView.dequeueReusableCell(withIdentifier: kImageMessageCellIdentifier) as! FYImageMessageCell
                configureCellModel(cell: imageCell, at: indexPath)
                imageCell.delegate = self
                return imageCell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let model = dataSource[safe: indexPath.row] {
            if model.msgType == 1 {
                return plainTabView.fd_heightForCell(withIdentifier: kTextMessageCellIdentifier, cacheBy: indexPath) { [weak self] (cell) in
                    if let textCell = cell as? FYTextMessageCell {
                        self?.configureCellModel(cell: textCell, at: indexPath)
                    }
                }
            }else {
                return plainTabView.fd_heightForCell(withIdentifier: kImageMessageCellIdentifier, cacheBy: indexPath) { [weak self] (cell) in
                    if let msgCell = cell as? FYImageMessageCell {
                        self?.configureCellModel(cell: msgCell, at: indexPath)
                    }
                }
            }
        }
        
        return 0.01
    }
    
    
    func configureCellModel(cell: UITableViewCell, at indexPath: IndexPath) {
        if let textCell = cell as? FYTextMessageCell {
            textCell.model = self.dataSource[safe: indexPath.row]
        }else if let imageCell = cell as? FYImageMessageCell {
            imageCell.model = self.dataSource[safe: indexPath.row]
        }
    }
}

// MARK: - FYMessageBaseCellDelegate

extension FYChatBaseViewController: FYMessageBaseCellDelegate {
    
    func cell(_ cell: FYMessageBaseCell, didMenu style: MenuShowStyle, model: FYMessageItem) {
        if style == .delete {
            if let row = plainTabView.indexPath(for: cell)?.item {
                dataSource.remove(at: row)
                if let messageId = model.messageId {
                    FYDBQueryHelper.shared.deleteFromMessageId(messageId)
                }
                
                loadCacheData()
                // 通知刷新会话列表
                NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
            }
        }else if style == .copy {
            
            model.message?.stringGeneral()
        }
    }
}

// MARK: - UITableViewDelegate

extension FYChatBaseViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            if model.msgType == 2 {
                if let images = loadAllChatImages(row: indexPath.row) {
                    browserImage(images, index: indexPath.row)
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isSended {
            isSended = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isSended {
            return
        }
        
        if plainTabView.y <= 0 && isBecome {
            NotificationCenter.default.post(name: .kChatTextKeyboardNeedHide, object: nil)
        }
    }
    
    func loadAllChatImages(row: Int) -> [SKPhoto]? {
        var images: [SKPhoto] = []
        guard dataSource.count > 0 else {
            return images
        }
        
        var imageIndex = 0
        for (index, model) in dataSource.enumerated() {
            if model.msgType == 2 {
                let photo = SKPhoto.photoWithImageURL(model.image!)
                photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
                images.append(photo)
                
                imageIndex += 1
            }
            
            imageIndexs[index] = imageIndex
        }
        
        return images
    }
}


// MARK: - SKPhotoBrowser

extension FYChatBaseViewController {
    
    func browserImage(_ images: [SKPhoto], index: Int) {
        if let imageIndex = imageIndexs[index] {
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(imageIndex - 1)
            present(browser, animated: true, completion: {})
        }
    }
}

