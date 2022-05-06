//
//  FYActionSheet.swift
//  FYActionSheet
//
//  Created by piggybear on 2017/10/2.
//  Copyright © 2017年 piggybear. All rights reserved.
//

import Foundation
import UIKit

class FYActionSheet: BottomPopupViewController {
    
    // MARK: - Setter
    
    var textFont: UIFont? {
        didSet {
            guard let font = textFont else {
                return
            }
            
            titleFont = font
            tableView.reloadData()
        }
    }
    
    var cancelTextFont: UIFont? {
        didSet {
            guard let font = textFont else {
                return
            }
            
            cancelBtn.titleLabel?.font = font
        }
    }
    
    var textColor: UIColor?
    
    var cancelTextColor: UIColor? {
        didSet {
            guard let titleColor = textColor else {
                return
            }
            
            cancelBtn.setTitleColor(titleColor, for: .normal)
        }
    }
    
    // MARK: - Private
    
    private let bottomSpace: CGFloat = 6
    private let cancelHeight: CGFloat = 44
    private let bottomSafeHeight: CGFloat = 34
    
    // MARK: - lazy var

    public var handler: ((_ index: Int)->Void)?
    
    private var titleFont: UIFont? = nil
    
    private var dataSource: [String] = []
    private var isShowCancel: Bool = true
    
    private var cellHeight: CGFloat {
        return 55
    }
    
    private var tableHeight: CGFloat {
        return CGFloat(dataSource.count) * cellHeight
    }
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: bottomSpace, width: kScreenW, height: cancelHeight)
        button.setTitle("取消".rLocalized(), for: .normal)
        button.titleLabel?.font = .PingFangRegular(14)
        button.theme.titleColor(from: themed { $0.FYColor_Main_TextColor_V2 }, for: .normal)
        button.addTarget(self, action: #selector(dissAction), for: .touchUpInside)
        button.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V12 }
        return button
    }()
    
    private lazy var footerBtnView: UIView = {
        let height = bottomSpace + cancelHeight
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: height))
        footerView.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V2 }
        footerView.addSubview(cancelBtn)
        return footerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: tableHeight))
        tableView.delegate = self
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V2 }
        tableView.register(cellWithClass: FYActionSheetCell.self)
        return tableView
    }()
    
    // MARK: - Life cycle
    
    required public init(isShowCancel: Bool = false, actionTitles: [String]) {
        self.dataSource = actionTitles
        self.isShowCancel = isShowCancel
        super.init(nibName: nil, bundle: nil)
        
        buildUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUI() {
        view.theme.backgroundColor = themed { $0.FYColor_BackgroundColor_V2 }
        if isShowCancel {
            tableView.tableFooterView = footerBtnView
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.reloadData()
    }
    
    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    override var popupHeight: CGFloat { makePopHeight() }
    
    override var popupTopCornerRadius: CGFloat { return 8 }
    
    override var popupPresentDuration: Double { return 0.25 }
    
    override var popupDismissDuration: Double { return 0.25 }
    
    override var popupShouldDismissInteractivelty: Bool { return false }
    
    override var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }
    
    private func makePopHeight() -> CGFloat {
        if isShowCancel {
            return tableHeight + footerBtnView.height + bottomSafeHeight
        }else {
            return tableHeight + bottomSafeHeight
        }
    }
    
    // MARK: - Action
    
    @objc func dissAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource && UITableViewDelegate

extension FYActionSheet: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FYActionSheetCell.self)
        if dataSource.count > indexPath.row {
            cell.textColor = textColor
            cell.titleFont = titleFont
            cell.title = dataSource[safe: indexPath.row]
            if indexPath.row == dataSource.count - 1 {
                cell.hideLine = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            handler?(indexPath.row)
        }
        
        dissAction()
    }
}


