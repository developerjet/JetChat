//
//  CommentContentView.swift
//  JetChat
//
//  Created by Jett on 2020/5/11.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation

enum CommentContentClickAction {
    /// 点击头像
    case avatar
    /// 点击title
    case title
    /// 回复的标题
    case reply
    /// 点击背景 是否是自己的评论
    case bg(Bool)
    /// 评论
    case comment(String)
    /// 草稿
    case commentDraft(String)
}

class CommentContentView: UITableView {
    
    var comments = [FYCommentInfo]() {
        didSet {
            reloadData()
        }
    }
    
    weak var actionDelegate: MomentCommentDelegate?
    
    fileprivate lazy var commentnputView: CommentInputView = {
        let inputView = CommentInputView()
        inputView.delegate = self
        return inputView
    }()
    
    fileprivate var selectRow: IndexPath?
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        
        separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func tapContentBg() {
        guard let indexPath = selectRow else {
            return
        }
        let model = comments[indexPath.item]
        let isSelf = indexPath.item % 2 == 0
        if !isSelf {
            self.commentnputView.textView.placeholder = "回复\(model.person)："
            self.commentnputView.show()
        }
        actionDelegate?.contentDidSelected(model, action: .bg(isSelf))
    }
}

extension CommentContentView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cell(CommentContentCell.self)
        let model = comments[indexPath.item]
        cell.comment = model
        cell.onClick = {[weak self] action in
            self?.actionDelegate?.contentDidSelected(model, action: action)
        }
        cell.onTextClick = {[weak self] in
            self?.selectRow = indexPath
            self?.tapContentBg()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = comments[indexPath.item]
        return CommentContentCell.getHeight(model)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectRow = indexPath
        tapContentBg()
    }
}

extension CommentContentView: CommentInputViewDelegate {
    
    func onTopChanged(_ top: CGFloat) {
        guard let indexPath = selectRow, var rect = self.actionDelegate?.commentRect() else {
            return
        }
        var height: CGFloat = 0
        for idx in 0...indexPath.item {
            height += CommentContentCell.getHeight(self.comments[idx])
        }
        rect.origin.y += height
        rect.size.height = 10
        
        commentnputView.scrollForComment(rect)
    }
    
    func onTextChanged(_ text: String) {
        print("comment draft: \(text)")
        guard let indexPath = selectRow else {
            return
        }
        let model = comments[indexPath.item]
        actionDelegate?.contentDidSelected(model, action: .commentDraft(text))
    }
    
    func onSend(_ text: String) {
        guard let indexPath = selectRow, !text.isEmpty else {
            return
        }
        let model = comments[indexPath.item]
        actionDelegate?.contentDidSelected(model, action: .comment(text))
    }
}
