//
//  FYEditChatInfoViewController.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/30.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit
import RxSwift

class FYEditChatInfoViewController: FYBaseViewController {
    
    var chatModel: FYMessageChatModel? {
        didSet {
            guard let model = chatModel else {
                return
            }
            
            if let nickName = model.nickName {
                if !nickName.isBlank {
                    myTextField.text = nickName
                }
            }
        }
    }
    
    // MARK: - lazy var
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("保存".rLocalized(), for: .normal)
        button.theme.titleColor(from: themed { $0.FYColor_Main_TextColor_V11 }, for: .normal)
        button.titleLabel?.font = .PingFangRegular(16)
        button.isHidden = true
        button.sizeToFit()
        button.rxTapClosure { [weak self] in
            self?.saveEditing()
        }
        return button
    }()
    
    private lazy var myTextField: UITextField = {
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.placeholder = "备注名称不超过12个字".rLocalized()
        textField.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
        textField.leftView = leftView
        textField.delegate = self
        textField.leftViewMode = .always
        textField.theme.placeholderColor = themed { $0.FYColor_Placeholder_Color_V1 }
        textField.clearButtonMode = .whileEditing
        textField.font = .PingFangRegular(15)
        textField.cornerRadius = 5
        textField.layer.theme.borderColor = themed { $0.FYColor_BorderColor_V1.cgColor }
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
        
        navigationItem.title = "修改备注名称".rLocalized()
    }
    
    override func makeUI() {
        super.makeUI()
        
        let rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        myTextField.rx.text.orEmpty
        .map { $0.count == 0 }
        .share(replay: 1)
        .bind(to: saveButton.rx.isHidden)
        .disposed(by: rx.disposeBag)
        
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
    
    // MARK: - Action
    
    private func saveEditing() {
        myTextField.resignFirstResponder()
        chatModel?.nickName = myTextField.text ?? ""
        
        if let model = chatModel, let uid = model.uid {
            FYDBQueryHelper.shared.updateFromChatModel(model, uid: uid)
            
            let messages = FYDBQueryHelper.shared.qureyFromMessagesWithChatId(uid)
            for msgItem in messages {
                if msgItem.sendType == 1 {
                    if let message = FYDBQueryHelper.shared.queryMessageWithMsgId(msgItem.messageId!) {
                        message.nickName = myTextField.text ?? ""
                        FYDBQueryHelper.shared.updateMessageWithMsgId(message: message, messageId: message.messageId!)
                    }
                }
            }
            
            NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
            NotificationCenter.default.post(name: .kNeedRefreshChatInfoList, object: nil)
            
            MBHUD.showStatus("正在保存...".rLocalized())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                MBHUD.hide()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
