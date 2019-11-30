//
//  ChatKeyboardView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/14.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ChatKeyboardViewDelegate: class {
    /// 输入完消息
    func keyboard(_ keyboard: ChatKeyboardView, DidFinish content: String)
    /// 键盘收起/弹出
    func keyboard(_ keyboard: ChatKeyboardView, DidBecome isBecome: Bool)
    /// 键盘的y值
    func keyboard(_ keyboard: ChatKeyboardView, DidObserver offsetY: CGFloat)
    /// 菜单栏点击
    func keyboard(_ keyboard: ChatKeyboardView, DidMoreMenu type: ChatMoreMenuType)
}

extension ChatKeyboardViewDelegate {
    func keyboard(_ keyboard: ChatKeyboardView, DidFinish content: String) {}
    func keyboard(_ keyboard: ChatKeyboardView, DidBecome isBecome: Bool) {}
    func keyboard(_ keyboard: ChatKeyboardView, DidObserver offsetY: CGFloat) {}
    func keyboard(_ keyboard: ChatKeyboardView, DidMoreMenu type: ChatMoreMenuType) {}
}

class ChatKeyboardView: UIView {
    
    private let kSpace: CGFloat = 8.0
    private let kViewWH: CGFloat = 36.0
    private let kLineHeight: CGFloat = 0.75
    
    // MARK: - var lazy
        
    weak var delegate: ChatKeyboardViewDelegate?
    
    fileprivate var toolBarHeight: CGFloat = 52.0
    fileprivate var lastTextHeight: CGFloat = 34.0
    fileprivate var keyboardHeight: CGFloat = 0.0
    
    /// 底部菜单容器高度
    fileprivate var contentHeight: CGFloat = 0.0
    
    fileprivate var isShowEmoji = false
    fileprivate var isShowMore = false
    
    /// 是否弹出了系统键盘
    fileprivate var isShowKeyboard = false
    
    
    /// 表情&键盘按钮
    fileprivate lazy var emojiButton : UIButton = {
        let button = UIButton(type: .custom)
        let x: CGFloat = kScreenW - self.kViewWH * 2 - self.kSpace * 2
        button.frame = CGRect(x: x, y: self.kSpace, width: self.kViewWH, height: self.kViewWH)
        button.setImage(UIImage(named: "ToolViewEmotion"), for: .normal)
        button.setImage(UIImage(named: "ToolViewEmotionHL"), for: .highlighted)
        button.setImage(UIImage(named: "ToolViewKeyboard"), for: .selected)
        button.isSelected = false
        button.addTarget(self, action: #selector(emojiDidAction(_:)), for: .touchUpInside)
        return button
    }()
    
    
    /// 更多按钮
    fileprivate lazy var moreButton : UIButton = {
        let button = UIButton(type: .custom)
        let x: CGFloat = kScreenW - self.kViewWH - self.kSpace
        button.frame = CGRect(x: x, y: self.kSpace, width: self.kViewWH, height: self.kViewWH)
        button.setImage(UIImage(named: "TypeSelectorBtn_Black"), for: .normal)
        button.setImage(UIImage(named: "TypeSelectorBtnHL_Black"), for: .highlighted)
        button.addTarget(self, action: #selector(moreDidAction(_:)), for: .touchUpInside)
        return button
    }()
    
    /// 文本输入框
    fileprivate lazy var chatTextView: ChatGrowingTextView = {
        let w: CGFloat = kScreenW - self.kViewWH * 2 - self.kSpace * 3 - self.kSpace
        let textView = ChatGrowingTextView(frame: CGRect(x: self.kSpace, y: self.kSpace, width: w, height: self.kViewWH))
        textView.placeholder = "请输入..."
        textView.maxNumberOfLines = 5
        textView.delegate = self
        textView.didTextChangedHeightClosure = { [weak self] height in
            self?.changeKeyboardHeight(height: height)
        }
        return textView
    }()
    
    fileprivate lazy var topLineView: UIView = {
        let lineView1 = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kLineHeight))
        lineView1.backgroundColor = .kLineColor
        return lineView1
    }()
    
    fileprivate lazy var bottomLineView: UIView = {
        let lineView2 = UIView(frame: CGRect(x: 0, y: self.toolBarHeight - kLineHeight, width: kScreenW, height: kLineHeight))
        lineView2.backgroundColor = .kLineColor
        return lineView2
    }()
    
