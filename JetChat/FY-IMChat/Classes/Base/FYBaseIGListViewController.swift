//
//  FYBaseIGListViewController.swift
//  FY-JetChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit
import IGListKit
import IGListDiffKit

class FYBaseIGListViewController: UIViewController {

    // MARK: - lazy var
    
    var objects: [ListDiffable] = [ListDiffable]()
    
    /// 朋友圈-列表
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        return adapter
    }()

    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
        view.backgroundColor = UIColor.white
        
        self.fd_prefersNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.modalPresentationCapturesStatusBarAppearance = false
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        makeUI()
        createViewModel()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    // MARK: - 提供子类重写
    open func makeUI() { }
    open func createViewModel() { }
    open func bindViewModel() { }
}

// MARK: - <ListAdapterDataSource>

extension FYBaseIGListViewController : ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        // 无数据时collectionView的展示
        return nil
    }
}

extension Notification.Name {
    
    struct list {
        /// 发布通知
        static let publish = Notification.Name("list-publish")
        /// 删除通知
        static let delete = Notification.Name("list-delete")
        /// 定位通知
        static let location = Notification.Name("list-location")
        /// collectionview的评论列表定位到当前通知
        static let contentOffset = Notification.Name("list-contentOffset")
        /// 跳转通知
        static let push = Notification.Name("list-push")
        /// 打开URL通知
        static let openURL = Notification.Name("list-openURL")
    }
}


extension NSObject {
    /// 返回类名
    static var fy_className: String {
        get {
            let a = NSStringFromClass(self)
            let className = a.split(separator: ".").last
            return String(className!)
        }
    }
}


public extension UITableView {
    /// 获取当前`cell`实例
    func cell<T>(_ cellClass: T.Type, reuseIdentifier: String? = nil, fromNib: Bool = false) -> T where T : UITableViewCell {
        let identifier = reuseIdentifier ?? cellClass.fy_className
        var cell = dequeueReusableCell(withIdentifier: identifier) as? T
        if cell == nil {
            if fromNib {
                cell = Bundle.main.loadNibNamed(cellClass.fy_className, owner: self
                                                , options: nil)?.last as? T
            }else {
                cell = T(style: .default, reuseIdentifier: identifier)
            }
        }
        return cell!
    }
}

public extension UICollectionView {
    
    /// 获取当前`cell`实例
    func cell<T>(_ cellClass: T.Type, indexPath: IndexPath, reuseIdentifier: String? = nil, fromNib: Bool = false) -> T where T : UICollectionViewCell {
        let identifier = reuseIdentifier ?? cellClass.fy_className
        if fromNib {
            register(UINib(nibName: cellClass.fy_className, bundle: nil), forCellWithReuseIdentifier: identifier)
        }else {
            register(cellClass, forCellWithReuseIdentifier: identifier)
        }
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}

