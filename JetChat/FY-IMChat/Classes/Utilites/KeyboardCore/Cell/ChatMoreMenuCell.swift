//
//  FYChatMoreMenuCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/16.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class ChatMoreMenuCell: UICollectionViewCell {
    
    // MARK: - lazy var
    
    var model: ChatMoreMnueConfig? {
        didSet {
            guard model != nil else {
                return
            }
            
            self.imageView.image = UIImage(named: model!.image!)
            self.titleLabel.text = model?.title ?? ""
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .kTextColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - life cycle
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.width.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp_bottom)
            make.height.equalTo(21)
        }
    }
}