    fileprivate lazy var toolBarView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: self.toolBarHeight))
        view.backgroundColor = .kKeyboardColor
        return view
    }()
    
    /// 底部背景容器
    fileprivate lazy var contentView: UIView = {
        let y = self.toolBarView.maxY
        let view = UIView(frame: CGRect(x: 0, y: y, width: kScreenW, height: self.contentHeight))
        view.backgroundColor = .kContentColor
        //view.isUserInteractionEnabled = false
        return view
    }()
    
    /// 表情列表
    fileprivate lazy var emojiListView: ChatEmojiListView = {
        let view = ChatEmojiListView(frame: self.contentView.bounds)
        view.delegate = self
        view.backgroundColor = .kContentColor
        view.isHidden = true
        return view
    }()
    
    /// 更多菜单
    fileprivate lazy var moreMenuView: ChatMoreMenuView = {
        let view = ChatMoreMenuView(frame: self.contentView.bounds)
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupKeyboardView()
        registerNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupKeyboardView()
        registerNotification()
    }
    
    func setupKeyboardView() {
        self.backgroundColor = .kKeyboardColor
        self.isUserInteractionEnabled = true
        
        addSubview(toolBarView)
        toolBarView.addSubview(moreButton)
        toolBarView.addSubview(emojiButton)
        toolBarView.addSubview(chatTextView)
        toolBarView.addSubview(topLineView)
        toolBarView.addSubview(bottomLineView)
        
        addSubview(contentView)
        contentView.addSubview(moreMenuView)
        contentView.addSubview(emojiListView)
    }
    
    // MARK: - 监听键盘通知
    private func registerNotification() {
        // 监听键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name:UIResponder.keyboardWillShowNotification,object: nil)
        // 监听键盘隐藏通知
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 主要是为了获取点击空白处回收键盘的处理
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardNeedHide),
                                               name: .kChatTextKeyboardNeedHide, object: nil)
        // 添加KVO监听输入键盘y值
        addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
    }
    
    // MARK: - KVO监听
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" && ((object as? UIView) != nil) {
            if let changeObject = change.value {
                if let newFrame = changeObject[.newKey] as? CGRect {
                    delegate?.keyboard(self, DidObserver: newFrame.origin.y)
                    printLog("y值发生改变\(newFrame.origin.y)")
                }
            }
        }else {
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        
        self.removeObserver(self, forKeyPath: "frame")
    }
}

// MARK: - ChatEmojiListViewDelegate

extension ChatKeyboardView: ChatEmojiListViewDelegate {
    
    func emojiView(_ emojiView: ChatEmojiListView, DidFinish emotion: ChatEmoticon) {
        if (emotion.emojiCode?.length ?? 0 > 0) {
            chatTextView.insertText(emotion.emojiCode!)
        }else if (emotion.imgPath?.length ?? 0 > 0) {
            chatTextView.insertEmotion(emotion: emotion)
        }
    }
    
    func emojiView(_ emojiView: ChatEmojiListView, DidDelete backward: Bool) {
        chatTextView.deleteBackward()
    }
    
    func emojiView(_ emojiView: ChatEmojiListView, DidFinish isSend: Bool) {
        if (isSend && chatTextView.text.length > 0) {
            sendChatMessage()
        }
    }
}

// MARK: - ChatMoreMenuViewDelegate

extension ChatKeyboardView: ChatMoreMenuViewDelegate {
    
    func menu(_ view: ChatMoreMenuView, DidSelected type: ChatMoreMenuType) {
        
        delegate?.keyboard(self, DidMoreMenu: type)
    }
}

// MARK: - UITextViewDelegate

extension ChatKeyboardView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 发送键&回车键处理
        if (text == "\n") {
            if (isShowKeyboard) {
                isShowKeyboard = true
            }
            
            sendChatMessage()
            return false
        }
        
        return true
    }
    
    
    /// 发送消息内容
    private func sendChatMessage() {
        delegate?.keyboard(self, DidFinish: self.chatTextView.text ?? "")
        
        changeKeyboardHeight(height: lastTextHeight)
        chatTextView.clear()
    }
}


// MARK: - KeyBoard Manager

extension ChatKeyboardView {
    
    /// 键盘将要显示
    @objc func keyboardWillShow(_ noti: NSNotification) {
        guard let userInfo = noti.userInfo else {
            return
        }
        
        contentHeight = 0
        delegate?.keyboard(self, DidBecome: true)
        
        let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        let endFrame = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 获取键盘的高度
        keyboardHeight = endFrame.height
        // 键盘弹出状态
        isShowKeyboard = true
        
        let option = userInfo["UIKeyboardAnimationCurveUserInfoKey"] as! Int
        
        var changedY = y - self.toolBarHeight - kNavigaH - contentHeight
        if (isShowEmoji || isShowMore) { //显示系统键盘
            isShowMore = false
            isShowEmoji = false
            self.emojiListView.isHidden = true
            self.moreMenuView.isHidden = true
            self.moreMenuView.hidePageController = true
            self.emojiListView.hidePageController = true
            
            changedY = y - self.toolBarHeight - kNavigaH
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(option)), animations: {
            self.frame = CGRect(x: 0, y: changedY, width: kScreenW, height: self.toolBarHeight + self.contentHeight)
        }, completion: nil)
    }
    
    /// 键盘将要消失
    @objc func keyboardWillHide(_ noti: NSNotification) {
        guard let userInfo = noti.userInfo else {
            return
        }
        
        delegate?.keyboard(self, DidBecome: false)
        
        let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        let endFrame = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        //let y = endFrame.origin.y
        // 获取键盘的高度
        keyboardHeight = endFrame.height
        // 键盘弹出状态
        isShowKeyboard = false
            
        let option = userInfo["UIKeyboardAnimationCurveUserInfoKey"] as! Int
        let changedY = kScreenH - kNavigaH - self.toolBarHeight - kSafeAreaBottom - self.contentHeight
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(option)), animations: {
            self.frame = CGRect(x: 0, y: changedY, width: kScreenW, height: self.toolBarHeight + self.contentHeight)
        }, completion: nil)
        
    }
    
    @objc func keyboardNeedHide(_ noti: NSNotification) {        
//        if (isShowKeyboard || isShowEmoji) {
//            return
//        }
        
        chatTextView.resignFirstResponder()
        moreMenuView.hidePageController = true
        emojiListView.hidePageController = true
        
        contentHeight = 0.0
        restToolbarContentHeight(true)
        
        delegate?.keyboard(self, DidBecome: false)
    }
}



