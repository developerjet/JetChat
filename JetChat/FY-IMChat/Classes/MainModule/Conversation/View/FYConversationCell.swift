//
//  FYConversationCell.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/28.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class FYConversationCell: UITableViewCell {

    var avatarOnClick: (()->Void)?
    
    var model: FYMessageItem? {
        didSet {
            guard let msgItem = model else {
                return
            }
            
            if msgItem.nickName.isBlank == false {
                nameLabel.text = msgItem.nickName
            }else {
                nameLabel.text = msgItem.name
            }
            
            messageLabel.text = msgItem.message
            
            if let doubleDate = msgItem.date?.stringToTimeStamp().doubleValue {
                dateLabel.text = msgItem.date?.detailDate24Week(time: doubleDate * 1000)
            }
            avatarView.setImageWithURL(model!.avatar!, placeholder: "ic_avatar_placeholder")
            
            if let unReadCount = msgItem.unReadCount, unReadCount > 0 {
                if unReadCount <= 99 {
                    badgeLabel.text = "\(unReadCount)"
                }else {
                    badgeLabel.text = "99+"
                }
                badgeLabel.isHidden = false
            }else {
                badgeLabel.isHidden = true
                badgeLabel.text = nil
            }
        }
    }
    
    // MARK: - var lazy
    
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 7
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
        return label
    }()
    
    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.textColor = .white
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.cornerRadius = 8
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V10 }
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V2 }
        return label
    }()
    
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubview() {
        selectionStyle = .none
        self.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V5 }
        
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(badgeLabel)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(avatarTapAction))
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(tap)
        
        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        badgeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(avatarView).offset(8)
            make.top.equalTo(avatarView).offset(-8)
            make.width.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(12)
            make.top.equalTo(avatarView)
            make.right.equalToSuperview().offset(-14)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-14)
            make.top.equalTo(avatarView)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-14)
        }
    }
    
    // MARK: - Action
    
    @objc
    func avatarTapAction() {
        if avatarOnClick != nil {
            avatarOnClick!()
        }
    }
}
