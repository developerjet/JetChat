//
//  WkHandlerMessage.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/3/18.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import HandyJSON

class WkHandlerMessage: HandyJSON, Codable {
    
    var id: String?
    var url: String?
    var type: String?
    var categoryId: String?
    
    required init() {}
}

