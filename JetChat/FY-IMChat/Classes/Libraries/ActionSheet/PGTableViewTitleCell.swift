//
//  PGTableViewTitleCell.swift
//  PGActionSheet
//
//  Created by piggybear on 2017/10/3.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import UIKit

class PGTableViewTitleCell: UITableViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title ?? ""
        }
    }
    
    var titleFont: UIFont? {
        didSet {
            guard let font = titleFont else {
                return
            }
            
            titleLabel.font = font
        }
    }
    
    var hideLine: Bool? {
        didSet {
            guard let isHidden = hideLine else {
                return
            }
            
            lineView.isHidden = isHidden
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .PingFangRegular(14)
        return label
    }()
    
    private lazy var lineView: UIView = {
         let view = UIView()
        view.backgroundColor = .colorWithHexStr("e5e5e5")
         return view
     }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        buildUI()
    }
    
    private func buildUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
