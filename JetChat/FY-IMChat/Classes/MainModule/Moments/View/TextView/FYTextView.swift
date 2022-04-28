//
//  JXTextView.swift
//
//  Created by Jett on 2020/5/9.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit

public enum TextAction {
    case change(text: String)
    case delete
    case done
    case keyboard(rect: CGRect, duration: Double)
}

class FYTextView: UITextView {
    
    fileprivate lazy var placeholderLb: UILabel = {
        let lb = UILabel()
        lb.text = "请输入内容...."
        lb.font = self.font
        lb.textColor = UIColor.lightGray
        lb.frame.origin = CGPoint(x: 5, y: 8)
        lb.sizeToFit()
        return lb
    }()
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            placeholderLb.textColor = placeholderColor
        }
    }
    var placeholder: String? {
        didSet {
            placeholderLb.text = placeholder
            placeholderLb.sizeToFit()
        }
    }
    var maxCount: Int = 200
    var onKeyAction: ((TextAction)->Void)?
    fileprivate var textObservation: NSKeyValueObservation?
    /// 自动计算高度
    var autoHeight: CGFloat {
        let size = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let constraint = self.sizeThatFits(size)
        return constraint.height
    }
    /// 是否允许换行
    var lineBreak = true
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if responds(to: #selector(setter: UITextView.textContainerInset)) {
            placeholderLb.frame.origin.x = textContainerInset.left + 5
            placeholderLb.frame.origin.y = textContainerInset.top
        }
    }
}
fileprivate extension FYTextView {
    func setupUI(){
        addSubview(placeholderLb)
        delegate = self
        
        textObservation = observe(\.text, changeHandler: { (tv, change) in
            self.placeholderLb.isHidden = tv.hasText
        })
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(n:)), name: UITextView.textDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(n:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    @objc func keyboardChanged(n: Notification){
        guard let rect = (n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else{
                return
        }
        onKeyAction?(.keyboard(rect: rect, duration: duration))
    }
    
    @objc func textChanged(n: Notification){
        placeholderLb.isHidden = self.hasText
    }
}
extension FYTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onKeyAction?(.change(text: textView.text))
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !lineBreak && text == "\n" {
            onKeyAction?(.done)
            return false
        }
        if textView.text.count >= maxCount {
            textView.text = String(textView.text.prefix(maxCount-1))
            return false
        }
        return true
    }
}
