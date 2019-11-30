//
//  LWPhone.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/3/8.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import HandyJSON

class LWPhone: Codable, HandyJSON {
    
    var countryCode: String = ""
    var nationalNumber: String = ""
    
    required init() { }
}
