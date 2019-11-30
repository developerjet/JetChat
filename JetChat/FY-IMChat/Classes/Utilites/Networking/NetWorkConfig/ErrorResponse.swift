//
//  ErrorResponse.swift
//  MChainWallet
//
//  Created by fisker.zhang on 2019/2/26.
//  Copyright © 2019 Miku. All rights reserved.
//

import UIKit
import HandyJSON
import Foundation

enum ErrorResponseType{
    case System
    case Logic
}

struct ErrorResponse: HandyJSON {

    // 系统错误
    var timestamp: String?
    var status: String?
    var error: String?
    var message: String?
    var path: String?
    
    // 逻辑错误
    var code: String?
    var msg: String?
    var alertMsg: String?

    var type: ErrorResponseType?
    var data: Data?
}


// MARK:- Message

extension String {
    
    public static func getErrorMessage(code: String?, message: String? = "") -> String {
        guard let code = code else {
            //return Lca.tip_e_error_show.rLocalized()
            return ""
        }
        
        let path = LanguageManager.manager.selectedLanguage?.codePath() ?? ""
        if let dict = NSDictionary(contentsOfFile: path) {
            if let errorMessage = dict.object(forKey: code) as? String {
                return errorMessage
            }
        }
        
        //return "(\(code)) \(Lca.tip_e_error_show.rLocalized())\n\(message ?? "")"
        return "未知错误"
    }
}

