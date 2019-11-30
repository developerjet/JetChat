//
//  FYTextMessageCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/20.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYTextMessageCell: FYMessageBaseCell {
    
    private let kMessageW: Double = 220.0
    
    // MARK: - var lazy

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // MARK: - life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    func initSubview() {
        contentView.addSubview(contentLabel)
        
        dateLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        
        dateGroudView.snp.remakeConstraints { (make) in
            make.top.equalTo(dateLabel).offset(-1)
            make.left.equalTo(dateLabel).offset(-2)
            make.bottom.equalTo(dateLabel).offset(1)
            make.right.equalTo(dateLabel).offset(2)
        }
        
        avatarView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(dateLabel.snp_bottom).offset(2)
        }

        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(avatarView)
            make.left.equalTo(avatarView.snp.right).offset(3)
        }

        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.bottom.equalTo(self.contentView).offset(-15)
            make.left.equalTo(avatarView.snp.right)
            make.width.width.equalTo(kMessageW)
            make.height.equalTo(contentLabel).offset(26)
        }
        
        contentLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(bubbleView).offset(13);
            make.left.equalTo(bubbleView).offset(20);
            make.right.equalTo(bubbleView).offset(-13);
        }
        
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        bubbleView.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    override func refreshMessageCell() {
        super.refreshMessageCell()
        guard let msgType = model?.msgType, msgType == 1 else {
            return
        }
        
        dateLabel.text = model?.date
        contentLabel.text = model?.message
        avatarView.setImageWithURL(model!.avatar!, placeholder: "ic_avatar_placeholder")
        
        if model?.nickName.isBlank == false {
            nameLabel.text = model?.nickName
        }else {
            nameLabel.text = model?.name
        }
        
        // 重新布局
        let contentSize = contentLabel.sizeThatFits(CGSize(width: kMessageW, height: Double(Float.greatestFiniteMagnitude)))
        setupCellLayout(sendType: (model?.sendType!)!, size: contentSize)
        
        // 设置泡泡
        let bubbleImage = model?.sendType == 0 ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        bubbleView.image = bubbleImage.stretchableImage(centerStretchScale: 0.65)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension FYTextMessageCell {
    
    func setupCellLayout(sendType: Int, size: CGSize) {
        let sizeWidth = size.width + 5
        
        if sendType == 0 { //我发送的
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.right.equalToSuperview().offset(-10)
                make.top.equalTo(dateLabel.snp_bottom).offset(3)
            }

            nameLabel.isHidden = true
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.right.equalTo(avatarView.snp.left).offset(-3)
                make.height.equalTo(0)
            }
            
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.bottom.equalToSuperview().offset(-10)
                make.right.equalTo(avatarView.snp.left).offset(-10)
                make.width.equalTo(sizeWidth)
            }
            
            bubbleView.snp.remakeConstraints { (make) in
                make.right.equalTo(avatarView.snp.left).offset(-2)
                make.top.equalTo(contentLabel).offset(-7)
                make.width.equalTo(contentLabel).offset(20)
                make.bottom.equalTo(contentLabel).offset(7)
            }
            
        }else {
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(dateLabel.snp_bottom).offset(3)
            }

            nameLabel.isHidden = false
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.left.equalTo(avatarView.snp.right).offset(3)
            }
            
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.equalTo(avatarView.snp.right).offset(13)
                make.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(sizeWidth)
            }
            
            bubbleView.snp.remakeConstraints { (make) in
                make.left.equalTo(avatarView.snp.right).offset(2)
                make.top.equalTo(contentLabel).offset(-7)
                make.width.equalTo(contentLabel).offset(20)
                make.bottom.equalTo(contentLabel).offset(7)
            }
        }
    }
    
}

   
