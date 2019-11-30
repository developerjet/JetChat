//
//  LaunchBrowseCell.swift
//  SwiftStudy
//
//  Created by iOS.Jet on 2019/2/22.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import SnapKit

class FYLaunchImageViewCell: UICollectionViewCell {

    var model: SBLaunchConfig? {
        didSet {
            guard model != nil else { return }
            
            launchScreenView.image = model?.image
            launchScreenLabel.text = model?.title ?? ""
        }
    }
    
    lazy var launchScreenBgView: UIImageView = {
        let launchbgView = UIImageView.init()
        launchbgView.contentMode = .scaleToFill
        //launchbgView.image = R.image.icon_launch_bg()
        return launchbgView
    }()
    
    lazy var launchScreenView: UIImageView = {
        let launchView = UIImageView.init()
        launchView.contentMode = .scaleAspectFit
        return launchView
    }()
    
    lazy var launchScreenLabel: UILabel = {
        let launchLabel = UILabel.init()
        launchLabel.textColor = .backGroundWhiteColor()
        launchLabel.font = UIFont.PingFangSemibold(16)
        launchLabel.textAlignment = .center
        launchLabel.numberOfLines = 0
        return launchLabel
    }()
    
    lazy var launchScreenTitle: UILabel = {
        let titleLabel = UILabel.init()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.PingFangRegular(16)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        //titleLabel.text = Lca.zero_app_launch_title.rLocalized()
        return titleLabel
    }()
    
    
    // MARK:- life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        makeUI()
    }
    
    func makeUI() {
        self.backgroundColor = UIColor.colorWithHexStr("0F0F0F")
        contentView.addSubview(launchScreenBgView)
        contentView.addSubview(launchScreenView)
        contentView.addSubview(launchScreenLabel)
        contentView.addSubview(launchScreenTitle)

        launchScreenBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        launchScreenView.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        
        launchScreenLabel.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-106)
        }
        
        launchScreenTitle.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.greaterThanOrEqualTo(22)

            if #available(iOS 11.0, *) {
                make.top
                    .equalTo(contentView.safeAreaLayoutGuide.snp.top)
                    .offset(52)
            } else {
                make.top
                    .equalTo(contentView.snp.topMargin)
                    .offset(52)
            }
        }
    }
}
