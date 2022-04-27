//
//  FYContactsInfoView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/30.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYContactsInfoView: UIView {
    
    var chatModel: FYMessageChatModel? {
        didSet {
            guard let model = chatModel else {
                return
            }
            
            nameLabel.text = model.name
            
            if let nickName = model.nickName, nickName.length > 0 {
                nickLabel.text = "备注名：".rLocalized() + nickName
            }
            
            uidLabel.text = "uid：\(model.uid ?? 1000)"
            avatarView.setImageWithURL(model.avatar!, placeholder: "ic_avatar_placeholder")
        }
    }
    
    
    // MARK: - lazy var
    
    lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .random
        imageView.cornerRadius = 5
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    lazy var uidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        self.addSubview(nickLabel)
        self.addSubview(uidLabel)
        
        avatarView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(80)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(avatarView).offset(10)
            make.left.equalTo(avatarView.snp.right).offset(5)
        }
        
        nickLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        
        uidLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(avatarView).offset(-10)
            make.left.equalTo(nameLabel)
        }
    }
}
