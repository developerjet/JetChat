//
//  OperateMenuView.swift
//  JetChat
//
//  Created by Jett on 2020/5/11.
//  Copyright © 2022 Jett. All rights reserved.
//

import SnapKit

/// 赞｜评论菜单
class OperateMenuView: UIView {
    
    fileprivate lazy var thumbupBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ico-点赞"), for: .normal)
        btn.setTitle("赞", for: .normal)
        btn.setTitle("取消", for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var commentBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ico-评论"), for: .normal)
        btn.setTitle("评论", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    fileprivate lazy var contentView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 160, height: 36)
        v.backgroundColor = mBlackColor
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()
    
    fileprivate lazy var separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    static func show(_ relative: UIView, isLiked: Bool, canComment: Bool, completed: ((Int)->Void)?) {
        let v = OperateMenuView(isLiked, canComment: canComment, completed: completed)
        UIApplication.shared.keyWindow?.addSubview(v)
        // 计算相对于屏幕的位置
        let frame = relative.convert(relative.bounds, to: UIApplication.shared.keyWindow)
        v.show(by: frame)
    }
    
    fileprivate var completed: ((Int)->Void)?
    fileprivate var canComment = true
    private init(_ isLiked: Bool, canComment: Bool, completed: ((Int)->Void)?) {
        super.init(frame: UIScreen.main.bounds)
        self.completed = completed
        thumbupBtn.isSelected = isLiked
        self.canComment = canComment
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
fileprivate extension OperateMenuView {
    func setup() {
        addSubview(contentView)
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        addGestureRecognizer(tap)
        
        contentView.addSubview(thumbupBtn)
        
        thumbupBtn.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.leading.centerY.equalToSuperview()
        }
        if canComment {
            contentView.addSubview(commentBtn)
            contentView.addSubview(separatorView)

            separatorView.snp.makeConstraints { (make) in
                make.width.equalTo(0.5)
                make.height.equalToSuperview().inset(5)
                make.leading.equalTo(thumbupBtn.snp.trailing)
                make.centerY.equalToSuperview()
            }
            commentBtn.snp.makeConstraints { (make) in
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.trailing.centerY.equalToSuperview()
            }
        }else {
            thumbupBtn.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    @objc func click(_ btn: UIButton) {
        hide()
        btn.isSelected = !btn.isSelected
        completed?(btn.tag)
    }
    
    func show(by relative: CGRect) {
        let width: CGFloat = canComment ? 160 : 80
        let originY = relative.midY - 36/2
        let originX = relative.minX - width - 10
        contentView.frame = CGRect(x: relative.minX, y: originY, width: 0, height: 36)
        UIView.animate(withDuration: 0.25) {
            self.contentView.frame.origin.y = originY
            self.contentView.frame.origin.x = originX
            self.contentView.frame.size.width = width
        }
    }
    @objc func hide() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
