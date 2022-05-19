//
//  FYContactsInfoView.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/30.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class FYContactsInfoView: UIView {
    
    // MARK: - setter
    
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
    
    
    // MARK: - private lazy var
    
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .random
        imageView.cornerRadius = 5
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
        return label
    }()
    
    private lazy var nickLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V2 }
        return label
    }()
    
    private lazy var uidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V2 }
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
            make.width.height.equalTo(60)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(avatarView).offset(2)
            make.left.equalTo(avatarView.snp.right).offset(10)
        }
        
        nickLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        uidLabel.snp.remakeConstraints { (make) in
            make.bottom.equalTo(avatarView).offset(-2)
            make.left.equalTo(nameLabel)
        }
    }
}
