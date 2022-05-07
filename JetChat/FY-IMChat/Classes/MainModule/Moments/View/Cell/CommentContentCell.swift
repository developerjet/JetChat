//
//  CommentContentCell.swift
//  JetChat
//
//  Created by Jett on 2020/6/9.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation

class CommentContentCell: UITableViewCell {
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(_:)))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    fileprivate lazy var titleBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.theme.titleColor(from: themed { $0.FYColor_Main_TextColor_V1 }, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var contentLb: FYLabel = {
        let lb = FYLabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.theme.textColor = themed{ $0.FYColor_Main_TextColor_V3 }
        lb.numberOfLines = 0
        return lb
    }()
    
    var comment: FYCommentInfo! {
        didSet {
            avatarImageView.setImageWithURL(comment.avatar_url, placeholder: R.image.ic_avatar_placeholder()!)
            titleBtn.setTitle(comment.person, for: .normal)

            let reply: String? = "--"
            if let parent = reply, !parent.isEmpty {
                contentLb.text = "回复\(parent)：\(comment.comment)"
            }else {
                contentLb.text = comment.comment
            }
        }
    }
    
    var onClick: ((CommentContentClickAction)->Void)?
    var onTextClick: (()->Void)?
    
    static func getHeight(_ model: FYCommentInfo) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let width = kScreenW - 50 - 34 - MomentHeaderCell.padding * 2
        let height = 50 + model.comment.textSize(width, font: font).height - font.lineHeight
        return height
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        addSubview(avatarImageView)
        addSubview(titleBtn)
        addSubview(contentLb)
        setMultiLabel(contentLb)
        
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview()
            make.top.equalTo(5)
        }
        
        titleBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(5)
            make.top.equalTo(avatarImageView)
            make.height.equalTo(18)
            make.trailing.lessThanOrEqualToSuperview().offset(-5)
        }
        
        contentLb.snp.makeConstraints { (make) in
            make.leading.equalTo(titleBtn)
            make.trailing.lessThanOrEqualToSuperview().offset(-5)
            make.top.equalTo(titleBtn.snp.bottom)
        }
    }
    
    private func setMultiLabel(_ label: FYLabel) {
        let reply = FYLabelType.custom(pattern: "回复(.+)：", start: 2, tender: -1)
        label.customColor = [reply: mDarkBlueColor]
        label.enabledTypes = [.URL, .phone, reply]
        label.handleNormalTap {[weak self] text in
            self?.onTextClick?()
        }
        label.handleCustomTap(reply) {[weak self] (text) in
            self?.onClick?(.reply)
        }
        label.handleURLTap { (text) in
            NotificationCenter.default.post(name: NSNotification.Name.list.openURL, object: URL(string: text))
        }
        label.handlePhoneTap { (phone) in
            UIApplication.shared.openURL(URL(string: "tel://\(phone)")!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func viewClick(_ ges: UIGestureRecognizer) {
        onClick?(.avatar)
    }
    
    @objc private func click(_ btn: UIButton) {
        onClick?(.title)
    }
}
