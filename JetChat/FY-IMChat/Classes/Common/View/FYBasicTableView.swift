//
//  FYBasicTableView.swift
//  FY-IMChat
//
//  Created by fisker.zhang on 2019/3/19.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit

class FYBasicTableView: UITableView {
    
    init() {
        super.init(frame: CGRect(), style: .plain)
        
        makeUI()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        self.estimatedRowHeight = 50
        self.rowHeight = UITableView.automaticDimension
        self.backgroundColor = UIColor.backGroundWhiteColor()
        self.cellLayoutMarginsFollowReadableWidth = false
        self.keyboardDismissMode = .onDrag
        self.separatorInset = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)
        self.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
    }
}
