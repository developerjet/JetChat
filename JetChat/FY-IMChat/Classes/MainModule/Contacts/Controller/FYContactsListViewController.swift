//
//  FYContactsListViewController.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/8/18.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

private let kContactsCellReuseIdentifier = "kContactsCellReuseIdentifier"

class FYContactsListViewController: FYBaseViewController {

    // MARK: - lazy var
    
    var dataSource: [FYMessageChatModel] = []
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("删除所有好友".rLocalized(), for: .normal)
        button.theme.titleColor(from: themed { $0.FYColor_Main_TextColor_V11 }, for: .normal)
        button.titleLabel?.font = .PingFangRegular(16)
        button.sizeToFit()
        button.isHidden = true
        button.rxTapClosure { [weak self] in
            self?.showDeleteAlert()
        }
        return button
    }()
    
    // MARK: - life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        deleteButton.isHidden = dataSource.count > 0 ? false : true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "好友".rLocalized()
        
        reloadUserData()
        registerUsersNoti()
    }
    
    @objc private func reloadUserData() {
        dataSource = FYDBQueryHelper.shared.qureyFromChatsWithType(1)
        DispatchQueue.main.async {
            self.plainTabView.reloadData()
        }
    }
    
    private func registerUsersNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserData), name: .kNeedRefreshSesstionList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserData), name: .kNeedRefreshChatInfoList, object: nil)
    }
    
    override func makeUI() {
        super.makeUI()
        
        let leftBarButtonItem = UIBarButtonItem(customView: deleteButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "添加好友".rLocalized(), style: .plain, target: self, action: #selector(addUserData))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        plainTabView.register(FYContactsTableViewCell.self, forCellReuseIdentifier: kContactsCellReuseIdentifier)
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
    
    @objc private func showDeleteAlert() {
        EasyAlertView.customAlert(title: "确定删除全部好友吗？".rLocalized(), message: "删除后，会话记录也将清除".rLocalized(), confirm: "确定".rLocalized(), cancel: "取消".rLocalized(), vc: self, confirmBlock: {
            self.removerUserData()
        }, cancelBlock: {
            
        })
    }
    
    @objc private func addUserData() {
        var uid = 10000
        if let lastUser = dataSource.last {
            uid = lastUser.uid! + 1
        }
        
        let chat = FYMessageChatModel()
        chat.uid = uid
        chat.name = "用户名：" + "\(uid)"
        
        chat.avatar = "http://img.duoziwang.com/2019/02/04232036664241.jpg"
        chat.isShowName = true
        chat.chatType = 1 //单聊
        
        dataSource.append(chat)
        DispatchQueue.main.async {
            self.plainTabView.reloadData {
                self.scrollToBottom()
                FYDBQueryHelper.shared.insertFromChat(chat)
                self.deleteButton.isHidden = self.dataSource.count > 0 ? false : true
            }
        }
    }
    
    @objc private func removerUserData() {
        dataSource.removeAll()
        DispatchQueue.main.async {
            self.plainTabView.reloadData {
                self.scrollToBottom()
                FYDBQueryHelper.shared.deleteFromChatsWithType(1)
                FYDBQueryHelper.shared.deleteFromMessagesWithType(1)
                self.deleteButton.isHidden = self.dataSource.count > 0 ? false : true
                // 刷新会话列表
                NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
            }
        }
    }
    
    
    /// 滚到底部
    private func scrollToBottom(_ animated: Bool = true) {
        if dataSource.count >= 1 {
            plainTabView.scrollToRow(at: IndexPath(row: dataSource.count - 1, section: 0), at: .bottom, animated: animated)}
    }
}



// MARK: - UITableViewDataSource && Delegate

extension FYContactsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kContactsCellReuseIdentifier) as! FYContactsTableViewCell
        if let model = dataSource[safe: indexPath.row] {
            cell.model = model
            cell.didAvatarCallClosure = { [weak self] model in
                self?.pushChatInfo(model)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            let user = FYDBQueryHelper.shared.qureyFromChatId(model.uid!)
            let chatVC = FYChatBaseViewController(chatModel: user)
            navigationController?.pushViewController(chatVC, animated: true)
            // clear
            clearCurrentBadge(user)
        }
    }
    
    /// 清空角标
    private func clearCurrentBadge(_ user: FYMessageChatModel) {
        if FYDBQueryHelper.shared.queryFromSesstionsUnReadCount() > 0 {
            if let uid = user.uid {
                user.unReadCount = 0
                FYDBQueryHelper.shared.updateFromChatModel(user, uid: uid)
                // 刷新会话列表
                NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteChatFriend(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除".rLocalized()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    
    /// 删除好友
    @objc private func deleteChatFriend(_ row: Int) {
        EasyAlertView.customAlert(title: "确定删除该好友吗？".rLocalized(), message: "", confirm: "确定".rLocalized(), cancel: "取消".rLocalized(), vc: self, confirmBlock: {
            self.handleDeleteContactsAtRow(row)
        }, cancelBlock: {
            
        })
    }
    
    func handleDeleteContactsAtRow(_ row: Int) {
        if let model = dataSource[safe: row] {
            dataSource.remove(at: row)
            plainTabView.deleteRows(at: [IndexPath.init(row: row, section: 0)], with: .left)
            DispatchQueue.main.async {
                self.plainTabView.reloadData {
                    if let uid = model.uid {
                        FYDBQueryHelper.shared.deleteFromChatWithId(uid)
                        FYDBQueryHelper.shared.deleteFromMesssageWithId(uid)
                        // 刷新会话列表
                        NotificationCenter.default.post(name: .kNeedRefreshSesstionList, object: nil)
                    }
                }
            }
        }
        
        deleteButton.isHidden = dataSource.count > 0 ? false : true
    }
    
    func pushChatInfo(_ model: FYMessageChatModel) {
        let userModel = FYDBQueryHelper.shared.qureyFromChatId(model.uid!)
        let infoVC = FYContactsInfoViewController()
        infoVC.chatModel = userModel
        navigationController?.pushViewController(infoVC)
    }
}
