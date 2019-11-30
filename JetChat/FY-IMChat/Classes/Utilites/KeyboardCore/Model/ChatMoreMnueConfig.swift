//
//  ChatMoreMnueConfig.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/18.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

enum ChatMoreMenuType: Int {
    case album = 1001
    case camera = 1002
    case video = 1003
    case location = 1004
    case voice = 1005
    case wallet = 1006
    case pay = 1007
    case friendcard = 1008
    case favorite = 1009
    case sight = 1010
}

class ChatMoreMnueConfig: NSObject {
    var title: String?
    var image: String?
    
    var type: ChatMoreMenuType?
    
    init(title: String, image: String, type: ChatMoreMenuType) {
        super.init()
        
        self.title = title
        self.image = image
        self.type = type
    }
    
    required override init() { }
}
