//
//  LWUserInfo.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/3/8.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import HandyJSON

class LWUserInfo: Codable, HandyJSON {
    
    var id: Int?
    var name: String = ""
    var fromLp: Bool = false //是否是旧的用户
    var emailAddress: String = ""
    var changeStatus: Bool = false
    var phone: LWPhone?
    
    var uid : String = ""
    var token: String = ""
    var username: String = ""
    var fullname: String = ""
    var ic: String = ""
    var email: String = ""
    var mobileno: String = ""
    var refUsername: String = ""
    var joined: String = ""
    var countryCode: String = ""
    
    //var announce : LWUserInfoAnnounce?
    
    required init() {}
}

class LWUserInfoAnnounce: Codable {
    var title: String = ""
    var announce: String = ""
}
