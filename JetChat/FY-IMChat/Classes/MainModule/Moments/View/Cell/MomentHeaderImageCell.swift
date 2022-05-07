//
//  MomentHeaderImageCell.swift
//  JetChat
//
//  Created by Jett on 2022/4/16.
//  Copyright © 2022 Jett. All rights reserved.
//

import Kingfisher
import YBImageBrowser

/// 单张图片显示
class MomentHeaderImageCell: UICollectionViewCell {
    
    static let padding: CGFloat = 16
    static let contentLeft = padding + 60
    static let contentW = kScreenW-padding-contentLeft
    
    var onClick: ((Int)->Void)?
    
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
        lb.theme.textColor = themed{ $0.FYColor_Main_TextColor_V2 }
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        return lb
    }()
    
    fileprivate lazy var contentLb: FYLabel = {
        let lb = FYLabel()
        lb.frame = CGRect(x: usernameLb.frame.minX, y: usernameLb.frame.maxY+5, width: MomentHeaderCell.contentW, height: 0)
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.theme.textColor = themed{ $0.FYColor_Main_TextColor_V1 }
        lb.numberOfLines = 0
        lb.showFavor = {[weak self] in
            guard let self = self else { return }
        }
        return lb
    }()
    
    /// 单张图片
    fileprivate lazy var singleImageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = contentLb.frame
        iv.clipsToBounds = true
        iv.autoresizesSubviews = true
        iv.clearsContextBeforeDrawing = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImage(_:)))
        iv.addGestureRecognizer(tap)
        iv.tag = 10
        return iv
    }()
    
    fileprivate lazy var expendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("展开", for: .normal)
        btn.setTitle("收起", for: .selected)
        btn.setTitleColor(.Color_Blue_1890FF, for: .normal)
        btn.setTitleColor(.Color_Blue_1890FF, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        btn.sizeToFit()
        btn.isHidden = true
        return btn
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
}

extension MomentHeaderImageCell {
    
    func setup() {
        self.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V5 }
        
        addSubview(avatarImageView)
        addSubview(usernameLb)
        addSubview(contentLb)
        addSubview(singleImageView)
        addSubview(expendBtn)
        
        setLabel()
    }
    
    func setLabel() {
        contentLb.enabledTypes = [.URL, .phone]
        contentLb.handleURLTap { (text) in
            NotificationCenter.default.post(name: NSNotification.Name.list.openURL, object: URL(string: text))
        }
        contentLb.handlePhoneTap { (phone) in
            UIApplication.shared.openURL(URL(string: "tel://\(phone)")!)
        }
    }
    
    @objc func previewImage(_ ges: UIGestureRecognizer) {
        switch ges.view?.tag {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name.list.push, object: viewModel?.userInfo)
        case 10:
            print("预览图片")
            if let images = self.viewModel?.images {
                singleBrowserImages(images, index: 0, sourceView: singleImageView)
            }
        default:
            break
        }
    }
    
    @objc func click(_ btn: UIButton) {
        onClick?(btn.tag)
    }
    
    func singleBrowserImages(_ images: [String], index: Int, sourceView: UIView?) {
        guard images.count > 0 else { return }
        guard let projectiveView = sourceView else { return }
        
        var imageDatas: [YBIBImageData] = []
        for imageUrl in images {
            let data = YBIBImageData()
            data.imageURL = URL(string: imageUrl)
            data.projectiveView = projectiveView
            imageDatas.append(data)
        }
        
        let browser = YBImageBrowser()
        browser.dataSourceArray = imageDatas
        browser.currentPage = index
        browser.show()
    }
}

extension MomentHeaderImageCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? FYMomentInfo else { return }
        self.viewModel = viewModel
        
        avatarImageView.setImageWithURL(viewModel.avatar, placeholder: R.image.ic_avatar_placeholder()!)
        
        usernameLb.text = viewModel.userName
        
        contentLb.text = viewModel.content
        contentLb.frame.size.height = viewModel.textHeight
        
        if viewModel.isNeedExpend {
            expendBtn.isSelected = viewModel.isTextExpend
            contentLb.numberOfLines = viewModel.isTextExpend ? 0 : 3
            expendBtn.frame.origin = CGPoint(x: contentLb.frame.minX, y: contentLb.frame.maxY)
        }
        expendBtn.isHidden = !viewModel.isNeedExpend
        
        if viewModel.images.count > 0 {
            let maxY = contentLb.frame.maxY + 10 + (!expendBtn.isHidden ? expendBtn.frame.height : 0)
            singleImageView.setImageWithURL(viewModel.images[0], placeholder:R.image.ic_placeholder()!)
            
            singleImageView.frame.origin.y = maxY
            singleImageView.frame.size.height = viewModel.momentPicsHeight(viewModel.images.count)
            singleImageView.frame.size.width = singleImageView.frame.size.height
        }else {
            singleImageView.frame.size.height = 0
        }
    }
}

