//
//  MomentCommentCell.swift
//  JetChat
//
//  Created by Jett on 2020/4/17.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation

protocol MomentCommentDelegate: NSObjectProtocol {
    func contentDidSelected(_ model: FYCommentInfo, action: CommentContentClickAction)
    func thumbDidSelected(_ model: FYCommentInfo)
    /// 只用于commentView获取当前cell的frame
    func commentRect() -> CGRect
}

extension MomentCommentDelegate {
    func commentRect() -> CGRect {
        return .zero
    }
}

class MomentCommentCell: UICollectionViewCell {
    
    fileprivate lazy var contentV: UIView = {
        let v = UIView()
        let x = MomentHeaderCell.padding
        v.frame = CGRect(x: x, y: 10, width: bounds.width-x*2, height: 0)
        v.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.5)
        v.layer.cornerRadius = 5
        v.layer.masksToBounds = true
        return v
    }()
    
    fileprivate lazy var thumbView: NineImageView = {
        let view = CommentThumbView(frame: .zero)
        view.onClick = {[weak self] idx in
            if let model = self?.viewModel?.comments[idx] {
                self?.thumbDidSelected(model)
            }
        }
        return view
    }()
    
    fileprivate lazy var thumbIcon: UIImageView = {
        let iv = UIImageView(image: R.image.ic_star_selected())
        iv.frame = CGRect(x: 10, y: 10, width: 14, height: 12)
        return iv
    }()
    
    fileprivate lazy var commentIcon: UIImageView = {
        let iv = UIImageView(image: R.image.ic_comment_selected())
        iv.frame = CGRect(x: 10, y: 10, width: 14, height: 12)
        return iv
    }()
    
    fileprivate lazy var commentView: CommentContentView = {
        let view = CommentContentView(frame: .zero)
        view.actionDelegate = self
        return view
    }()
    
    fileprivate lazy var divisionV: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: contentV.bounds.width, height: 1)
        v.backgroundColor = UIColor.colorWithHexStr("e5e5e5")
        return v
    }()
    
    fileprivate lazy var separatorV: UIView = {
        let v = UIView(frame: bounds)
        v.backgroundColor = UIColor.colorWithHexStr("F0F0F0")
        return v
    }()
    weak var actionDelegate: MomentCommentDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        addSubview(contentV)
        contentV.addSubview(thumbIcon)
        contentV.addSubview(thumbView)
        
        contentV.addSubview(divisionV)
        contentV.addSubview(commentIcon)
        contentV.addSubview(commentView)
        
        addSubview(separatorV)
        
        // 离屏渲染 + 栅格化
        layer.drawsAsynchronously = true
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    var viewModel: FYMomentInfo?
}

extension MomentCommentCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? FYMomentInfo else { return }
        self.viewModel = viewModel
        contentV.frame.size.height = viewModel.contentHeight
        
        let minX = thumbIcon.frame.maxX + thumbIcon.frame.minX
        thumbView.frame = CGRect(x: minX, y: 5, width: contentV.bounds.width-minX, height: viewModel.thumbsHeight-10)
        thumbView.isRounds = true
        thumbView.images = viewModel.comments.map({$0.avatar_url})
        
        divisionV.frame.origin.y = thumbView.frame.maxY+5-divisionV.frame.height
        divisionV.isHidden = viewModel.comments.count == 0
        
        if viewModel.comments.count == 0 {
            thumbIcon.frame.size.height = 0
            divisionV.frame.origin.y = 0
        }
        
        commentIcon.frame.origin.y = thumbIcon.frame.minY + divisionV.frame.maxY
        commentView.frame = CGRect(x: minX, y: divisionV.frame.maxY, width: thumbView.bounds.width, height: viewModel.commentHeight)
        commentView.comments = viewModel.comments
        
        separatorV.frame = CGRect(x: 0, y: bounds.height-1, width: bounds.width, height: 1)
    }
}

extension MomentCommentCell: MomentCommentDelegate {
    
    func contentDidSelected(_ model: FYCommentInfo, action: CommentContentClickAction) {
        actionDelegate?.contentDidSelected(model, action: action)
    }
    
    func thumbDidSelected(_ model: FYCommentInfo) {
        actionDelegate?.thumbDidSelected(model)
    }
    
    func commentRect() -> CGRect {
        var rect = frame
        rect.origin.y += commentView.frame.minY
        return rect
    }
}
