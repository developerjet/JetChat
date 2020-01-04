//
//  FYChatBaseViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/13.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import YBImageBrowser
import RxSwift


public enum ChatType: Int {
    case singleChat  = 1
    case groupedChat = 2
}

private let kTextMessageCellIdentifier  = "kTextMessageCellIdentifier"
private let kImageMessageCellIdentifier = "kImageMessageCellIdentifier"
private let kVideoMessageCellIdentifier = "kVideoMessageCellIdentifier"

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
    var chatModel: FYMessageChatModel? = FYMessageChatModel()
    
    /// 消息转发
    var isForward: Bool = false
    var forwardData: FYMessageItem?
    
    var timer: Timer?
    var viewModel: FYMessageViewModel?
    
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
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 禁止侧滑返回手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        // stop timer
        stopChatTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGroundGrayColor()
        setupNavBar()
        
        makeUI()
        loadCacheData()
        bindViewModel()
    }
    
    /// 构造聊天会话
    /// - Parameter chatModel: 聊天实体（分单聊、群聊）
    /// - Parameter isForward: 是否转发消息
    convenience init(chatModel: FYMessageChatModel, isForward: Bool = false) {
        self.init()
        
        self.chatModel = chatModel
        self.isForward = isForward
        self.viewModel = FYMessageViewModel(chatModel: chatModel)
    }
    
    func setupNavBar() {
        if chatModel?.nickName.isBlank == false {
            navigationItem.title = chatModel?.nickName
        }else {
            navigationItem.title = chatModel?.name
        }
        
        if chatModel?.chatType == 2 {
            let rightBarButtonItem = UIBarButtonItem(title: "退出群", style: .plain, target: self, action: #selector(exitGroupChat))
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    override func makeUI() {
        super.makeUI()
        
        let height = kScreenH - (kToolBarLastH + kSafeAreaBottom + kNavigaH)
        plainTabView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: height)
        plainTabView.dataSource = self
        plainTabView.delegate = self
        plainTabView.separatorStyle = .none
        plainTabView.estimatedRowHeight = 100
        plainTabView.tableFooterView = UIView()
        plainTabView.showsVerticalScrollIndicator = true
        registerChatCell()
        view.addSubview(plainTabView)
        // 添加聊天键盘
        view.addSubview(keyboardView)
        
        viewModel?.tableView = plainTabView
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let refresh = Observable.of(Observable.never(), loadingTrigger).merge()
        let input = FYMessageViewModel.Input(makeMessage: refresh, makeBrowser: refresh)
        let output = viewModel?.transform(input: input)
        // message
        output?.message.asDriver(onErrorJustReturn: FYMessageItem())
            .drive(onNext: { [weak self] (msgItem) in
                guard let self = self else { return }
                guard msgItem.msgType != nil else {
                    return
                }
                self.reloadChatData(msgItem)
            }).disposed(by: rx.disposeBag)
        // browser
        output?.browser.asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (objects) in
                guard let self = self else { return }
                guard objects.count > 0 else {
                    return
                }
                self.browserWithData(objects, index: (self.viewModel?.imageIndex.value)!)
        }).disposed(by: rx.disposeBag)
        
        // forward
        if isForward {
            if let messageItem = forwardData {
                reloadChatData(messageItem)
            }
        }
    }
    
    private func startChatTimer() {
        if chatModel?.chatType == 2 && isTimered == false {
            timer = Timer(timeInterval: 10, target: self, selector: #selector(makeGroupAutoSend), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
            timer?.fire() // 启动定时器
            
            isTimered = true
        }
    }
    
    private func stopChatTimer() {
        if isTimered {
            timer?.invalidate()
        }
    }
    
    private func registerChatCell() {
        plainTabView.register(FYTextMessageCell.self, forCellReuseIdentifier: kTextMessageCellIdentifier)
        plainTabView.register(FYImageMessageCell.self, forCellReuseIdentifier: kImageMessageCellIdentifier)
        plainTabView.register(FYVideoMessageCell.self, forCellReuseIdentifier: kVideoMessageCellIdentifier)
    }
    
    /// 滚到底部
    private func scrollToBottom(_ animated: Bool = true) {
        
        plainTabView.scrollToLast(at: .bottom, animated: animated)
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
                self.stopChatTimer()
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
        stopChatTimer()
    }
}


// MARK: - ChatKeyboardViewDelegate

extension FYChatBaseViewController: ChatKeyboardViewDelegate {
    
    func keyboard(_ keyboard: ChatKeyboardView, DidFinish content: String) {
        
        makeChatMessage(.text, content: content)
    }
    
    func keyboard(_ keyboard: ChatKeyboardView, DidBecome isBecome: Bool) {
        self.isSended = true
        self.isBecome = isBecome
    }
    
