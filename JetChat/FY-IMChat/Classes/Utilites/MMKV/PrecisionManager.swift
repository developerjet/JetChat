//
//  PrecisionManager.swift
//  FY-IMChat
//
//  Created by fisker.zhang on 2019/3/15.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit

class PrecisionManager: NSObject {
    
    static let manager = PrecisionManager()
    
    var precisionDict = [String:Int]()
    var suppoetDict = [String: Any]()

    func precisionFrom(_ type : String) -> Int {
        if let value = precisionDict[type]{
            return value
        }
        return 0
    }
    
    func precisionWithNumberDigits(_ value: NSNumber?, digits: Int = 0) -> String? {
        let v = value ?? 0.0
        return
            PrecisionMethod
                .separateNumberUseComma(with: v,
                                        withDigits: digits)
        
    }
    
    func precisionWithDoubleDigits(_ value:Double?, digits: Int = 0) -> String? {
        let v = value ?? 0.0
        return
            PrecisionMethod
                .separateNumberUseComma(with: NSNumber.init(value: v),
                                        withDigits: digits)
        
    }
    
    func precisionWithNumberNoCommaDigits(_ value: NSNumber?, digits: Int = 0) -> String? {
        let v = value ?? 0.0
        return
            PrecisionMethod.separateNumberNoComma(with: v, withDigits: digits)
    }
    
    func precisionWithDoubleNoCommaDigits(_ value:Double?, digits: Int = 0) -> String? {
        let v = value ?? 0.0
        return
            PrecisionMethod.separateNumberNoComma(with: NSNumber.init(value: v), withDigits: digits)
    }
    
    
    func precisionWithNumber(_ value:NSNumber?, type : String?) -> String? {
        let v = value ?? 0.0
        let s = type ?? ""
        return
            PrecisionMethod
                .separateNumberUseComma(with: v,
                                        withDigits: self.precisionFrom(s))

    }
    
    func precisionWithDouble(_ value:Double?, type : String?) -> String? {
        let v = value ?? 0.0
        let s = type ?? ""
        return
            PrecisionMethod
                .separateNumberUseComma(with: NSNumber.init(value: v),
                                        withDigits: self.precisionFrom(s))
        
    }
    
    
    func precisionToUSDWithNumber(_ value:NSNumber?) -> String? {
        let v = value ?? 0.0
        return
            PrecisionMethod
                .separateNumberUseComma(with: v,
                                        withDigits: 2)
        
    }
    
    func precisionToUSDWithDouble(_ value:Double?) -> String? {
        let v = value ?? 0.0
        return
            PrecisionMethod
                .separateNumberUseComma(with: NSNumber.init(value: v),
                                        withDigits: 2)
        
    }
    
    
    /// TextField 小数点精度处理（传精度）
    func precisionDotNum(_ precision: Int, range: NSRange, allText: String, replaceText: String) -> Bool {
        let newString = (allText as NSString).replacingCharacters(in: range, with: replaceText)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,\(precision)})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
    }
    
    override init() {}
}
