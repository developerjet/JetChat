//
//  FYContactsTableViewCell.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/28.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class FYContactsTableViewCell: UITableViewCell {

    var model: FYMessageChatModel? {
        didSet {
            guard let chatModel = model else {
                return
            }

            if chatModel.nickName.isBlank == false {
                nameLabel.text = chatModel.nickName
            }else {
                nameLabel.text = chatModel.name
            }
            
            uidLabel.text = "uid：\(chatModel.uid ?? 1000)"
            avatarView.setImageWithURL(chatModel.avatar ?? "", placeholder: R.image.ic_avatar_placeholder()!)
        }
    }
    
    // MARK: - var lazy
    
    var didAvatarCallClosure : ((FYMessageChatModel)->Void)?
    
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 7
        imageView.tapClosure { [weak self] in
            self?.avatarAction()
        }
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
        return label
    }()
    
    private lazy var uidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V10 }
        return label
    }()
    
    lazy var selectedView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var lineView: UIView = {
        let v = UIView()
        v.theme.backgroundColor = themed { $0.FYColor_BorderColor_V2 }
        return v
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
        theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V5 }
        
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(uidLabel)
        contentView.addSubview(selectedView)
        contentView.addSubview(lineView)
        
        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(8)
            make.top.equalTo(avatarView)
            make.right.equalToSuperview().offset(-14)
        }
        
        uidLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-14)
        }
        
        selectedView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-14)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.left.equalTo(avatarView)
            make.height.equalTo(0.7)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            selectedView.image = UIImage(named: "ic_msg_forward_s")
        }else {
            selectedView.image = UIImage(named: "ic_msg_forward_n")
        }
    }

    // MARK: - Action
    
    @objc func avatarAction() {
        if didAvatarCallClosure != nil {
            didAvatarCallClosure?(self.model!)
        }
    }
}
