//
//  MomentTopCell.swift
//  JetChat
//
//  Created by Jett on 2022/4/16.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation

private let topOffset: CGFloat = 60
private let bottomIndent: CGFloat = 40
private let avatorW: CGFloat = 80
private let space: CGFloat = 20

/// 顶部视图
class MomentTopCell: UICollectionViewCell {
    
    fileprivate lazy var bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 0, y: 0, width: kScreenW, height: bounds.size.height - bottomIndent)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame =  CGRect(x: kScreenW - avatorW - 16, y: bgImageView.frame.maxY, width: avatorW, height: avatorW)
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    
    fileprivate lazy var userNameLabel: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: 0, y: avatarImageView.frame.minY + space, width: avatarImageView.frame.minX - space, height: 30)
        lb.textAlignment = .right
        lb.textColor = .white
        lb.font = .PingFangSemibold(18)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    func setup() {
        addSubview(bgImageView)
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        bgImageView.frame.origin.y -= topOffset
        avatarImageView.frame.origin.y -= topOffset
        userNameLabel.frame.origin.y -= topOffset
        bgImageView.frame.size.height += topOffset
    }
}

extension MomentTopCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? FYMomentInfo, let info = viewModel.userInfo else {
            return
        }
        
        bgImageView.setImageWithURL(info.background_url, placeholder: R.image.ic_placeholder()!)
        avatarImageView.setImageWithURL(info.avatar_url , placeholder: R.image.ic_avatar_placeholder()!)
        userNameLabel.text = info.user_name
    }
}
