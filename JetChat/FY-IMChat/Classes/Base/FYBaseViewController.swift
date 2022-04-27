//
//  FYBaseViewController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//  业务基类

import UIKit
import HandyJSON
import SwiftyJSON
import RxSwift
import RxCocoa
import Moya


class FYBaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    let loadingTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    let isLoading = BehaviorRelay(value: false)

    /// 设置导航栏底线
    var hideNavShadowImage: Bool = false {
        didSet {
            if hideNavShadowImage == true {
                self.navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
    }
    
    
    /// 基类-普通列表
    public lazy var plainTabView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: self.view.height)
        let table = UITableView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.white
        table.delegate = self as? UITableViewDelegate
        table.dataSource = self as? UITableViewDataSource
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        return table
    }()
    
    /// 基类-分组列表
    public lazy var groupTabView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: self.view.height)
        let table = UITableView(frame: frame, style: .grouped)
        table.backgroundColor = UIColor.white
        table.delegate = self as? UITableViewDelegate
        table.dataSource = self as? UITableViewDataSource
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        return table
    }()
    
    // 解决push时界面卡住问题
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.navigationController?.viewControllers.first == self {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = false
        view.backgroundColor = UIColor.colorWithHexStr("F7F7F7")
        
        automaticallyAdjustsScrollViewInsets = false
        modalPresentationCapturesStatusBarAppearance = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    // MARK:- 提供子类重写
    open func makeUI() { }
    open func makeSubview() { }
    open func makeLayout() { }
    
    open func createViewModel() { }
    open func bindViewModel() { }
}

// MARK:- Action

extension FYBaseViewController {
    
    /// 基类方法 - 返回上一个控制器
    @objc func popLastVC() {
        if ((self.navigationController?.viewControllers) != nil) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 基类方法 - 返回根控制器
    @objc func popRootVC() {
        if ((self.navigationController?.viewControllers) != nil) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

