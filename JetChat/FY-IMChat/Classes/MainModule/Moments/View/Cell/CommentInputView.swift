//
//  CommentInputView.swift
//  JetChat
//
//  Created by Jett on 2020/5/12.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation

protocol CommentInputViewDelegate: NSObjectProtocol {
    /// 容器高度变化通知
    func onTopChanged(_ top: CGFloat) -> Void
    /// 输入文本
    func onTextChanged(_ text: String) -> Void
    /// 点击发送
    func onSend(_ text: String) -> Void
}
class CommentInputView: UIView {
    fileprivate(set) lazy var contentView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: contentMinHeight)
        v.backgroundColor = .groupTableViewBackground
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 0.5)
        v.layer.addSublayer(layer)
        return v
    }()
    /// 容器的最小高度
    fileprivate let contentMinHeight: CGFloat = 50
    /// 容器最大高度
    fileprivate let contentMaxHeight: CGFloat = 120
    /// 容器减去输入框的高度
    fileprivate let surplusHeight: CGFloat = 15
    /// // 记录上一次容器高度
    fileprivate var previousCtHeight: CGFloat = 0
    /// 记录容器高度
    fileprivate var ctHeight: CGFloat = 0
    fileprivate(set) var keyboardHeight: CGFloat = 0
    /// 容器高度
    fileprivate(set) var ctTop: CGFloat = 0 {
        didSet {
            delegate?.onTopChanged(ctTop)
        }
    }
    weak var delegate: CommentInputViewDelegate?
    
    fileprivate(set) lazy var textView: FYTextView = {
        let v = FYTextView()
        v.backgroundColor = .white
        v.textColor = mBlackColor
        v.placeholder = "评论".rLocalized()
        v.lineBreak = false
        v.returnKeyType = .send
        v.enablesReturnKeyAutomatically = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        v.font = UIFont.systemFont(ofSize: 16)
        v.frame = CGRect(x: 15, y: surplusHeight/2, width: kScreenW-30, height: contentMinHeight-surplusHeight)
        return v
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        textView.becomeFirstResponder()
    }
    
    func dismiss() {
        textView.resignFirstResponder()
        removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentPoint = touches.first?.location(in: superview) else {
            return
        }
        if !contentView.frame.contains(currentPoint) {
            dismiss()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 滚动collectionview
    func scrollForComment(_ rect: CGRect) {
        if keyboardHeight > 0 {
            let offset = rect.maxY - ctTop
            NotificationCenter.default.post(name: NSNotification.Name.list.contentOffset, object: offset)
        }
    }
}


fileprivate extension CommentInputView {
    
    func setup() {
        addSubview(contentView)
        contentView.addSubview(textView)
        
        textView.onKeyAction = {[weak self] action in
            guard let `self` = self else {
                return
            }
            
            switch action {
            case .keyboard(let rect, let duration):
                self.updateTop(rect: rect, duration: duration)
            case .change(_):
                self.updateHeight(self.textView.autoHeight)
                self.delegate?.onTextChanged(self.textView.text)
            case .done:
                self.dismiss()
                self.delegate?.onSend(self.textView.text)
            default:
                break
            }
        }
    }
    

    func updateTop(rect: CGRect, duration: Double) {
        var keyboardH: CGFloat = 0
        if rect.origin.y == UIScreen.main.bounds.height {
            keyboardH = 0
        } else {
            keyboardH = rect.size.height
        }
        keyboardHeight = keyboardH
        // 容器的top
        var top: CGFloat = 0
        if keyboardH > 0 {
            top = kScreenH - contentView.frame.height - keyboardHeight
        } else {
            top = kScreenH
        }
        if ctTop == top { return }
        ctTop = top
        
        UIView.animate(withDuration: duration, animations: {
            self.contentView.frame.origin.y = top
        }) { finished in
            if keyboardH == 0 {
                self.textView.text = nil
                self.updateHeight(self.textView.autoHeight)
                self.removeFromSuperview()
            }
        }
    }
    
    func updateHeight(_ height: CGFloat) {
        var ctHeight = height + surplusHeight
        if ctHeight < contentMinHeight || textView.text.count == 0 {
            ctHeight = contentMinHeight
        }
        if ctHeight > contentMaxHeight {
            ctHeight = contentMaxHeight
        }
        if ctHeight == previousCtHeight {
            return
        }
        previousCtHeight = ctHeight
        self.ctHeight = ctHeight
        ctTop = kScreenH - ctHeight - keyboardHeight
        
        UIView.animate(withDuration: 0.25) {
            self.contentView.frame.size.height = ctHeight
            self.contentView.frame.origin.y = self.ctTop
            
            self.textView.frame.size.height = ctHeight - self.surplusHeight
            
        }
    }
}
