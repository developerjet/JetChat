//
//  SBVerificationCodeView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/7/12.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit

protocol FYVerifyCodeViewDelegate: class {
    
    func textChangedAtCode(_ codeView: FYVerificationCodeView, text: String)
}

class FYVerificationCodeView: UIView {
    
    /// 代理回调
    var delegate: FYVerifyCodeViewDelegate?
    
    /// 一堆框框的数组
    var textFieldArray = [UITextField]()
    
    /// 框框之间的间隔
    let text_margin: CGFloat = 10
    
    /// 框框的大小
    let text_width: CGFloat = 32
    
    /// 框框个数
    var maxNumber = 6
    
    // MARK:- life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func clearAllCode() {
        for textField in textFieldArray {
            textField.clear()
        }
        
        textFieldArray.first?.becomeFirstResponder()
    }
    
    fileprivate func makeUI(){
        
        self.isUserInteractionEnabled = true
        
        // 计算左间距
        let left_margin = (self.width - text_width * CGFloat(maxNumber) - CGFloat(maxNumber - 1) * text_margin) / 2
        
        // 创建多个TextFied
        for i in 0..<maxNumber{
            let frame = CGRect(x: left_margin + CGFloat(i)*text_width + CGFloat(i)*text_margin, y: 0, width: text_width, height: text_width)
            let textField = createTextField(frame: frame)
            textField.tag = i
            textFieldArray.append(textField)
            self.addSubview(textField)
        }
        
        if maxNumber < 1 {
            return
        }
        
        textFieldArray.first?.becomeFirstResponder()
    }
    
    private func createTextField(frame: CGRect)-> UITextField {
        let textField = UITextField(frame: frame)
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        textField.font = UIFont.PingFangRegular(15)
        textField.textColor = UIColor.textDrakHexColor()
        textField.delegate = self
        //textField.deleteDelegate = self
        addSubview(textField)
        return textField
    }
}

// MARK:- UITextFieldDelegate

extension FYVerificationCodeView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 获取对应数组下标
        let index = textField.tag
        textField.resignFirstResponder()
        
        var code = ""
        if index == maxNumber - 1 {
            textFieldArray[index].text = string
            // 拼接结果
            for currentTxField in textFieldArray {
                code += currentTxField.text ?? ""
            }
            
            self.didClickBackWard()
            return false
        }
        
        textFieldArray[index].text = string
        textFieldArray[index + 1].becomeFirstResponder()
        
        if code.length == maxNumber {
            return false
        }
        
        return true
    }
    
    /// 监听键盘删除键
    func didClickBackWard() {
        for index in 1..<self.maxNumber {
            if !textFieldArray[index].isFirstResponder {
                continue
            }
            
            textFieldArray[index].resignFirstResponder()
            textFieldArray[index-1].becomeFirstResponder()
            textFieldArray[index-1].text = ""
        }
    }
}