// MARK: - Action

extension ChatKeyboardView {
    
    /// 表情按钮点击处理
    @objc func emojiDidAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        if button.isSelected {
            if !isShowEmoji {
                isShowEmoji = true
                if isShowMore {
                    isShowMore = false
                    moreMenuView.isHidden = true
                    moreMenuView.hidePageController = true
                }
            }
            
            showEmojiView()
            
        }else {
            if (isShowKeyboard) {
                button.isSelected = true
                showEmojiView()
                return
            }
            
            isShowEmoji = false
            contentHeight = 0.0
            contentView.isHidden = true
            
            moreMenuView.hidePageController = true
            emojiListView.isHidden = true
            chatTextView.becomeFirstResponder()
        }
        
    }
    
    func showEmojiView() {
        contentHeight = 250
        contentView.isHidden = false
        emojiListView.isHidden = false
        chatTextView.resignFirstResponder()
        
        restToolbarContentHeight()
        emojiListView.reloadData()
        
        delegate?.keyboard(self, DidBecome: true)
    }
    
    /// 更多按钮点击处理
    @objc func moreDidAction(_ button: UIButton) {
        // 如有弹出菜单
        if isShowMore {
            return
        }
        
        isShowMore = true
        contentHeight = 250
        contentView.isHidden = false
        moreMenuView.isHidden = false
        emojiListView.isHidden = true
        chatTextView.resignFirstResponder()
        
        restToolbarContentHeight()
        moreMenuView.reloadData()
        
        delegate?.keyboard(self, DidBecome: true)
    }
    
    /// 更改容器高度
    func restToolbarContentHeight(_ isRest: Bool = false) {
        var changedY = kScreenH - self.toolBarHeight - kNavigaH - contentHeight
        if (isRest) {
            if isShowEmoji {
                isShowEmoji = false
            }else if (isShowMore) {
                isShowMore = false
            }
            
            changedY = kScreenH - self.toolBarHeight - kNavigaH - contentHeight - kSafeAreaBottom
        }
        
        //let option = UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(7))
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.frame = CGRect(x: 0, y: self.toolBarView.maxY, width: kScreenW, height: self.contentHeight)
            self.emojiListView.frame = self.contentView.bounds
            self.moreMenuView.frame = self.contentView.bounds
            self.frame = CGRect(x: 0, y: changedY, width: kScreenW, height: self.toolBarHeight + self.contentHeight)
        }, completion: nil)
        
        self.layoutIfNeeded()
    }
    
}

// MARK: - 改变输入框高度位置

extension ChatKeyboardView {
    
    func changeKeyboardHeight(_ isClear: Bool = false, height: CGFloat) {
        let textHeight = height
        
        toolBarHeight = textHeight + kSpace * 2
        toolBarView.frame = CGRect(x: toolBarView.x, y: 0, width: toolBarView.width, height: toolBarHeight)
        
        let spaceY = toolBarView.height - kSpace - kViewWH
        chatTextView.frame = CGRect(x: chatTextView.x, y: chatTextView.x, width: chatTextView.width, height: textHeight)
        moreButton.frame = CGRect(x: moreButton.x, y: spaceY, width: moreButton.width, height: moreButton.height)
        emojiButton.frame = CGRect(x: emojiButton.x, y: spaceY, width: emojiButton.width, height: emojiButton.height)
        
        contentView.frame = CGRect(x: contentView.x, y: toolBarView.maxY, width: contentView.width, height: contentHeight)
        
        topLineView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kLineHeight)
        bottomLineView.frame = CGRect(x: 0, y: toolBarView.height - kLineHeight, width: kScreenW, height: kLineHeight)
        
        
        if (isShowKeyboard) {
            if isShowEmoji {
                isShowEmoji = false
            }else if (isShowMore) {
                isShowMore = false
            }
            
            let changedY = kScreenH - keyboardHeight - toolBarHeight - kNavigaH
            self.frame = CGRect(x: 0, y: changedY, width: kScreenW, height: toolBarView.height + contentView.height)
        }else {
            let changedY = kScreenH - kNavigaH - (toolBarView.height + contentView.height)
            self.frame = CGRect(x: 0, y: changedY, width: kScreenW, height: toolBarView.height + contentView.height)
        }
        
        self.setNeedsLayout()
        //printLog("ToolBarHeight === \(toolBarView.height)")
        printLog("self y === \(self.frame.origin.y)")
    }
}


