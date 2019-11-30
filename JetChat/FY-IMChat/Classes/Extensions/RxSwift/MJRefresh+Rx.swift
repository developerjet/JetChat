//
//  MJRefresh+Rx.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/13.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import Foundation
import MJRefresh
import RxSwift
import RxCocoa

//对MJRefreshComponent增加rx扩展
extension Reactive where Base: MJRefreshComponent {
     
    /// 正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    /// 正在刷新
    var isRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isRefresh in
            if isRefresh {
                refresh.beginRefreshing()
            }
        }
    }
     
    /// 停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}
