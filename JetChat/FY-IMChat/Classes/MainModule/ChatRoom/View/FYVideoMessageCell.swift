//
//  FYVideoMessageCell.swift
//  FY-JetChat
//
//  Created by fangyuan on 2019/12/22.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class FYVideoMessageCell: FYMessageBaseCell {

    // MARK: - var lazy
    
    lazy var videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .random
        return imageView
    }()
    
    lazy var playImgView: UIImageView = {
        let image = UIImage(named: "play_btn_normal")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var videoTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(videoTapAction(_:)))
        return tap
    }()
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
        setupLabelLongPressGes(cellType: .viodeCell)
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
            make.top.equalTo(dateGroudView.snp.bottom).offset(5)
        }

        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(avatarView)
            make.left.equalTo(avatarView.snp.right).offset(3)
        }
        
        videoImageView.isUserInteractionEnabled = true
        videoImageView.addGestureRecognizer(self.videoTap)
        contentView.addSubview(videoImageView)
        videoImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.bottom.equalTo(self.contentView).offset(-17)
            make.width.equalTo(100)
            make.height.equalTo(145)
        }
        
        videoImageView.addSubview(playImgView)
        videoImageView.bringSubviewToFront(playImgView)
        playImgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        activityIndicatorView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(videoImageView)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)
        videoImageView.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    override func refreshMessageCell() {
        super.refreshMessageCell()
        guard let msgType = model?.msgType, msgType == 3 else {
            return
        }
        
        dateLabel.text = model?.date
        
        if let avatarURL = model?.avatar {
            avatarView.setImageWithURL(avatarURL)
        }
        
        if let imageURL = model?.image {
            videoImageView.setImageWithURL(imageURL)
        }
        
        if model?.nickName.isBlank == false {
            nameLabel.text = model?.nickName
        }else {
            nameLabel.text = model?.name
        }
        
        // 重新布局
        if let sendType = model?.sendType {
            setupCellLayout(sendType: sendType)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Action
    
    @objc func videoTapAction(_ tap: UITapGestureRecognizer) {
        if let videoModel = self.model {
            delegate?.cell(self, didTapVideoAt: videoModel)
        }
    }

}


// MARK: - Layout

extension FYVideoMessageCell {
    
    func setupCellLayout(sendType: Int) {
        
        if sendType == 0 { //我发送的
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.right.equalToSuperview().offset(-10)
                make.top.equalTo(dateGroudView.snp.bottom).offset(5)
            }

            nameLabel.isHidden = true
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.right.equalTo(avatarView.snp.left).offset(-3)
                make.height.equalTo(0)
            }
            
            videoImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel)
                make.right.equalTo(avatarView.snp.left).offset(-5)
                make.bottom.equalTo(self.contentView).offset(-17)
                make.width.equalTo(100)
                make.height.equalTo(145)
            }
            
            activityIndicatorView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(videoImageView)
                make.right.equalTo(videoImageView.snp.left)
                make.width.height.equalTo(30)
            }
            
            activityStartAnimating()
            
        }else {
            avatarView.snp.remakeConstraints { (make) in
                make.width.height.equalTo(40)
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(dateGroudView.snp.bottom).offset(5)
            }

            nameLabel.isHidden = false
            nameLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarView)
                make.left.equalTo(avatarView.snp.right).offset(3)
            }
            
            videoImageView.snp.remakeConstraints { (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.left.equalTo(avatarView.snp.right).offset(5)
                make.bottom.equalTo(self.contentView).offset(-17)
                make.width.equalTo(100)
                make.height.equalTo(145)
            }
        }
    }
    
}
