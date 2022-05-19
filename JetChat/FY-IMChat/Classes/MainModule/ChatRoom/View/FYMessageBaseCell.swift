//
//  FYMessageBaseCell.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/23.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

enum RootCellType {
    case textCell
    case imageCell
    case viodeCell
}

enum MenuShowStyle {
    case share
    case copy
    case delete
}

protocol FYMessageBaseCellDelegate: AnyObject {
    func cell(_ cell: FYMessageBaseCell, didMenu style: MenuShowStyle, model: FYMessageItem)
    func cell(_ cell: FYMessageBaseCell, didTapAvatarAt model: FYMessageItem)
    func cell(_ cell: FYMessageBaseCell, didTapPictureAt model: FYMessageItem)
    func cell(_ cell: FYMessageBaseCell, didTapVideoAt model: FYMessageItem)
}

extension FYMessageBaseCellDelegate {
    func cell(_ cell: FYMessageBaseCell, didMenu style: MenuShowStyle, model: FYMessageItem) {}
    func cell(_ cell: FYMessageBaseCell, didTapAvatarAt model: FYMessageItem) {}
    func cell(_ cell: FYMessageBaseCell, didTapPictureAt model: FYMessageItem) {}
    func cell(_ cell: FYMessageBaseCell, didTapVideoAt model: FYMessageItem) {}
}

class FYMessageBaseCell: UITableViewCell {

    var model: FYMessageItem? {
        didSet {
            guard let _ = model else {
                return
            }
            
            refreshMessageCell()
        }
    }
    
    
    // MARK: - lazy var
    
    weak var delegate: FYMessageBaseCellDelegate?
    
    lazy var avatarTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTapAction(_:)))
        return tap
    }()
    
    lazy var avatarView: UIImageView = {
        let imageView = UIImageView(image: R.image.ic_avatar_placeholder()!)
        imageView.cornerRadius = 7
        imageView.addGestureRecognizer(self.avatarTap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var bubbleView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.theme.textColor = themed { $0.FYColor_Main_TextColor_V2 }
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        return label
    }()
    
    lazy var dateGradView: UIView = {
        let view = UIView()
        view.cornerRadius = 5
        view.backgroundColor = .RGBA(r: 190, g: 190, b: 190, a: 0.6)
        return view
    }()
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.backgroundColor = .clear
        activityView.isHidden = true
        return activityView
    }()
    
    // MARK: - life cycle
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(dateGradView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(avatarView)
        contentView.addSubview(bubbleView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(activityIndicatorView)
    }
    
    /// 提供子类调用
    open func refreshMessageCell() { }
    
    /// 执行加载动画
    open func activityStartAnimating() {
        guard let sendType = model?.sendType, sendType == 0 else {
            return
        }
        guard let sendDate = model?.date else {
            return
        }
        
        let nowDate = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        if ((nowDate.stringToTimeStamp().doubleValue - sendDate.stringToTimeStamp().doubleValue) <= 1) {
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                self.activityIndicatorView.startAnimating()
                self.activityIndicatorView.isHidden = true
            }
        }
    }
    
    /// 提供子类调用
    /// - Parameter cellType: cell类型
    open func setupLabelLongPressGes(cellType: RootCellType) {
        var longPressGes = UILongPressGestureRecognizer.init()
        if (cellType == .textCell) {
            longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(showMenu1Controller))
        }else {
            longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(showMenu2Controller))
        }
            
        longPressGes.minimumPressDuration = 1
        //longPressGes.numberOfTapsRequired = 1
        longPressGes.numberOfTouchesRequired = 1
        // 长按有效移动范围（从点击开始，长按移动的允许范围 单位 px
        longPressGes.allowableMovement = 15
        
        self.addGestureRecognizer(longPressGes)
    }
    
    @objc func showMenu1Controller() {
        if (UIMenuController.shared.isMenuVisible){
            return
        }
        
        let sendType = model?.sendType
        
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        let item1 = UIMenuItem(title: "转发".rLocalized(), action: #selector(menuShareAction))
        let item2 = UIMenuItem(title: "复制".rLocalized(), action: #selector(menuCopyAction))
        let item3 = UIMenuItem(title: "删除".rLocalized(), action: #selector(menuDeleteAction))
        menu.menuItems = [item1, item2, item3]
        // 设置箭头方向
        menu.arrowDirection = .default
        if sendType == 0 {
            let rect = CGRect(x: 40, y: 40, width: self.width, height: self.height)
            menu.setTargetRect(rect, in: self)
        }else {
            let rect = CGRect(x: -60, y: 60, width: self.width, height: self.height)
            menu.setTargetRect(rect, in: self)
        }
        menu.setMenuVisible(true, animated: true)
    }
    
    @objc func showMenu2Controller() {
        if (UIMenuController.shared.isMenuVisible){
            return
        }
        
        let sendType = model?.sendType
        
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        let item1 = UIMenuItem(title: "转发".rLocalized(), action: #selector(menuShareAction))
        let item3 = UIMenuItem(title: "删除".rLocalized(), action: #selector(menuDeleteAction))
        menu.menuItems = [item1, item3]
        // 设置箭头方向
        menu.arrowDirection = .default
        if sendType == 0 {
            let rect = CGRect(x: 40, y: 40, width: self.width, height: self.height)
            menu.setTargetRect(rect, in: self)
        }else {
            let rect = CGRect(x: -60, y: 60, width: self.width, height: self.height)
            menu.setTargetRect(rect, in: self)
        }
        menu.setMenuVisible(true, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if #available(iOS 13.0, *) {
            UIMenuController.shared.hideMenu()
        }
    }
    
    // MARK: - Action
    
    /// 分享
    @objc open func menuShareAction() {
        if let dataModel = self.model {
            delegate?.cell(self, didMenu: .share, model: dataModel)
        }
    }
    
    /// 复制
    @objc open func menuCopyAction() {
        if let dataModel = self.model {
            delegate?.cell(self, didMenu: .copy, model: dataModel)
        }
    }
    
    
    /// 删除
    @objc open func menuDeleteAction() {
        if let dataModel = self.model {
            delegate?.cell(self, didMenu: .delete, model: dataModel)
        }
    }
    
    
    /// 点击用户头像
    @objc func avatarTapAction(_ tap: UIGestureRecognizer) {
        if let dataModel = self.model {
            delegate?.cell(self, didTapAvatarAt: dataModel)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if [#selector(menuShareAction), #selector(menuCopyAction), #selector(menuDeleteAction)].contains(action) {
            return true
        }
        return false
    }
    
}
