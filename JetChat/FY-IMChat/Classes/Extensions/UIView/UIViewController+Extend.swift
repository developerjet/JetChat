//
//  UIViewController+Extend.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/8/18.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation

extension UIViewController {
    
    /// Configuration back
    @objc func back(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    // Get currentController
    class func currentViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return currentViewController(controller: navigationController.visibleViewController)
        }
        if let tabBarController = controller as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return currentViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return currentViewController(controller: presented)
        }
        return controller
    }
}


extension UIViewController {
    
    /// 设置空页面时机(在第一个加载的时候)
    func reloadDataBySetEmpty(_ view: UIView) {
        if view.isKind(of: UITableView.self) {
            if let tableView = view as? UITableView {
                if tableView.emptyDataSetSource == nil {
                    tableView.emptyDataSetDelegate = self as? DZNEmptyDataSetDelegate
                    tableView.emptyDataSetSource = self as? DZNEmptyDataSetSource
                    tableView.reloadEmptyDataSet()
                }
            }
        }else if (view.isKind(of: UICollectionView.self)) {
            if let collectionView = view as? UICollectionView {
                if collectionView.emptyDataSetSource == nil {
                    collectionView.emptyDataSetDelegate = self as? DZNEmptyDataSetDelegate
                    collectionView.emptyDataSetSource = self as? DZNEmptyDataSetSource
                    collectionView.reloadEmptyDataSet()
                }
            }
        }
    }
}

