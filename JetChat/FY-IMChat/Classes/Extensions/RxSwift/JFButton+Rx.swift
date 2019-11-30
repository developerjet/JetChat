//
//  JFButton+Rx.swift
//  MK-MChain
//
//  Created by fisker.zhang on 2019/5/30.
//  Copyright © 2019 miku. All rights reserved.
//

import Foundation
import Kingfisher
import RxCocoa
import RxSwift

private var KJFButtonIndicator   = "KJFButtonIndicator"
private var KJFButtonCurrentText = "KJFButtonCurrentText"

extension Reactive where Base: UIButton {
    //是否秀菊花
    public var isShowIndicator: Binder<Bool>{
        return Binder(self.base, binding: { btn, active in
            if active{
                objc_setAssociatedObject(btn, &KJFButtonCurrentText, btn.currentTitle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                btn.setTitle("", for: .normal)
                btn.whiteIndicator.startAnimating()
                btn.isUserInteractionEnabled = false
            }
            else{
                btn.whiteIndicator.stopAnimating()
                if let title = objc_getAssociatedObject(btn, &KJFButtonCurrentText) as? String{
                    btn.setTitle(title, for: .normal)
                }
                btn.isUserInteractionEnabled = true
            }
        })
    }
}


public extension UIButton {
    var whiteIndicator : UIActivityIndicatorView{
        get {
            var indicator = objc_getAssociatedObject(self, &KJFButtonIndicator)
                as? UIActivityIndicatorView
            if indicator == nil {
                indicator = UIActivityIndicatorView(style: .white)
                indicator!.center = CGPoint(x: self.bounds.width / 2,
                                            y: self.bounds.height / 2)
                self.addSubview(indicator!)
                //indicator.startAnimating()
            }
            self.whiteIndicator = indicator!
            //c重新设置中心点
            indicator!.center = CGPoint(x: self.bounds.width / 2,
                                        y: self.bounds.height / 2)
            return indicator!
        }
        set {
            objc_setAssociatedObject(self, &KJFButtonIndicator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}



