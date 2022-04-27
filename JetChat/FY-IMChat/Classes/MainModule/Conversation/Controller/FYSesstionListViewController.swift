//
//  FYSesstionListViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/8/18.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit

private let kSessionsCellReuseIdentifier = "kSessionsCellReuseIdentifier"

class FYSesstionListViewController: FYBaseViewController {
    
    var dataSource: [FYMessageItem] = []
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("全部已读".rLocalized(), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.sizeToFit()
        button.rxTapClosure { [weak self] in
            self?.readAllAction()
        }
        return button
    }()
    
    lazy var menuList: [CommonMenuConfig] = {
        let items = [
            CommonMenuConfig(title: "发起单聊".rLocalized(), image: "ic_tabbar01_selected", isShow: true),
            CommonMenuConfig(title: "发起群聊".rLocalized(), image: "ic_tabbar02_selected", isShow: true),
            CommonMenuConfig(title: "添加朋友".rLocalized(), image: "ic_tabbar03_selected", isShow: true),
            CommonMenuConfig(title: "扫一扫".rLocalized(), image: "ic_tabbar04_selected", isShow: false)
        ]
        return items
    }()
    
    // MARK:- Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "会话".rLocalized();
        
        makeUI()
        reloadSesstionData()
        registerSessionNoti()
    }
    
    override func makeUI() {
        super.makeUI()
        
        let leftBarButtonItem = UIBarButtonItem(customView: clearButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(image: R.image.icon_more_add(), style: .done, target: self, action: #selector(showPopMenu))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        setupTableView()
    }
    
    private func registerSessionNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSesstionData), name: .kNeedRefreshSesstionList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSesstionData), name: .kNeedRefreshChatInfoList, object: nil)
    }
    
    func setupTableView() {
        plainTabView.register(FYConversationCell.self, forCellReuseIdentifier: kSessionsCellReuseIdentifier)
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
    
    @objc func showPopMenu() {
        let popView = FYNavDropListMenu(dataSource: menuList)
        popView.delegate = self
        popView.show()
    }
    
    @objc func readAllAction() {
        let lastSesstions = FYDBQueryHelper.shared.qureyFromLastSesstions()
        if lastSesstions.count > 0 {
            for item in lastSesstions {
                let chat = FYDBQueryHelper.shared.qureyFromChatId(item.chatId!)
                chat.unReadCount = 0
                FYDBQueryHelper.shared.updateFromChatModel(chat, uid: chat.uid!)
            }
            
            reloadSesstionData()
            MBHUD.showSuccess("已清除全部未读消息数".rLocalized())
        }
    }

    @objc private func reloadSesstionData() {
        dataSource = FYDBQueryHelper.shared.qureyFromLastSesstions()
        reloadTableView()
    }
    
    private func showSessionBadge() {
        var badgeValue: String? = nil
        let unReadCount = FYDBQueryHelper.shared.queryFromSesstionsUnReadCount()
        if unReadCount > 0 {
            badgeValue = unReadCount > 99 ? "99+" : "\(unReadCount)"
        }else {
            badgeValue = nil
        }
        self.tabBarItem.badgeValue = badgeValue
    }
    
    /// 清空角标
    private func clearCurrentBadge(_ user: FYMessageChatModel) {
        if FYDBQueryHelper.shared.queryFromSesstionsUnReadCount() > 0 {
            if let uid = user.uid {
                user.unReadCount = 0
                FYDBQueryHelper.shared.updateFromChatModel(user, uid: uid)
                reloadSesstionData()
            }
        }
    }
    
    /// 滚到底部
    private func scrollToBottom(_ animated: Bool = true) {
        if dataSource.count >= 1 {
            plainTabView.scrollToRow(at: IndexPath(row: dataSource.count - 1, section: 0), at: .bottom, animated: animated)}
    }
    
    /// 刷新会话列表
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.plainTabView.reloadData()
            self.showSessionBadge()
        }
    }
}

// MARK: - FYPopListMenuDelegate

extension FYSesstionListViewController: FYPopListMenuDelegate {
    
    func menu(_ model: CommonMenuConfig, didSelectRowAt index: Int) {
        if index == 0 || index == 2 {
            UIViewController.currentViewController()?.tabBarController?.selectedIndex = 2
        }else if index == 1 {
            UIViewController.currentViewController()?.tabBarController?.selectedIndex = 1
        }else {
            let scanVC = ScanQRCodeViewController()
            navigationController?.pushViewController(scanVC)
        }
    }
    
    func showPicker() {
        
    }
    
    func webBrowser() {
        
    }
}


// MARK: - UITableViewDataSource && Delegate

extension FYSesstionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSessionsCellReuseIdentifier) as! FYConversationCell
        if let model = dataSource[safe: indexPath.row] {
            cell.model = model
        }
        clearButton.isHidden = FYDBQueryHelper.shared.queryFromSesstionsUnReadCount() <= 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            let user = FYDBQueryHelper.shared.qureyFromChatId(model.chatId!)
            let chatVC = FYChatBaseViewController(chatModel: user)
            navigationController?.pushViewController(chatVC, animated: true)
            // clear
            model.unReadCount = 0
            clearCurrentBadge(user)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            handleDeleteSesstionAtRow(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }

    /// 删除会话记录
    func handleDeleteSesstionAtRow(_ row: Int) {
        if let model = dataSource[safe: row] {
            dataSource.remove(at: row)
            plainTabView.deleteRows(at: [IndexPath.init(row: row, section: 0)], with: .left)
            if let chatId = model.chatId {
                // 清除记录
                FYDBQueryHelper.shared.deleteFromMesssageWithId(chatId)
                // 清除角标
                let user = FYDBQueryHelper.shared.qureyFromChatId(chatId)
                clearCurrentBadge(user)
                reloadSesstionData()
            }
        }
    }
}

