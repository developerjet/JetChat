//
//  ChatGrowingTextView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/14.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class ChatGrowingTextView: UITextView {
    /// 行数部分间距调整
    fileprivate let kEdgeInset: CGFloat = 12
    /// 内容字体默认大小
    fileprivate let kDefultSize: CGFloat = 15.0
    
    // MARK: - var lazy
    
    /// 默认3行的高度
    fileprivate var maxTextViewHeight: CGFloat = 80
    
    var placeholder: String? = "" {
        didSet {
            self.placeholderLabel.text = placeholder
        }
    }
    
    var placeholderColor: UIColor? = .black {
        didSet {
            self.placeholderLabel.textColor = placeholderColor
        }
    }
    
    var maxNumberOfLines: Int = 3 {
        didSet {
            let numberOfLines = CGFloat(maxNumberOfLines)
            maxTextViewHeight = CGFloat(ceilf(Float(self.font!.lineHeight * numberOfLines + self.textContainerInset.top + self.textContainerInset.bottom))) - kEdgeInset
        }
    }
    
    
    
    /// 输入框高度监听回调
    var didTextChangedHeightClosure : ((CGFloat)->Void)?
    
    /// 占位标签
    fileprivate lazy var placeholderLabel: UILabel = {
        let frame = CGRect(x: 5, y: 7, width: kScreenW - 10, height: 21)
        let label = UILabel(frame: frame)
        label.numberOfLines = 1
        label.text = "请输入你要发送的消息"
        label.textColor = .kPlaceholderColor
        label.font = UIFont.systemFont(ofSize: self.kDefultSize)
        return label
    }()
    
    // MARK: - life cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.isScrollEnabled = false
        self.scrollsToTop = false
        //self.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        self.showsHorizontalScrollIndicator = false
        self.enablesReturnKeyAutomatically = true
        self.font = UIFont.systemFont(ofSize: kDefultSize)
        self.returnKeyType = .send
        
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.kLineColor.cgColor
        self.layer.masksToBounds = true
        // 添加占位控件
        addSubview(self.placeholderLabel)
        
        // register
        registerChangeNotification()
    }
    
    fileprivate func registerChangeNotification() {
        // 实时监听输入值的改变
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChanged),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
        
        self.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
    }
    
    // MARK: - KVO监听
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "attributedText" {
            textDidChanged()
        }else {
            
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "attributedText")
    }
       
}

// MARK: - Action

extension ChatGrowingTextView {
    
    @objc func textDidChanged() {
        placeholderLabel.isHidden = self.hasText
        
        // 计算高度
        let constrainSize = CGSize(width: self.frame.size.width, height: CGFloat(MAXFLOAT))
        var size = self.sizeThatFits(constrainSize)
        
        if size.height >= maxTextViewHeight {
            self.isScrollEnabled = true
            size.height = maxTextViewHeight
        }else {
            self.isScrollEnabled = false
            if (didTextChangedHeightClosure != nil && !self.isScrollEnabled) {
                didTextChangedHeightClosure?(size.height)
            }
        }
        
        let nowFrame = self.frame
        frame.size.height = size.height
        self.frame = nowFrame
        
        self.layoutIfNeeded()
        
        sendChangedNoti()
    }
    
    func sendChangedNoti() {
        
        NotificationCenter.default.post(name: .kChatTextKeyboardChanged, object: self.text, userInfo: nil)
    }
}
