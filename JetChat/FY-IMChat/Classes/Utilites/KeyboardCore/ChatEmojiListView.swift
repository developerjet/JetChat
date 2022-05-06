//
//  ChatEmojiListView.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/14.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit


/// 行数
fileprivate let kRowNumber = 3
/// 列数
fileprivate let kColumnNumber = 8

fileprivate let kEmotionCellNumberOfOnePage = kRowNumber * kColumnNumber

protocol ChatEmojiListViewDelegate {
    /// 获取的表情
    func emojiView(_ emojiView: ChatEmojiListView, DidFinish emotion: ChatEmoticon)
    /// 发送内容
    func emojiView(_ emojiView: ChatEmojiListView, DidFinish isSend: Bool)
    /// 删除上一步内容
    func emojiView(_ emojiView: ChatEmojiListView, DidDelete backward: Bool)
}

extension ChatEmojiListViewDelegate {
    func emojiView(_ emojiView: ChatEmojiListView, DidFinish emoji: String) {}
    func emojiView(_ emojiView: ChatEmojiListView, DidFinish isSend: Bool) {}
    func emojiView(_ emojiView: ChatEmojiListView, DidDelete backward: Bool) {}
}

class ChatEmojiListView: UIView {
    
    private var selectedIndex: Int = 0
    private let kBottomMargin: CGFloat = 8
    private let kBottomHeight: CGFloat = 44
    
    // MARK: - lazy var
    
    var selectedType: Int = 0
    
    /// 设置代理
    var delegate: ChatEmojiListViewDelegate?
    
    /// 隐藏分页指示器
    var hidePageController: Bool = false {
        didSet {
            self.sendButton.alpha = self.hidePageController ? 0.0 : 1.0
            self.pageControl.alpha = self.hidePageController ? 0.0 : 1.0
            self.bottomView.alpha = self.hidePageController ? 0.0 : 1.0
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.sendButton.isHidden = self.hidePageController
                self.pageControl.isHidden = self.hidePageController
                self.bottomView.isHidden = self.hidePageController
            }, completion: nil)
            
