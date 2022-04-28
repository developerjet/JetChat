//
//  MomentLocationCell.swift
//  JetChat
//
//  Created by Jett on 2020/4/15.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation

class MomentLocationCell: UICollectionViewCell {
    
    var viewModel: FYMomentInfo?
    
    fileprivate lazy var locationBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame.origin = CGPoint(x: MomentHeaderCell.contentLeft, y: 0)
        btn.setTitleColor(UIColor.colorWithHexStr("7B7F8E"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    func makeUI() {
        addSubview(locationBtn)
    }
    
    @objc func click(_ btn: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.list.location, object: viewModel)
    }
}

extension MomentLocationCell: ListBindable {
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? FYMomentInfo else { return }
        self.viewModel = viewModel
        locationBtn.setTitle(viewModel.location, for: .normal)
        locationBtn.sizeToFit()
    }
}
