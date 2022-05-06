//
//  FYContactsInfoViewController.swift
//  FY-JetChat
//
//  Created by iOS.Jet on 2019/11/30.
//  Copyright © 2019 Jett. All rights reserved.
//

import UIKit

class FYContactsInfoViewController: FYBaseViewController {

    var chatModel: FYMessageChatModel? {
        didSet {
            guard let model = chatModel else {
                return
            }
            
            headerView.chatModel = model
            if model.chatType == 1 {
                dataSource = ["设置备注名".rLocalized()]
            }
            
            plainTabView.reloadData()
        }
    }
    
    // MARK: - var lazy
    
    var dataSource: [String] = []
    
    private lazy var headerView: FYContactsInfoView = {
        let view = FYContactsInfoView()
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V5 }
        view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 100)
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 100))
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V5 }
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发消息".rLocalized(), for: .normal)
        button.backgroundColor = .appThemeHexColor()
        button.radius = 7
        button.rxTapClosure { [weak self] in
            if let model = self?.chatModel {
                let chatVC = FYChatBaseViewController(chatModel: model)
                self?.navigationController?.pushViewController(chatVC)
            }
        }
        return button
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人信息".rLocalized()
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V10 }
    }
    
    override func makeUI() {
        super.makeUI()
        
        plainTabView.rowHeight = 50
        plainTabView.tableHeaderView = headerView
        plainTabView.tableFooterView = footerView
        
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
    
}


// MARK: - UITableViewDataSource && Delegate

extension FYContactsInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kContactsInfoCellIdentifier = "kContactsInfoCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: kContactsInfoCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kContactsInfoCellIdentifier)
            cell?.selectionStyle = .none
            cell?.textLabel?.text = dataSource[safe: indexPath.row]
            cell?.textLabel?.theme.textColor = themed { $0.FYColor_Main_TextColor_V1 }
            cell?.accessoryView = setupAccessory()
            cell?.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V5 }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = chatModel {
            let editVC = FYEditChatInfoViewController()
            editVC.chatModel = model
            navigationController?.pushViewController(editVC)
        }
    }
    
    private func setupAccessory() -> UIImageView {
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "icon_arrow_right")
        arrowView.sizeToFit()
        return arrowView
    }
}