            scrollToLeft()
        }
    }
        
    var pageIndicatorTintColor: UIColor? {
        didSet {
            guard pageIndicatorTintColor != nil else {
                return
            }
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    var currentPageIndicatorTintColor: UIColor? {
        didSet {
            guard currentPageIndicatorTintColor != nil else {
                return
            }
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    
    lazy var emojiButtons: [UIButton] = {
        let buttons = [self.appleEmojiBtn, self.weChatEmojiBtn]
        return buttons
    }()
    
    lazy var dataSource: [ChatEmoticon] = {
        return ChatEmotionHelper.getAppleAllEmotions()
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = ChatKeyboardFlowLayout(column: kColumnNumber, row: kRowNumber)
        // collectionView
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V14 }
        collection.register(cellWithClass: ChatAppleEmojiCell.self)
        collection.showsHorizontalScrollIndicator = true
        collection.showsVerticalScrollIndicator = true
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        return collection
    }()
    
    lazy var pageControl: UIPageControl = {
        let pager = UIPageControl()
        pager.backgroundColor = .clear
        pager.theme.pageIndicatorTintColor = themed { $0.FYColor_BorderColor_V1 }
        pager.theme.currentPageIndicatorTintColor = themed { $0.FYColor_Main_TextColor_V3 }
        pager.currentPage = 0
        pager.numberOfPages = self.dataSource.count / kEmotionCellNumberOfOnePage + (self.dataSource.count % kEmotionCellNumberOfOnePage == 0 ? 0 : 1)
        pager.isHidden = true
        return pager
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发送".rLocalized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.theme.titleColor(from: themed{ $0.FYColor_Main_TextColor_V12 }, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V13 }
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendContent), for: .touchUpInside)
        return button
    }()
    
    lazy var bottomView: UIView = {
        let toolBar = UIView()
        toolBar.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V14 }
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    lazy var appleEmojiBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("😊", for: .normal)
        button.addTarget(self, action: #selector(emojiAction), for: .touchUpInside)
        button.backgroundColor = .clear
        button.tag = 1000
        return button
    }()
    
    lazy var weChatEmojiBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_emoji_expression"), for: .normal)
        button.addTarget(self, action: #selector(emojiAction), for: .touchUpInside)
        button.backgroundColor = .clear
        button.tag = 1001
        return button
    }()
    
    lazy var emojiSelectView: UIView = {
        let v = UIView()
        v.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V15 }
        return v
    }()
    
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           
        makeUI()
        reloadData()
        registerNotification()
    }
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        makeUI()
        reloadData()
        registerNotification()
    }
    
    func makeUI() {
        theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V14 }
        
        bottomView.addSubview(emojiSelectView)
        bottomView.addSubview(appleEmojiBtn)
        bottomView.addSubview(weChatEmojiBtn)
        bottomView.addSubview(sendButton)
        
        addSubview(bottomView)
        bringSubviewToFront(bottomView)
        addSubview(pageControl)
        addSubview(collectionView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeAreaBottom)
            make.height.equalTo(kBottomHeight)
        }
        
        emojiSelectView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        appleEmojiBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(emojiSelectView)
        }
        
        weChatEmojiBtn.snp.makeConstraints { (make) in
            make.left.equalTo(appleEmojiBtn.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(emojiSelectView)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }
    }
    
    func registerNotification() {
        // 实时监听输入值的改变
        NotificationCenter.default.addObserver(self, selector: #selector(contentDidChanged(_:)), name: .kChatTextKeyboardChanged, object: nil)
    }
    
    open func reloadData() {
        self.needsUpdateConstraints()
        self.layoutIfNeeded()
        
        self.sendButton.alpha = 1.0
        self.pageControl.alpha = 1.0
        self.bottomView.alpha = 1.0
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.sendButton.isHidden = false
            self.pageControl.isHidden = false
            self.bottomView.isHidden = false
        }, completion: nil)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToLeft()
        }
    }
    
    /// 发送
    @objc func sendContent() {
        
        delegate?.emojiView(self, DidFinish: true)
    }
    
    @objc func emojiAction(_ button: UIButton) {
        if self.selectedIndex == button.tag - 1000 {
            return;
        }
        
        switch button.tag {
        case 1000:
            dataSource = ChatEmotionHelper.getAppleAllEmotions()
            break
        default:
            dataSource = ChatEmotionHelper.getWeChatAllEmotions()
            break
        }
        
        selectedIndex = button.tag - 1000
        emojiSelection(index: selectedIndex)
        
        reloadData()
    }
    
    // MARK: - Action
    
    @objc
    func emojiSelection(index: Int) {
        // 选择emoji类型
        UIView.animate(withDuration: 0.25) {
            self.emojiSelectView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(70 * index)
            }
        }
        
        emojiSelectView.superview?.layoutIfNeeded()
    }
    
    @objc
    func scrollToLeft(_ animated: Bool = false) {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: animated)
    }
}

// MARK: - Notification

extension ChatEmojiListView {
    
    @objc func contentDidChanged(_ noti: Notification) {
        if (noti.object == nil) {
            return
        }
        
        if let insertText = noti.object as? String {
            printLog("String -- \(insertText)")
            sendButton.isEnabled = insertText.length > 0
        }
        
        if let insertAttrs = noti.object as? NSAttributedString {
            printLog("NSAttributedString -- \(insertAttrs)")
            sendButton.isEnabled = insertAttrs.length > 0
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ChatEmojiListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ChatAppleEmojiCell.self, for: indexPath)
        if let model = dataSource[safe: indexPath.row] {
            cell.model = model
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension ChatEmojiListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            if let emojiModel = dataSource[safe: indexPath.row] {
                if emojiModel.isDelete {
                    delegate?.emojiView(self, DidDelete: true)
                }else {
                    if (emojiModel.isSpace) {
                        return
                    }
                    
                    delegate?.emojiView(self, DidFinish: emojiModel)
                }
            }
        }
    }
}

extension ChatEmojiListView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let offsetX = scrollView.contentOffset.x
            let index = offsetX / kScreenW
            pageControl.currentPage = Int(index)
        }
    }
}
