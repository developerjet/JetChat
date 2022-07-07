//
//  BaseViewModel.swift
//  FY-JetChat
//
//  Created by Jett on 2019/3/15.
//  Copyright © 2019 Jett. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class BaseViewModel: NSObject {
    
    var page = 0
    var pageSize = 20
    
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    let error = ErrorTracker()
    
    override init() {
        super.init()
        
        error.asDriver().drive(onNext: { (error) in
            printLog("ViewModel error：\(error.localizedDescription)")
        }).disposed(by: rx.disposeBag)
    }
    
    deinit {
        print("\(type(of: self)):Deinited")
    }
}
