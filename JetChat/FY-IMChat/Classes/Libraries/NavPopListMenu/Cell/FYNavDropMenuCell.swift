//
//  FYNavDropMenuCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/6.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYNavDropMenuCell: UITableViewCell {

    // MARK: - var lazy
    
    var model: CommonMenuConfig? {
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.theme_textColor = "Global.textColor"
        label.font = UIFont.PingFangRegular(15)
        return label
    }()
    
    lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        //view.theme_backgroundColor = "Global.lineColor"
        view.backgroundColor = .colorWithHexStr("D8D8D8")
        return view
    }()
    
    // MARK: - life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.theme_backgroundColor = "Global.backgroundColor"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        self.makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        self.theme_backgroundColor = "Global.backgroundColor"
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
