//
//  MCCommonCoreView.swift
//  MK-MCallet
//
//  Created by iOS.Jet on 2019/3/5.
//  Copyright © 2019 mtop.one. All rights reserved.
//

import UIKit
import SnapKit

private let marginX: CGFloat = 7
private let textFieldH: CGFloat = 24
private let lineHeight: CGFloat = 0.6

// MARK:- 常用大标题
class MCLargeTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        
        self.font = UIFont.PingFangMedium(15)
        self.textColor = UIColor.colorWithHexStr("585867")
    }
}

// MARK:- 常用小标题偏灰色
class MCSubTitleGrayLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.PingFangRegular(12)
        self.textColor = UIColor.textDrakHexColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 常用小标偏黑色
class MCSubTitleBlackLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.PingFangRegular(16)
        self.textColor = UIColor.textDrakHexColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 常用按钮
class MCSenderButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        
        self.titleLabel!.textAlignment = .center
        self.titleLabel!.font = UIFont.PingFangRegular(16)
        self.setTitleColor(.backGroundWhiteColor(), for: .normal)
        
//        self.setBackgroundImage(R.image.icon_rectangle_normal(), for: .normal)
//        self.setBackgroundImage(R.image.icon_rectangle_disable(), for: .disabled)
        self.setTitleColor(.backGroundWhiteColor(), for: .normal)
        self.setTitleColor(.btnDisableTitleColor(), for: .disabled)
        
        self.titleEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: 0, right: 0)
    }
}

// MARK:- 常用标题按钮
class MCTitleButton: UIButton {
    
    var title: String = "" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
    var textFont: UIFont = UIFont.PingFangRegular(16) {
        didSet {
            self.titleLabel?.font = textFont
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        
        self.titleLabel!.textAlignment = .center
        self.titleLabel!.font = UIFont.PingFangRegular(16)
        self.setTitleColor(.colorWithHexStr("585867"), for: .normal)
    }
}

// MARK:- 纯文本输入

class MCPlainTextView: UIView {
    
    /// 是否密文输入
    var isSecureText: Bool? {
        didSet {
            textField.isSecureTextEntry = isSecureText!
        }
    }
    
    /// 是否隐藏眼睛
    var isHideEye: Bool = false {
        didSet {
            self.eyeButton.isHidden = isHideEye
        }
    }
    
    /// 标题
    var title: String? {
        didSet {
            guard title?.length ?? 0 > 0 else {
                return
            }
            
            titleLabel.text = title
        }
    }
    
    /// 输入框占位文字
    var placeholder: String = "" {
        didSet {
            guard placeholder.length > 0 else {
                return
            }
            
            textField.placeholder = placeholder
        }
    }
    
    lazy var lineView   = UIView()
    lazy var titleLabel = UILabel()
    lazy var textField  = UITextField()
    lazy var eyeButton  = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
        makeLayout()
    }
    
    func makeUI() {
        
        titleLabel.textColor = .textLightHexColor()
        titleLabel.font = UIFont.PingFangRegular(13)
        addSubview(titleLabel)
        
        //eyeButton.setImage(R.image.icon_eye_show(), for: .normal)
        //eyeButton.setImage(R.image.icon_eye_hide(), for: .selected)
        eyeButton.addTarget(self, action: #selector(eyeChangedEvent(_:)), for: .touchUpInside)
        addSubview(eyeButton)
        
        textField.isSecureTextEntry = false
        textField.textColor = .colorWithHexStr("585867")
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.PingFangRegular(16)
        addSubview(textField)
        
        lineView.backgroundColor = .boardLineColor()
        addSubview(lineView)
    }
    
    func makeLayout() {
        
        titleLabel.snp.makeConstraints{ make -> Void in
            make.top.equalToSuperview()
            make.left.equalTo(self).offset(7)
            make.height.equalTo(18)
        }
        
        eyeButton.snp.makeConstraints{ make -> Void in
            make.bottom.equalToSuperview().offset(-17)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(20)
            make.height.equalTo(13)
        }
        
        textField.snp.makeConstraints{ make -> Void in
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalTo(eyeButton.snp.left).offset(-marginX)
            make.left.equalTo(titleLabel)
            make.height.equalTo(textFieldH)
        }
        
        lineView.snp.makeConstraints{ make -> Void in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(lineHeight)
        }
    }
    
    @objc func eyeChangedEvent(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        eyeButton.isSelected = button.isSelected
        textField.isSecureTextEntry = button.isSelected
    }
}

// MARK:- 密码文本输入+内容校验
class MCPwdCheckTextView: UIView {
    
