//
//  FYContactsTableViewCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/28.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYContactsTableViewCell: UITableViewCell {

    var model: FYMessageChatModel? {
        didSet {
            guard model != nil else {
                return
            }

            if model?.nickName.isBlank == false {
                nameLabel.text = model?.nickName
            }else {
                nameLabel.text = model?.name
            }
            
            uidLabel.text = "uid：\(model?.uid ?? 1000)"
            avatarView.setImageWithURL(model!.avatar!, placeholder: "ic_avatar_placeholder")
        }
    }
    
    // MARK: - var lazy
    
    var didAvatarCallClosure : ((FYMessageChatModel)->Void)?
    
    lazy var tap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarAction))
        return gesture
    }()
    
    lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        imageView.cornerRadius = 7
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    lazy var uidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var selectedView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
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
        contentView.addSubview(uidLabel)
        contentView.addSubview(selectedView)
        
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
