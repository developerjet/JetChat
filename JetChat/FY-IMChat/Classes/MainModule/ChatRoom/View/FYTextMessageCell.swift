//
//  FYTextMessageCell.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/20.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit
import YYText

class FYTextMessageCell: FYMessageBaseCell {
    
    private let kMaxWidth: CGFloat = kScreenW * 0.55
    
    // MARK: - var lazy

    lazy var contentLabel: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 0
        label.displaysAsynchronously = true;
        label.clearContentsBeforeAsynchronouslyDisplay = false;
        label.font = UIFont.systemFont(ofSize: 15)
        switch themeService.type {
        case .light:
            label.textColor = .Color_Black_000000
        default:
            label.textColor = .Color_Gray_5A636D
        }
        return label
    }()
    
    // MARK: - life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
        setupLabelLongPressGes(cellType: .textCell)
    }
    
    func initSubview() {
        contentView.addSubview(contentLabel)
        
        dateLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        
        dateGradView.snp.remakeConstraints { (make) in
            make.top.equalTo(dateLabel).offset(-1)
            make.left.equalTo(dateLabel).offset(-2)
            make.bottom.equalTo(dateLabel).offset(1)
            make.right.equalTo(dateLabel).offset(2)
        }
        
        avatarView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(dateGradView.snp.bottom).offset(5)
        }

        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(avatarView)
            make.left.equalTo(avatarView.snp.right).offset(3)
        }

        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.bottom.equalTo(contentLabel.snp.bottom).offset(2)
            make.left.equalTo(avatarView.snp.right)
            make.width.width.equalTo(kMaxWidth)
            make.height.equalTo(contentLabel).offset(26)
        }
        
        contentLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(bubbleView).offset(13);
            make.left.equalTo(bubbleView).offset(20);
            make.right.equalTo(bubbleView).offset(-15);
        }
        
        activityIndicatorView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(bubbleView)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        bubbleView.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    override func layoutMessageCell() {
        super.layoutMessageCell()
        guard let msgType = model?.msgType, msgType == 1 else {
            return
        }
        
        dateLabel.text = model?.date
        contentLabel.text = model?.message
        
        if let imageURL = model?.avatar {
            avatarView.setImageWithURL(imageURL, placeholder: "ic_avatar_placeholder")
        }
        
        if let nickName = model?.nickName, nickName.length > 0 {
            nameLabel.text = nickName
        }else {
            nameLabel.text = model?.name
        }
        
        // 重新布局
        let contentSize = contentLabel.sizeThatFits(CGSize(width: kMaxWidth, height: CGFloat(Float.greatestFiniteMagnitude)))
        if let sendType = model?.sendType {
            setupCellLayout(sendType: sendType, size: contentSize)
        }
        
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
        let sizeWidth  = size.width + 12
        let sizeHeight = size.height + 8
        
        contentLabel.preferredMaxLayoutWidth = size.width
        
        if sendType == 0 { //我发送的
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.right.equalToSuperview().offset(-10)
                make.top.equalTo(dateGradView.snp.bottom).offset(5)
            }

            nameLabel.isHidden = true
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.right.equalTo(avatarView.snp.left).offset(-3)
                make.height.equalTo(0)
            }
            
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(8)
                make.bottom.equalToSuperview().offset(-15)
                make.right.equalTo(avatarView.snp.left).offset(-14)
                make.width.equalTo(sizeWidth)
                make.height.equalTo(sizeHeight)
            }
            
            let top: CGFloat = contentLabel.text!.containEmoji ? -10 : -12
            let bottmom: CGFloat = contentLabel.text!.containEmoji ? 10 : 12
            bubbleView.snp.remakeConstraints { (make) in
                make.right.equalTo(avatarView.snp.left).offset(-2)
                make.top.equalTo(contentLabel).offset(top)
                make.bottom.equalTo(contentLabel).offset(bottmom)
                make.width.equalTo(contentLabel).offset(30)
            }
            
            activityIndicatorView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(bubbleView)
                make.right.equalTo(bubbleView.snp.left)
                make.width.height.equalTo(30)
            }
            
            // start
            activityStartAnimating()
            
        }else {
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(dateGradView.snp.bottom).offset(5)
            }

            nameLabel.isHidden = false
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.left.equalTo(avatarView.snp.right).offset(3)
            }
            
            contentLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.left.equalTo(avatarView.snp.right).offset(21)
                make.bottom.equalToSuperview().offset(-15)
                make.width.equalTo(sizeWidth)
            }
            
            let top: CGFloat = contentLabel.text!.containEmoji ? -10 : -12
            let bottmom: CGFloat = contentLabel.text!.containEmoji ? 10 : 12
            bubbleView.snp.remakeConstraints { (make) in
                make.left.equalTo(avatarView.snp.right).offset(2)
                make.top.equalTo(contentLabel).offset(top)
                make.bottom.equalTo(contentLabel).offset(bottmom)
                make.width.equalTo(contentLabel).offset(30)
            }
        }
    }
}

   
