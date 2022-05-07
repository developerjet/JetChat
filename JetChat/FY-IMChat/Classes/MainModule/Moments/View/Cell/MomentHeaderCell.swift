//
//  MomentHeaderCell.swift
//  JetChat
//
//  Created by Jett on 2022/4/14.
//  Copyright © 2022 Jett. All rights reserved.
//

import Kingfisher
import YBImageBrowser
import UIKit

/// 多张图片显示
class MomentHeaderCell: UICollectionViewCell {
    
    var onClick: ((Int)->Void)?
    
    static let padding: CGFloat = 16
    static let contentLeft = padding+10+50
    static let contentW = kScreenW-padding-contentLeft
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: MomentHeaderCell.padding, y: 10, width: 50, height: 50)
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImage(_:)))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    fileprivate lazy var usernameLb: UILabel = {
        let lb = UILabel()
        lb.frame = CGRect(x: avatarImageView.frame.maxX+10, y: avatarImageView.frame.minY+2, width: MomentHeaderCell.contentW, height: 20)
        lb.theme.textColor = themed { $0.FYColor_Main_TextColor_V2 }
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        return lb
    }()
    
    fileprivate lazy var contentLb: FYLabel = {
        let lb = FYLabel()
        lb.frame = CGRect(x: usernameLb.frame.minX, y: usernameLb.frame.maxY+5, width: MomentHeaderCell.contentW, height: 0)
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
        lb.numberOfLines = 0
        lb.showFavor = {[weak self] in
            guard let self = self else { return }
        }
        return lb
    }()
    
    fileprivate lazy var expendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("展开".rLocalized(), for: .normal)
        btn.setTitle("收起".rLocalized(), for: .selected)
        btn.setTitleColor(.Color_Blue_1890FF, for: .normal)
        btn.setTitleColor(.Color_Blue_1890FF, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        btn.sizeToFit()
        btn.isHidden = true
        return btn
    }()
    
    fileprivate lazy var nineImageView: NineImageView = {
        let view = NineImageView(frame: .zero)
        view.frame = contentLb.frame
        view.frame.size.width -= 50
        view.onPreviewImages = { [weak self] images, indexPath, sourceView in
            self?.browserImages(images, index: indexPath.item, sourceView: sourceView)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var viewModel: FYMomentInfo?
    
    
    func browserImages(_ images: [String], index: Int, sourceView: UIView? = nil) {
        guard images.count > 0 else { return }
        
        var imageDatas: [YBIBImageData] = []
        for imageUrl in images {
            let data = YBIBImageData()
            data.imageURL = URL(string: imageUrl)
            imageDatas.append(data)
        }
        
        let browser = YBImageBrowser()
        browser.dataSourceArray = imageDatas
        browser.currentPage = index
        browser.show()
    }
}

extension MomentHeaderCell {
    
    func setup() {
        self.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V5 }
        
        addSubview(avatarImageView)
        addSubview(usernameLb)
        addSubview(contentLb)
        addSubview(expendBtn)
        addSubview(nineImageView)
        setupLabel()
    }
    
    func setupLabel() {
        contentLb.enabledTypes = [.URL, .phone]
        contentLb.handleURLTap { (text) in
            NotificationCenter.default.post(name: NSNotification.Name.list.openURL, object: URL(string: text))
        }
        
        contentLb.handlePhoneTap { (phone) in
            if let url = NSURL(string: "tel://\(phone)") as? URL {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func previewImage(_ ges: UIGestureRecognizer) {
        switch ges.view?.tag {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name.list.push, object: viewModel?.userInfo)
        default:
            break
        }
    }
    
    @objc func click(_ btn: UIButton) {
        onClick?(btn.tag)
    }
}

extension MomentHeaderCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? FYMomentInfo else { return }
        self.viewModel = viewModel

        if (viewModel.avatar.length > 0) {
            avatarImageView.setImageWithURL(viewModel.avatar, placeholder: R.image.ic_avatar_placeholder()!)
        }
        
        if (viewModel.userName.length > 0) {
            usernameLb.text = viewModel.userName
        }
        
        if (viewModel.content.length > 0) {
            contentLb.text = viewModel.content
        }
        
        contentLb.frame.size.height = viewModel.textHeight
        
        if viewModel.isNeedExpend {
            expendBtn.isSelected = viewModel.isTextExpend
            contentLb.numberOfLines = viewModel.isTextExpend ? 0 : 3
            expendBtn.frame.origin = CGPoint(x: contentLb.frame.minX, y: contentLb.frame.maxY)
        }
        
        expendBtn.isHidden = !viewModel.isNeedExpend
        
        // 不能通过if判断切换同一位置的显示视图
        if viewModel.images.count > 0 {
            let maxY = contentLb.frame.maxY + 10 + (!expendBtn.isHidden ? expendBtn.frame.height : 0)
            nineImageView.images = viewModel.images
            nineImageView.frame.origin.y = maxY
            nineImageView.frame.size.height = viewModel.momentPicsHeight(viewModel.images.count)
        }else {
            nineImageView.frame.size.height = 0
        }
    }
}