    func keyboard(_ keyboard: ChatKeyboardView, DidMoreMenu type: ChatMoreMenuType) {
        
        openImagePicker(type)
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
    
    private func makeChatMessage(_ type: ChatDataType, content: String = "") {
        viewModel?.browserType.accept(.none)
        viewModel?.messageType.accept(type)
        if type == .text {
            viewModel?.content.accept(content)
        }
        loadingTrigger.onNext(())
        
        startChatTimer()
    }
    
    /// 模拟群组聊天自动发送消息
    @objc private func makeGroupAutoSend() {
        viewModel?.browserType.accept(.none)
        viewModel?.messageType.accept(.autoSend)
        loadingTrigger.onNext(())
    }
    
    private func reloadChatData(_ msgItem: FYMessageItem) {
        isSended = true
        dataSource.append(msgItem)
        viewModel?.dataSource.accept(dataSource)
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
    
    private func openImagePicker(_ type: ChatMoreMenuType) {
        let imagePicker = TZImagePickerController(maxImagesCount: 1, columnNumber: 5, delegate: self)
        imagePicker?.didFinishPickingPhotosHandle = {(images: [UIImage]?, assets:[Any]?, isSelectOriginalPhoto: Bool) in
            printLog(images)
            if (type == .album) {
                self.makeChatMessage(.image)
            }else if (type == .video) {
                self.makeChatMessage(.video)
            }
        }
        
        if (type == .album || type == .video) {
            present(imagePicker!, animated: true, completion: nil)
        }
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
    
    
    func loadCacheData(_ toBottom: Bool = true) {
        if let chatId = chatModel?.uid {
            dataSource = FYDBQueryHelper.shared.qureyFromMessagesWithChatId(chatId)
            viewModel?.dataSource.accept(dataSource)
        }
        
        plainTabView.reloadData()
        if (toBottom) {
            scrollToBottom(toBottom)
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
            }else if model.msgType == 2 {
                let imageCell = tableView.dequeueReusableCell(withIdentifier: kImageMessageCellIdentifier) as! FYImageMessageCell
                configureCellModel(cell: imageCell, at: indexPath)
                imageCell.delegate = self
                return imageCell
            }else if model.msgType == 3 {
                let videoCell = tableView.dequeueReusableCell(withIdentifier: kVideoMessageCellIdentifier) as! FYVideoMessageCell
                configureCellModel(cell: videoCell, at: indexPath)
                videoCell.delegate = self
                return videoCell
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
            }else if model.msgType == 2 {
                return plainTabView.fd_heightForCell(withIdentifier: kImageMessageCellIdentifier, cacheBy: indexPath) { [weak self] (cell) in
                    if let imageCell = cell as? FYImageMessageCell {
                        self?.configureCellModel(cell: imageCell, at: indexPath)
                    }
                }
            }else if model.msgType == 3 {
                return plainTabView.fd_heightForCell(withIdentifier: kVideoMessageCellIdentifier, cacheBy: indexPath) { [weak self] (cell) in
                    if let videoCell = cell as? FYVideoMessageCell {
                        self?.configureCellModel(cell: videoCell, at: indexPath)
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
        }else if let viodeCell = cell as? FYVideoMessageCell {
            viodeCell.model = self.dataSource[safe: indexPath.row]
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
                
                loadCacheData(false)
                // 通知刷新会话列表
                NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
            }
        }else if style == .copy {
            if let message = model.message, message.length > 0 {
                message.stringGeneral()
            }
        }else if (style == .shore) {
            
            messageForward(model)
        }
    }
    
    func cell(_ cell: FYMessageBaseCell, didTapAvatarAt model: FYMessageItem) {
        if model.sendType == 0 {
            return
        }
        
        let userModel = FYDBQueryHelper.shared.qureyFromChatId(model.chatId!)
        let infoVC = FYContactsInfoViewController()
        infoVC.chatModel = userModel
        navigationController?.pushViewController(infoVC)
    }
    
    func cell(_ cell: FYMessageBaseCell, didTapPictureAt model: FYMessageItem) {
        if let row = plainTabView.indexPath(for: cell)?.item {
            if model.msgType == 2 {
                viewModel?.messageType.accept(.none)
                viewModel?.imageIndex.accept(row)
                viewModel?.browserType.accept(.image)
                loadingTrigger.onNext(())
            }
        }
    }
    
    func cell(_ cell: FYMessageBaseCell, didTapVideoAt model: FYMessageItem) {
        if let row = plainTabView.indexPath(for: cell)?.item {
            if model.msgType == 3 {
                viewModel?.messageType.accept(.none)
                viewModel?.imageIndex.accept(row)
                viewModel?.browserType.accept(.video)
                loadingTrigger.onNext(())
            }
        }
    }
    
    /// 消息转发
    private func messageForward(_ message: FYMessageItem) {
        if let chatType = message.chatType {
            let forwardVC = FYMessageForwardViewController()
            if chatType == 1 {
                forwardVC.forwardStyle = .friend
            }else {
                forwardVC.forwardStyle = .grouped
            }
            forwardVC.messageItem = message
            self.navigationController?.pushViewController(forwardVC)
        }
    }
}

// MARK: - UITableViewDelegate

extension FYChatBaseViewController: UITableViewDelegate, UIScrollViewDelegate {
    
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
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .kChatTextKeyboardNeedHide, object: nil)
            }
        }
    }
}


// MARK: - Image && Video Browser

extension FYChatBaseViewController {
    
    func browserWithData(_ dataSource: [AnyObject]?, index: Int = 0) {
        var browserIndex = 0
        let browser = YBImageBrowser()
        if let imageData = dataSource as? [YBIBImageData] {
            browserIndex = (viewModel?.browserIndexs.value[index] ?? index)
            browser.dataSourceArray = imageData
        }else if let videoData = dataSource as? [YBIBVideoData] {
            browserIndex = (viewModel?.browserIndexs.value[index] ?? index)
            browser.dataSourceArray = videoData
        }
        browser.currentPage = browserIndex - 1
        browser.show()
    }
}

