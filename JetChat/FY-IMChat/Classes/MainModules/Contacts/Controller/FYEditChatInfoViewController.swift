//
//  FYEditChatInfoViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/30.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class FYEditChatInfoViewController: FYBaseConfigViewController {
    
    var chatModel: FYMessageChatModel? {
        didSet {
            guard let model = chatModel else {
                return
            }
            
            if let nickName = model.nickName, nickName.length > 0 {
                myTextField.text = nickName
                saveButton.isHidden = false
            }
        }
    }
    
    // MARK: - var lazy
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("保存", for: .normal)
        button.theme_setTitleColor("Global.textColor", forState: .normal)
        button.isHidden = true
        button.sizeToFit()
        button.rxTapClosure { [weak self] in
            self?.editDidAction()
        }
        return button
    }()
    
    lazy var myTextField: UITextField = {
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.placeholder = "备注名称不超过12个字"
        textField.textColor = .black
        textField.leftView = leftView
        textField.delegate = self
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.font = .PingFangRegular(15)
        textField.cornerRadius = 5
        textField.borderColor = UIColor.boardLineColor()
        textField.borderWidth = 1
        return textField
    }()
    
    // MARK: - life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        myTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "修改备注名称"
        // Do any additional setup after loading the view.
        setupSubview()
    }
    
    func setupSubview() {
        
        let rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(myTextField)
        myTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kSafeAreaTop + 50)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
    }

}

// MARK: - UITextFieldDelegate

extension FYEditChatInfoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        saveButton.isHidden = string.count > 0 ? false : true
        if (range.length == 1 && string.count == 0)
        {
            return true
        }
        if range.location >= 12
        {
            return false
        }
        
        return true
    }
    
    @objc func editDidAction() {
        myTextField.resignFirstResponder()
        chatModel?.nickName = myTextField.text ?? ""
        if let model = chatModel, let uid = model.uid {
            MBHUD.showStatus("正在保存...")
            FYDBQueryHelper.shared.updateFromChatModel(model, uid: uid)
            
            NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
            NotificationCenter.default.post(name: .kNeedRefreshChatInfoList, object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                MBHUD.hide()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
