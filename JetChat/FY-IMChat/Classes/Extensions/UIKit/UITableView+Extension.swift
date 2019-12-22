//
//  UITableView+EmptyData.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/6/12.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation
import KafkaRefresh


extension UITableView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    /// 设置空页面时机，在第一个加载的时候
    func reloadDataBySetEmpty(vc: UIViewController) {
        if self.emptyDataSetSource == nil {
            self.emptyDataSetDelegate = vc as? DZNEmptyDataSetDelegate
            self.emptyDataSetSource = vc as? DZNEmptyDataSetSource
            self.reloadEmptyDataSet()
        }
    }
}

// MARK: - KafkaRefreshControl

extension UITableView {
    
    func bindHeaderRefreshHandler(_ beginRefresh: Bool = false, callback:(@escaping() -> ())) {
        self.bindHeadRefreshHandler({
            callback()
        }, themeColor: .scrollRefreshColor(), refreshStyle: .replicatorCircle)
        
        if beginRefresh {
            self.headRefreshControl.beginRefreshing()
        }
    }
    
    func bindFooterRefreshHandler(_ callback:(@escaping() -> ())) {
        self.bindFootRefreshHandler({
            callback()
        }, themeColor: .scrollRefreshColor(), refreshStyle: .native)
    }
}

public extension UITableView {
    
    func scrollToFirst(at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard numberOfSections > 0 else { return }
        guard numberOfRows(inSection: 0) > 0 else { return }
        let indexPath = IndexPath(item: 0, section: 0)
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func scrollToLast(at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard numberOfSections > 0 else { return }
        let lastSection = numberOfSections - 1
        guard numberOfRows(inSection: 0) > 0 else { return }
        let lastIndexPath = IndexPath(item: numberOfRows(inSection: lastSection)-1, section: lastSection)
        scrollToRow(at: lastIndexPath, at: scrollPosition, animated: animated)
    }
}

public extension UITableView {
    
    // MARK: - Cell register and reuse
    /**
     Register cell nib
     
     - parameter aClass: class
     */
    func fy_registerCellNib<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellReuseIdentifier: name)
    }
    
    /**
     Register cell class
     
     - parameter aClass: class
     */
    func fy_registerCellClass<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        self.register(aClass, forCellReuseIdentifier: name)
    }
    
    /**
     Reusable Cell
     
     - parameter aClass:    class
     
     - returns: cell
     */
    func fy_dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    // MARK: - HeaderFooter register and reuse
    /**
     Register cell nib
     
     - parameter aClass: class
     */
    func fy_registerHeaderFooterNib<T: UIView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: name)
    }
    
    /**
     Register cell class
     
     - parameter aClass: class
     */
    func fy_registerHeaderFooterClass<T: UIView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        self.register(aClass, forHeaderFooterViewReuseIdentifier: name)
    }
    
    /**
     Reusable Cell
     
     - parameter aClass:    class
     
     - returns: cell
     */
    func fy_dequeueReusableHeaderFooter<T: UIView>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}