    /// 是否密文输入
    var isSecureText: Bool? {
        didSet {
            textField.isSecureTextEntry = isSecureText!
        }
    }
    
    /// 输入框占位文字
    var placeholder: String = "" {
        didSet {
            guard placeholder.length > 0 else {
                return
            }
            
            textField.placeholder = placeholder
        }
    }
    
    /// 校验密码是否正确
    var isCorrect: Bool? {
        didSet {
            checkInfoView.isHidden = !isCorrect!
        }
    }
    
    lazy var lineView = UIView()
    lazy var textField = UITextField()
    lazy var checkInfoView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
        makeLayout()
    }
    
    func makeUI() {
        
        //checkInfoView.image = R.image.icon_pwd_check()
        checkInfoView.isHidden = true //默认隐藏
        addSubview(checkInfoView)

        textField.textColor = .colorWithHexStr("585867")
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.PingFangRegular(16)
        addSubview(textField)
        
        lineView.backgroundColor = .boardLineColor()
        addSubview(lineView)
    }
    
    func makeLayout() {
        
        textField.snp.makeConstraints{ make -> Void in
            make.left.equalTo(self).offset(12)
            make.height.equalTo(textFieldH)
            make.bottom.equalTo(self.snp_bottom).offset(-6)
            make.right.equalTo(checkInfoView.snp.left).offset(-marginX)
        }
        
        checkInfoView.snp.makeConstraints{ make -> Void in
            make.centerY.equalTo(textField)
            make.right.equalTo(-marginX)
            make.width.equalTo(15)
            make.height.equalTo(12)
        }
        
        lineView.snp.makeConstraints{ make -> Void in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(lineHeight)
        }
    }
}


// MARK:- 手机号码选择输入
class MCAreaCodeTxView: UIView {
    
    /// 是否密文输入
    var isSecureText: Bool? {
        didSet {
            textField.isSecureTextEntry = isSecureText!
        }
    }
    
    /// 标题
    var title: String? {
        didSet {
            guard title?.length ?? 0 > 0 else {
                return
            }
            
            titleLabel.text = title
        }
    }
    
    /// 输入框占位文字
    var placeholder: String = "" {
        didSet {
            guard placeholder.length > 0 else {
                return
            }
            
            textField.placeholder = placeholder
        }
    }
    
    
    lazy var lineView = UIView()
    lazy var marginView = UIView()
    lazy var titleLabel = UILabel()
    lazy var textField = UITextField()
    lazy var areaCodeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
        makeLayout()
    }
    
    func makeUI() {
        
        titleLabel = UILabel()
        titleLabel.textColor = .colorWithHexStr("585867")
        titleLabel.font = UIFont.PingFangRegular(13)
        addSubview(titleLabel)
        
        textField = UITextField()
        textField.textColor = .colorWithHexStr("585867")
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.PingFangRegular(16)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        addSubview(textField)
        
        marginView = UIView()
        marginView.backgroundColor = .boardLineColor()
        addSubview(marginView)
        
        areaCodeButton = UIButton.init()
        areaCodeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -45, bottom: 0, right: 0)
        areaCodeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        areaCodeButton.setTitle("+86", for: .normal)
        areaCodeButton.titleLabel?.font = UIFont.PingFangRegular(16)
        //areaCodeButton.setImage(R.image.icon_shevron_down(), for: .normal)
        areaCodeButton.setTitleColor(.colorWithHexStr("585867"), for: .normal)
        addSubview(areaCodeButton)
        
        lineView = UIView()
        lineView.backgroundColor = .boardLineColor()
        addSubview(lineView)
    }
    
    func makeLayout() {
        
        titleLabel.snp.makeConstraints{ make -> Void in
            make.top.equalToSuperview()
            make.left.equalTo(self).offset(7)
            make.height.equalTo(18)
        }

        areaCodeButton.snp.makeConstraints{ make -> Void in
            make.bottom.equalTo(self.snp.bottom).offset(-12)
            make.left.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
        marginView.snp.makeConstraints{ make -> Void in
            make.left.equalTo(areaCodeButton.snp.right)
            make.centerY.equalTo(areaCodeButton)
            make.width.equalTo(1)
            make.height.equalTo(19)
        }
        
        textField.snp.makeConstraints{ make -> Void in
            make.centerY.equalTo(areaCodeButton)
            make.left.equalTo(marginView).offset(10)
            make.right.equalToSuperview().offset(-marginX)
            make.height.equalTo(textFieldH)
        }
        
        lineView.snp.makeConstraints{ make -> Void in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(lineHeight)
        }
    }
}


