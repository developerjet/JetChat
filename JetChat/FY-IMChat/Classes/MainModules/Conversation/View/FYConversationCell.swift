//
//  FYConversationCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/28.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYConversationCell: UITableViewCell {

    var model: FYMessageItem? {
        didSet {
            guard model != nil else {
                return
            }
            
            if model?.nickName.isBlank == false {
                nameLabel.text = model?.nickName
            }else {
                nameLabel.text = model?.name
            }
            
            messageLabel.text = model?.message
            
            if let doubleDate = model?.date?.stringToTimeStamp().doubleValue {
                dateLabel.text = model?.date?.detailDate24Week(time: doubleDate * 1000)
            }
            avatarView.setImageWithURL(model!.avatar!, placeholder: "ic_avatar_placeholder")
            
            if let unReadCount = model?.unReadCount, unReadCount > 0 {
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
    
    lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 7
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.textColor = .white
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.cornerRadius = 8
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = .colorWithHexStr("AAAAAA")
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
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(badgeLabel)
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
