//
//  ChatEmojiListView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/14.
//  Copyright © 2019 MacOsx. All rights reserved.
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
    
    private let kBottomMargin: CGFloat = 8
    private let kBottomHeight: CGFloat = 44
    
    // MARK: - lazy var
    
    var selectedType: Int = 0
    var selectedBtn: UIButton!
    
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
    
    lazy var selectedImage: UIImage = {
        let image = UIImage.imageWithColor(.kKeyboardColor)
        return image
    }()
    
    lazy var unSelectImage: UIImage = {
        let image = UIImage.imageWithColor(.white)
        return image
    }()
    
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
        collection.backgroundColor = .kContentColor
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
        pager.pageIndicatorTintColor = UIColor.lightGray
        pager.currentPageIndicatorTintColor = UIColor.gray
        pager.currentPage = 0
        pager.numberOfPages = self.dataSource.count / kEmotionCellNumberOfOnePage + (self.dataSource.count % kEmotionCellNumberOfOnePage == 0 ? 0 : 1)
        pager.isHidden = true
        return pager
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.kSendColor, for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.backgroundColor = .kKeyboardColor
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendContent), for: .touchUpInside)
        return button
    }()
    
    lazy var bottomView: UIView = {
        let toolBar = UIView()
        toolBar.backgroundColor = .white
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    lazy var appleEmojiBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("😊", for: .normal)
        button.setBackgroundImage(selectedImage, for: .selected)
        button.setBackgroundImage(unSelectImage, for: .normal)
        button.addTarget(self, action: #selector(emojiAction), for: .touchUpInside)
        button.isSelected = true
        button.tag = 1000
        return button
    }()
    
    lazy var weChatEmojiBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_emoji_expression"), for: .normal)
        button.setBackgroundImage(selectedImage, for: .selected)
        button.setBackgroundImage(unSelectImage, for: .normal)
        button.addTarget(self, action: #selector(emojiAction), for: .touchUpInside)
        button.tag = 1001
        return button
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
        backgroundColor = .kContentColor
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
        
        appleEmojiBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        weChatEmojiBtn.snp.makeConstraints { (make) in
            make.left.equalTo(appleEmojiBtn.snp_right)
            make.height.equalToSuperview()
            make.width.equalTo(appleEmojiBtn)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(bottomView.snp_top)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp_top)
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
        switch button.tag {
        case 1000:
            appleEmojiBtn.isSelected = true
            weChatEmojiBtn.isSelected = false
            dataSource = ChatEmotionHelper.getAppleAllEmotions()
            selectedBtn = appleEmojiBtn
            break
        default:
            weChatEmojiBtn.isSelected = true
            appleEmojiBtn.isSelected = false
            dataSource = ChatEmotionHelper.getWeChatAllEmotions()
            selectedBtn = weChatEmojiBtn
            break
        }
        
        reloadData()
    }
    
    @objc func scrollToLeft(_ animated: Bool = false) {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: animated)
    }
}

// MARK: - Notification

extension ChatEmojiListView {
    
    @objc func contentDidChanged(_ noti: Notification) {
        guard let object = noti.object as? String else {
            return
        }
        
        printLog("object -- \(object)")
        sendButton.isEnabled = object.length > 0
    }
}

// MARK:- UICollectionViewDataSource

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