// MARK:- 带有短信验证码获取
class MCSendCodeTxView: UIView {
    
    /// 是否密文输入
    var isSecureText: Bool? {
        didSet {
            textField.isSecureTextEntry = isSecureText!
        }
    }
    
    /// 标题
    var title: String? {
        didSet {
            guard title?.length ?? 0 > 0 else {
                return
            }
            
            titleLabel.text = title
        }
    }
    
    /// 输入框占位文字
    var placeholder: String = "" {
        didSet {
            guard placeholder.length > 0 else {
                return
            }
            
            textField.placeholder = placeholder
        }
    }
    
    lazy var lineView   = UIView()
    lazy var marginView = UIView()
    lazy var titleLabel = UILabel()
    lazy var textField  = UITextField()
    lazy var sendButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
        makeLayout()
    }
    
    func makeUI() {
        
        titleLabel.textColor = .colorWithHexStr("585867")
        titleLabel.font = UIFont.PingFangRegular(13)
        addSubview(titleLabel)
        
        sendButton.setTitle("获取验证码", for: .normal)
        sendButton.titleLabel?.font = UIFont.PingFangRegular(15)
        sendButton.setTitleColor(.colorWithHexStr("585867"), for: .normal)
        //sendButton.setBackgroundImage(R.image.icon_rectangle_normal_small(), for: .normal)
        //sendButton.setBackgroundImage(R.image.icon_rectangle_disable_small(), for: .disabled)
        sendButton.titleLabel?.textAlignment = .right
        sendButton.contentHorizontalAlignment = .right
        addSubview(sendButton)
        
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        textField.textColor = .colorWithHexStr("585867")
        textField.font = UIFont.PingFangRegular(16)
        addSubview(textField)
        
        marginView.backgroundColor = .boardLineColor()
        addSubview(marginView)
        
        lineView.backgroundColor = .boardLineColor()
        addSubview(lineView)
    }
    
    func makeLayout() {
        
        titleLabel.snp.makeConstraints{ make -> Void in
            make.top.equalToSuperview()
            make.left.equalTo(self).offset(7)
            make.height.equalTo(18)
        }
        
        sendButton.snp.makeConstraints{ make -> Void in
            make.bottom.equalTo(self.snp_bottom).offset(-12)
            make.height.equalTo(30)
            make.right.equalTo(self).offset(-marginX)
            make.width.equalTo(80)
        }
        
        marginView.snp.makeConstraints{ make -> Void in
            make.right.equalTo(sendButton.snp_left).offset(-marginX)
            make.centerY.equalTo(sendButton)
            make.height.equalTo(18)
            make.width.equalTo(1)
        }
        
        textField.snp.makeConstraints{ make -> Void in
            make.right.equalTo(marginView.snp.left).offset(-marginX)
            make.left.equalTo(titleLabel)
            make.centerY.equalTo(sendButton)
            make.height.equalTo(textFieldH)
        }
        
        lineView.snp.makeConstraints{ make -> Void in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(lineHeight)
        }        
    }
}


// MARK:- 登录&注册主页背景

class MCBackdropHeaderView: UIView {
    
    var image: UIImage = UIImage(named: "icon_header_backdrop")! {
        didSet {
            imageView.image = image
        }
    }
    
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        self.backgroundColor = UIColor.backGroundWhiteColor()
        
        imageView.image = UIImage(named: "icon_header_backdrop")
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }
    }
}

class MCBackdropFooterView: UIView {
    
    var image: UIImage = UIImage(named: "icon_footer_backdrop")! {
        didSet {
            imageView.image = image
        }
    }
    
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        self.backgroundColor = UIColor.backGroundWhiteColor()
        
        imageView.image = UIImage(named: "icon_footer_backdrop")
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }
    }
}

