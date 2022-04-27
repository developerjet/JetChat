//
//  CSBottomPopupNavigationController.swift
//  ConsensusStorage
//
//  Created by Apple on 2021/10/25.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

@objcMembers class CSBottomPopupNavigationController: BottomPopupNavigationController {
    
    @objc var showHeight: CGFloat = 500
    @objc var topCornerRadius: CGFloat = 10
    @objc var presentDuration: Double = 0.25
    @objc var dismissDuration: Double = 0.25
    @objc var shouldDismissInteractivelty: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    override var popupHeight: CGFloat { return showHeight }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius }
    
    override var popupPresentDuration: Double { return presentDuration }
    
    override var popupDismissDuration: Double { return dismissDuration }
    
    override var popupShouldDismissInteractivelty: Bool { return true }
    
    override var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }
}
