//
//  MomentBottomCell.swift
//  JetChat
//
//  Created by Jett on 2020/4/15.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation
import IGListDiffKit

enum MomentBottomAction {
    ///  删除
    case delete
    /// 点赞/取消
    case thumbup
    /// 评论
    case comment(String)
    /// 草稿
    case commentDraft(String)
}

class MomentBottomCell: UICollectionViewCell {
    
    fileprivate lazy var timeLb: UILabel = {
        let lb = UILabel()
        lb.sizeToFit()
        lb.textColor = UIColor.colorWithHexStr("BCBBBD")
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    fileprivate lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitle("删除".rLocalized(), for: .normal)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    fileprivate lazy var moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: kScreenW-MomentHeaderCell.padding-30, y: 5, width: 30, height: 20)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitleColor(mCoverColor, for: .normal)
        btn.setTitle("··", for: .normal)
        btn.backgroundColor = .groupTableViewBackground
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return btn
    }()
    
    var onClick: ((MomentBottomAction)->Void)?
    /// section的顶部cell，即头像部分
    var onRelativeRect: (()->CGRect)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate lazy var commentnputView: CommentInputView = {
        let inputView = CommentInputView()
        inputView.delegate = self
        return inputView
    }()
    
    var viewModel: FYMomentInfo?
}

fileprivate extension MomentBottomCell {
    
    func setup() {
        addSubview(timeLb)
        addSubview(deleteBtn)
        addSubview(moreBtn)
        
        timeLb.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: timeLb, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: MomentHeaderCell.contentLeft))
        addConstraint(NSLayoutConstraint(item: timeLb, attribute: .centerY, relatedBy: .equal, toItem: moreBtn, attribute: .centerY, multiplier: 1, constant: 0))
        
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: deleteBtn, attribute: .leading, relatedBy: .equal, toItem: timeLb, attribute: .trailing, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: deleteBtn, attribute: .centerY, relatedBy: .equal, toItem: timeLb, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    @objc func click(_ btn: UIButton) {
        switch btn.tag {
        case 0:
            // more
            OperateMenuView.show(self.moreBtn, isLiked: false, canComment: true) {[weak self] idx in
                guard let `self` = self else { return }
                if idx == 0 {
                    self.onClick?(.thumbup)
                }else {
                    self.commentnputView.show()
                }
            }
        case 1:
            // delete
            self.onClick?(.delete)
        default:
            break
        }
    }
}

extension MomentBottomCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? FYMomentInfo else { return }
        self.viewModel = viewModel
        timeLb.text = viewModel.publicTime
        timeLb.sizeToFit()
        deleteBtn.isHidden = false
    }
}

extension MomentBottomCell: CommentInputViewDelegate {
    func onTopChanged(_ top: CGFloat) {
        if let onRelativeRect = onRelativeRect {
            commentnputView.scrollForComment(onRelativeRect())
        }
    }
    
    func onTextChanged(_ text: String) {
        print("comment draft: \(text)")
        self.onClick?(.commentDraft(text))
    }
    
    func onSend(_ text: String) {
        if !text.isEmpty {
            self.onClick?(.comment(text))
        }
    }
}
