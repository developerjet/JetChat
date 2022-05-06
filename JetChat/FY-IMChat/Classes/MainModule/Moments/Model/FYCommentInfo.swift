//
//  FYFYCommentInfo.swift
//  FY-JetChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit
import HandyJSON

class FYCommentInfo: HandyJSON {
    
    var user_id: Int = 0
    var person: String = ""
    var comment: String = ""
    var avatar_url: String = ""
    
    required init() { }
}

extension FYCommentInfo: Equatable {
    
    static func == (lhs: FYCommentInfo, rhs: FYCommentInfo) -> Bool {
        return (lhs.comment == rhs.comment) && (lhs.user_id == rhs.user_id)
    }
}
