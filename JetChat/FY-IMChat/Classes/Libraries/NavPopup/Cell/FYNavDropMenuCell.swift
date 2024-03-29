//
//  FYNavDropMenuCell.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class FYNavDropMenuCell: UITableViewCell {

    // MARK: - setter && getter
    
    var model: FYCellDataConfig? {
        didSet {
            guard let model = model else {
                return
            }
            
            titleLabel.text = model.title
            leftImageView.image = UIImage(named: model.image!)
            lineView.isHidden = !model.isShow
            
            if model.image.isBlank {
                titleLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.centerX.equalToSuperview()
                }
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
        label.font = UIFont.PingFangRegular(15)
        return label
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.theme.backgroundColor = themed { $0.FYColor_BorderColor_V1 }
        return view
    }()
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V12 }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        self.makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        self.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V12 }
        
        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(5)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }

}
