//
//  FYImageMessageCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/27.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYImageMessageCell: FYMessageBaseCell {

    // MARK: - var lazy
    
    lazy var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .random
        return imageView
    }()
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    func initSubview() {
        
        dateLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
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
            make.top.equalTo(dateLabel.snp.bottom).offset(2)
        }

        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(avatarView)
            make.left.equalTo(avatarView.snp.right).offset(3)
        }
        
        contentView.addSubview(pictureView)
        pictureView.snp.remakeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.bottom.equalTo(self.contentView).offset(-17)
            make.width.equalTo(80)
            make.height.equalTo(120)
        }
        
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        pictureView.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    override func refreshMessageCell() {
        super.refreshMessageCell()
        guard let msgType = model?.msgType, msgType == 2 else {
            return
        }
        
        dateLabel.text = model?.date
        avatarView.setImageWithURL(model!.avatar!)
        pictureView.setImageWithURL((model?.image!)!)
        
        if model?.nickName.isBlank == false {
            nameLabel.text = model?.nickName
        }else {
            nameLabel.text = model?.name
        }
        
        // 重新布局
        setupCellLayout(sendType: model!.sendType!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// MARK: - Layout

extension FYImageMessageCell {
    
    func setupCellLayout(sendType: Int) {
        
        if sendType == 0 { //我发送的
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.right.equalToSuperview().offset(-10)
                make.top.equalTo(dateLabel.snp.bottom).offset(3)
            }

            nameLabel.isHidden = true
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.right.equalTo(avatarView.snp.left).offset(-3)
                make.height.equalTo(0)
            }
            
            pictureView.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.right.equalTo(avatarView.snp.left).offset(-5)
                make.bottom.equalTo(self.contentView).offset(-17)
                make.width.equalTo(80)
                make.height.equalTo(120)
            }
            
        }else {
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(dateLabel.snp.bottom).offset(3)
            }

            nameLabel.isHidden = false
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.left.equalTo(avatarView.snp.right).offset(3)
            }
            
            pictureView.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.equalTo(avatarView.snp.right).offset(5)
                make.bottom.equalTo(self.contentView).offset(-17)
                make.width.equalTo(80)
                make.height.equalTo(120)
            }
        }
    }
    
}
