//
//  FYMoUserInfo.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 MacOsx. All rights reserved.
//

import UIKit
import HandyJSON
import IGListDiffKit

class FYMoUserInfo: HandyJSON {
    
    /// 用户个人id
    var user_id: Int = 0
    /// 顶部背景图片
    var background_url: String = ""
    /// 用户个人头像
    var avatar_url: String = ""
    /// 用户个人昵称
    var user_name: String = ""
    
    required init() { }
}

extension FYMoUserInfo: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return user_id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self === object else { return true }
        guard let object = object as? FYMoUserInfo else { return false }
        return user_id == object.user_id
    }
}

extension FYMoUserInfo: Equatable {
    
    static func == (lhs: FYMoUserInfo, rhs: FYMoUserInfo) -> Bool {
        return lhs.isEqual(toDiffableObject: rhs)
    }
}

