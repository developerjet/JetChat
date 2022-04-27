//
//  FYMessageForwardViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/12/28.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit

enum ForwardStyle {
    case friend
    case grouped
}


class FYMessageForwardViewController: FYBaseViewController {

    // MARK: - var lazy
    
    /// 转发方式
    var forwardStyle = ForwardStyle.friend
    
    var dataSource: [FYMessageChatModel] = []
    
    var messageItem: FYMessageItem?
    
    private var selectedModel: FYMessageChatModel?
 
    lazy var forwardBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发送".rLocalized(), for: .normal)
        button.setTitleColor(.colorWithHexStr("FFFFFF"), for: .normal)
        button.sizeToFit()
        button.isHidden = true
        button.rxTapClosure { [weak self] in
            self?.forwardAction()
        }
        return button
    }()
    
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "消息转发".rLocalized()
        
        makeUI()
        loadChatBodyData(forwardStyle)
    }
    
    override func makeUI() {
        super.makeUI()
        
        let rightBarButtonItem = UIBarButtonItem(customView: self.forwardBtn)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        plainTabView.register(cellWithClass: FYContactsTableViewCell.self)
        view.addSubview(plainTabView)
        plainTabView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(self.view.snp.bottomMargin)
            }
        }
    }
    
    private func loadChatBodyData(_ style: ForwardStyle) {
        if (style == .friend) {
            dataSource = FYDBQueryHelper.shared.qureyFromChatsWithType(1)
        }else {
            dataSource = FYDBQueryHelper.shared.qureyFromChatsWithType(2)
        }
        
        plainTabView.reloadData()
    }
    
    // 开始转发
    private func forwardAction() {
        if let model = selectedModel {
            MBHUD.showStatus("正在发送...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if let message = self.messageItem {
                    // 须实例化新的对象（避免数据库插入新值失败）
                    let msgItem = FYMessageItem()
                    msgItem.message = message.message
                    msgItem.chatId = model.uid
                    msgItem.sendType = 0 //始终是发送方
                    msgItem.name = message.name
                    msgItem.avatar = message.avatar
                    msgItem.date = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
                    msgItem.msgType = message.msgType
                    msgItem.chatType = message.chatType
                    if (message.msgType == 2) {
                        msgItem.image = message.image
                    }else if (message.msgType == 3) {
                        msgItem.video = message.video
                        msgItem.image = message.image
                    }
                    
                    let chat = FYDBQueryHelper.shared.qureyFromChatId(model.uid!)
                    let chatVC = FYChatBaseViewController(chatModel: chat, isForward: true)
                    chatVC.forwardData = msgItem
                    
                    MBHUD.showSuccess("转发成功")
                    self.navigationController?.pushViewController(chatVC, completion: {
                        self.navigationController?.remove(withName: "FYMessageForwardViewController")
                    })
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource && Delegate

extension FYMessageForwardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FYContactsTableViewCell.self, for: indexPath)
        cell.selectedView.isHidden = false
        if let model = dataSource[safe: indexPath.row] {
            cell.model = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            selectedModel = model
            forwardBtn.isHidden = false
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}



