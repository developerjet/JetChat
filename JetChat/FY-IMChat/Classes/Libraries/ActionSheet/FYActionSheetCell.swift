//
//  FYActionSheetCell.swift
//  PGActionSheet
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019年 Jett. All rights reserved.
//

import UIKit

class FYActionSheetCell: UITableViewCell {
    
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
    
    var textColor: UIColor? {
        didSet {
            guard let color = textColor else {
                return
            }
            
            titleLabel.textColor = color
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
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
        label.font = .PingFangRegular(14)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.theme.backgroundColor = themed { $0.FYColor_BorderColor_V1 }
        return view
    }()
    
    // MARK: - life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V12 }
        contentView.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V12 }
        
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
