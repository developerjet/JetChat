//
//  FYMomentHeaderRefresh.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 MacOsx. All rights reserved.
//

import UIKit
import MJRefresh

public let kHeaderHeight: CGFloat = 60

class FYMomentHeaderRefresh: MJRefreshHeader {
    
    lazy var rotateImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.ic_album_reflash())
        return imageView
    }()
    
    // MARK: - prepare
    
    override func prepare() {
        super.prepare()
        
        self.ignoredScrollViewContentInsetTop = -60
        self.mj_h = kHeaderHeight
        
        self.addSubview(rotateImageView)
        self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        self.rotateImageView.frame = CGRect(x: 30, y: 30, width: 30, height: 30)
    }
    
    // MARK: - scrollViewPanStateDidChange
    
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewPanStateDidChange(change)
        
        self.mj_y = -self.mj_h - self.ignoredScrollViewContentInsetTop;
        let scrollViewOffsetY: CGFloat = self.scrollView?.mj_offsetY ?? 0
        let pullingY: CGFloat = abs(scrollViewOffsetY + 64 +
                                     self.ignoredScrollViewContentInsetTop)
        
        if (pullingY >= kHeaderHeight) {
            let marginY: CGFloat = -kHeaderHeight - (pullingY - kHeaderHeight) -
            self.ignoredScrollViewContentInsetTop;
            
            self.mj_y = marginY ;
        }
        
        UIView.animate(withDuration: 1.5) {
            self.rotateImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2).concatenating(self.rotateImageView.transform)
        }
    }
    
    // MARK: - MJRefreshState
    
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                self.rotateImageView.isHidden = true
            case .pulling:
                self.rotateImageView.isHidden = false
            case .refreshing:
                self.rotateImageView.isHidden = false
            default:
                break
            }
        }
    }
}
