//
//  SPayPassWordView.swift
//  SPayPasswordView
//
//  Created by sss on 2017/4/21.
//  Copyright © 2017年 sss. All rights reserved.
//


import UIKit

protocol SPayPassWordViewDelegate : NSObjectProtocol{
    func entryComplete(password:String)
}

@IBDesignable  class SPayPassWordView: UIView {
    
    @IBInspectable var lenght:Int = 6 {
        didSet{
            updataUI()
        }
    }
    
    @IBInspectable var star: String = "●"
    
    @IBInspectable var isSecurity: Bool = true
    
    @IBInspectable var contentColor: UIColor = UIColor.white {
        didSet {
            squareArray.forEach { (label) in
                label.backgroundColor = contentColor
            }
        }
    }
    
    @IBInspectable var starColor: UIColor = UIColor.backGroundGrayColor() {
        didSet {
            squareArray.forEach { (label) in
                label.textColor = starColor
            }
        }
    }
    
    @IBInspectable var sBorderColor: UIColor = UIColor.black {
        didSet {
            squareArray.forEach { (label) in
                label.layer.borderColor = sBorderColor.cgColor
            }
        }
    }
    
    @IBInspectable var sBorderWidth: CGFloat = 1 {
        didSet {
            squareArray.forEach { (label) in
                label.layer.borderWidth = sBorderWidth
                label.layer.masksToBounds = sBorderWidth > 0
            }
            
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0 {
        didSet{
            squareArray.forEach { (label) in
                label.layer.cornerRadius = borderRadius
            }
        }
    }
    
    var side:       CGFloat!
    
    var password:   String = ""
    
    var squareArray = [UILabel]()
    
    var space:      CGFloat!
    
    var textField:  UITextField = UITextField()
    
    
    var tempArrat   = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updataUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updataUI()
    }
    
    weak var delegate: SPayPassWordViewDelegate?
    
    func updataUI(){
        
        for view in self.subviews{
            view.removeFromSuperview()
        }
        squareArray.removeAll()
        
        side  = self.frame.height
        space = (self.frame.width - (CGFloat(lenght) * side)) / CGFloat(lenght - 1)
        for index in 0..<lenght{
            let label = UILabel(frame: CGRect(x: (space + side) * CGFloat(index), y: 0, width: side, height: side))
            label.layer.masksToBounds = true
            label.textAlignment = .center
            label.layer.borderColor = UIColor.gray.cgColor
            label.layer.borderWidth = 1
            label.font = UIFont.PingFangRegular(13)
            squareArray.append(label)
        }
        for square in squareArray {
            self.addSubview(square)
        }
        
        textField.keyboardType = .numberPad
        textField.delegate = self
        self.addSubview(textField)
    }
    
    func clearText() {
        self.textField.text = ""
        password = ""
        squareArray.forEach { (label) in
            label.text = ""
        }
    }
    
    func input() {
        textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.becomeFirstResponder()
    }
    
    deinit {
        self.delegate = nil
    }
}

extension SPayPassWordView:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        password = ""
        squareArray.forEach { (label) in
            label.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        /// 处理删除逻辑
        if string == "" {
            if password == ""{/// 密码已经为空
                return true
            }else if password.count == 1{
                password = ""
            }else{
                password = String(password[..<password.index(password.endIndex, offsetBy: -1)])
            }
        }else{
            password += string
        }
        
        /// 填充密码框
        for index in 0..<squareArray.count{
            
            if index < password.count {
                
                if self.isSecurity{
                    squareArray[index].text = "●"
                }
                else{
                    squareArray[index].text = password.map(String.init)[index]
                }

            }else{
                squareArray[index].text = ""
            }
            
        }
        /// 完成输入
        if password.count >= lenght {
            //textField.resignFirstResponder = true
            textField.text = password
            self.delegate?.entryComplete(password: password)
            self.endEditing(true)
            return false
        }
        
        return true
    }
}
