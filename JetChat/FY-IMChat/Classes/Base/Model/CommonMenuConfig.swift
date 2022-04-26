//
//  CommonMenuConfig.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/2.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import HandyJSON

class CommonMenuConfig: NSObject, HandyJSON {
    var title: String?
    var subtitle: String?
    var image: String?
    var isShow: Bool = false
    
    var targetVC: UIViewController?
    
    init(title: String? = "", subtitle: String? = "", image : String? = "", isShow: Bool = false, targetVC: UIViewController? = nil) {
        super.init()
        
        self.title = title
        self.subtitle = subtitle
        self.image = image
        
        self.isShow = isShow
        self.targetVC = targetVC
    }
    
    required override init() { }
}
