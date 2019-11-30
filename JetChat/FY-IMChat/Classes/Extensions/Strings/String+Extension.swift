
//
//  String+Extension.swift
//  String+Extension
//
//  Created by TAN on 2017/10/18.
//  Copyright © 2019 development. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit


extension String {
    
    /// 截取第一个到第任意位置
    ///
    /// - Parameter end: 结束的位值
    /// - Returns: 截取后的字符串
    public func stringCut(end: Int) -> String{
        if !(end <= count) { return self }
        let sInde = index(startIndex, offsetBy: end)
        return String(self[..<sInde])
    }
    
    /// 截取任意位置到结束
    ///
    /// - Parameter end:
    /// - Returns: 截取后的字符串
    public func stringCutToEnd(star: Int) -> String {
        if !(star < count) { return "截取超出范围" }
        let sRang = index(startIndex, offsetBy: star)..<endIndex
        return String(self[sRang])
    }
    
    /// 截取最后几位
    ///
    /// - Parameter last:
    /// - Returns: 截取后的字符串
    public func stringCutLastEnd(last: Int) -> String {
        if !(last < count) { return "截取超出范围" }
        let sRang = index(endIndex, offsetBy: -last)..<endIndex
        return String(self[sRang])
    }
    
    /// 字符串任意位置插入
    ///
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locat: 插入的位置
    /// - Returns: 添加后的字符串
    public func stringInsert(content: String, locat: Int) -> String {
        if !(locat < count) { return "操作超出范围" }
        let str1 = stringCut(end: locat)
        let str2 = stringCutToEnd(star: locat)
        return str1 + content + str2
    }
    
    
    /// JSON字符串转字典
    ///
    /// - Parameter jsonString: json字符串
    /// - Returns: 转成后的字典
    func getDictionaryFromJSONString(_ jsonString: String) ->NSDictionary {
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    
    /// JSON字符串转数组
    ///
    /// - Parameter jsonString: json字符串
    /// - Returns: 转成后的数组
    func getArrayFromJSONString(jsonString:String) ->NSArray{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }
    
    
    /// 字典转成JSON字符串
    ///
    /// - Parameter dictionary: 字典
    /// - Returns: 转成后的字符串
    func getJSONStringFromDictionary(_ dictionary: NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data, encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    
    /// 数组转JSON字符串
    ///
    /// - Parameter array: 数组
    /// - Returns: 转成后的字符串
    func getJSONStringFromArray(array:NSArray) -> String {
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
        
        let data : Data = try! JSONSerialization.data(withJSONObject: array, options: []) as Data
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    /// 计算字符串的尺寸
    ///
    /// - Parameters:
    ///   - text: 字符串
    ///   - rectSize: 容器的尺寸
    ///   - fontSize: 字体
    /// - Returns: 尺寸
    ///
    public func getStringSize(rectSize: CGSize, fontSize: CGFloat) -> CGSize {
        let str: NSString = self as NSString
        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
    public func getStringSize(fontSize: CGFloat) -> CGSize {
        return self.getStringSize(rectSize: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), fontSize: fontSize)
    }
    
    /// 输入字符串 输出数组
    /// e.g  "qwert" -> ["q","w","e","r","t"]
    /// - Returns: ["q","w","e","r","t"]
    public func stringToArr() -> [String] {
        let num = count
        if !(num > 0) { return [""] }
        var arr: [String] = []
        for i in 0..<num {
            let tempStr: String = self[self.index(self.startIndex, offsetBy: i)].description
            arr.append(tempStr)
        }
        return arr
    }
    
    /// 字符串截取         3  6
    /// e.g let aaa = "abcdefghijklmnopqrstuvwxyz"  -> "cdef"
    /// - Parameters:
    ///   - start: 开始位置 3
    ///   - end: 结束位置 6
    /// - Returns: 截取后的字符串 "cdef"
    public func startToEnd(start: Int,end: Int) -> String {
        if !(end < count) || start > end { return "取值范围错误" }
        var tempStr: String = ""
        for i in start...end {
            let temp: String = self[self.index(self.startIndex, offsetBy: i - 1)].description
            tempStr += temp
        }
        return tempStr
    }
    
    /// 字符串修改部分为密文
    ///
    /// - Parameters:
    ///   - start: 开始位置
    ///   - end: 结束为止
    /// - Returns: 修改后的字符串
    func stringAddSecret(start: Int, end: Int) -> String{
        if !(end < count) || start > end { return "取值范围错误" }
        let startI = self.index(self.startIndex, offsetBy: start)
        
        let offset = count - start - end
        let endI = self.index(startI, offsetBy: offset)
        let secret = String.init(repeating: "*", count: offset)
        let string = self.replacingCharacters(in: startI..<endI, with: secret)
        return string
    }
    
    /// 字符URL格式化,中文路径encoding
    ///
    /// - Returns: 格式化的 url
    public func stringEncoding() -> String {
        let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return url!
    }
    
    /// 字符URL格式化,防止被转义
    ///
    /// - Returns: 格式化的 url
    public func stringEncod() -> String {
        let url = self.stringEncoding()
        let result = url.removingPercentEncoding ?? ""
        return result
    }
    
    /// 是否包含字符串
    public func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    /// 去除字符串中空格
    public func trimming() -> String {
        return self.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: CharacterSet.urlPathAllowed)
    }
    
    /// MD5加密1
    public func md51() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16) //16位加密
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    

    /// 限制设置为整数
    ///
    /// - Returns: 只返回整数的字符串
    func getDigits() -> String {
        return String(self.filter {
            if let value = $0.int, value >= 0 && value <= 9 {
                return true
            }
            return false
        })
    }
}

extension String {
    /// MD5加密
    var ios_md5 : String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: 16)
        
        return String(format: hash as String)
    }
}

extension NSString{
    ///修改字符串中数字样式
    @objc
    public func attributeNumber(_ fontsize :CGFloat,color:UIColor,hcolor:UIColor,B:Bool)-> NSMutableAttributedString{
       return (self as String).attributeNumber(fontsize, color: color, hcolor: hcolor, B: B)
    }
}

extension String {
    /// 删除字符串中Unicode.Cc/Cf字符,类似于\0这种
    public func stringByRemovingControlCharacters() -> String {
        let controlChars = CharacterSet.controlCharacters
        var range = self.rangeOfCharacter(from: controlChars)
        var mutable = self
        while let removeRange = range {
            mutable.removeSubrange(removeRange)
            range = mutable.rangeOfCharacter(from: controlChars)
        }
        return mutable
    }
    
    /// 修改字符串中数字样式,将其加粗,变黑,加大4个字号,同时修改行间距
    ///
    /// - Parameters:
    ///   - fontsize: 非数字字号
    ///   - color: 非数字颜色
    ///   - lineSpace: 行间距
    /// - Returns: 修改完成的AttributedString
    public func attributeNumber(BoldFontSize fontsize:CGFloat, color:UIColor,lineSpace:CGFloat?)->NSMutableAttributedString{
        let AttributedStr = NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: fontsize), .foregroundColor: color])
        for i in 0 ..< self.count {
            let char = self.utf8[self.index(self.startIndex, offsetBy: i)]
            if (char > 47 && char < 58) {
                AttributedStr.addAttribute(.foregroundColor, value: UIColor(red: 33 / 255.0, green: 34 / 255.0, blue: 35 / 255.0, alpha: 1), range: NSRange(location: i, length: 1))
                AttributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontsize + 4), range: NSRange(location: i, length: 1))
            }
        }
        if let space = lineSpace {
            let paragraphStyleT = NSMutableParagraphStyle()
            paragraphStyleT.lineSpacing = space
            AttributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyleT, range: NSMakeRange(0,self.count))
        }
        return AttributedStr
    }
    
    /// 给字符串中数字变样式
    ///
    /// - Parameters:
    ///   - fontsize: 字体大小
    ///   - color: 非数字颜色
    ///   - hcolor: 数字颜色
    ///   - B: 是否加粗变大
    /// - Returns: 修改完成字符串
    public func attributeNumber(_ fontsize :CGFloat,color:UIColor,hcolor:UIColor,B:Bool)-> NSMutableAttributedString{
        let AttributedStr = NSMutableAttributedString(string: self, attributes: [.font: UIFont.systemFont(ofSize: fontsize), .foregroundColor: color])
        for i in 0 ..< self.count {
            let char = self.utf8[self.index(self.startIndex, offsetBy: i)]
            if (char > 47 && char < 58) {
                AttributedStr.addAttribute(.foregroundColor, value: hcolor, range: NSRange(location: i, length: 1))
                if B {
                    AttributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontsize + 2), range: NSRange(location: i, length: 1))
                }
            }
        }
        return AttributedStr
    }
    
    
    /// 字符串修改行间距和字间距
    ///
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - wordSpace: 字间距
    /// - Returns: 修改完成字符串
    public func attributeChangeSpace(lineSpace:CGFloat, wordSpace:CGFloat) -> NSMutableAttributedString {

        let attributedString = NSMutableAttributedString.init(string: self, attributes: [NSAttributedString.Key.kern:wordSpace])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: self.count))
        return attributedString
    }

    
    /// 指定文本内容字体变色
    ///
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - allColor:的字体颜色
    ///   - changedColor: 需要改变的颜色
    ///   - normalContent: 不设置变色的文本
    ///   - richContent: 需设置变色的文本
    /// - Returns: 返回富文本
    public func attributeSpecified(_ font :UIFont, originalColor: UIColor, changedColor: UIColor, normalContent: String, richContent: String)-> NSMutableAttributedString{
        guard normalContent.length > 0, richContent.length > 0 else {
            return NSMutableAttributedString.init()
        }
        
        // 所有文本内容
        let allContent = normalContent
        let attributedStr = NSMutableAttributedString(string: allContent)
        
        let range1: NSRange = NSRange(location: (attributedStr.string as NSString).range(of: normalContent).location, length: (attributedStr.string as NSString).range(of: normalContent).length)
        
        let range2: NSRange = NSRange(location: (attributedStr.string as NSString).range(of: richContent).location, length: (attributedStr.string as NSString).range(of: richContent).length)
        
        attributedStr.addAttributes([NSAttributedString.Key.font: font,
                                     NSAttributedString.Key.foregroundColor : originalColor], range: range1)
        
        attributedStr.addAttributes([NSAttributedString.Key.font: font,
                                     NSAttributedString.Key.foregroundColor : changedColor], range: range2)
        
        return attributedStr;
    }
    
    
    /// 替换手机号中间四位
    ///
    /// - Returns: 替换后的值
    func replacePhone() -> String {
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        return self.replacingCharacters(in: range, with: "****")
    }
}

extension String {
    public var length: Int {
        ///更改成其他的影响含有emoji协议的签名
        return self.utf16.count
    }
    public var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    public var intValue: Int32 {
        return (self as NSString).intValue
    }
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    public var integerValue: Int {
        return (self as NSString).integerValue
    }
    public var longLongValue: Int64 {
        return (self as NSString).longLongValue
    }
    public var boolValue: Bool {
        return (self as NSString).boolValue
    }
}

public protocol URLConvertibleProtocol {
    var URLValue: URL? { get }
    var URLStringValue: String { get }
}

extension String: URLConvertibleProtocol {
    ///String转换成URL
    public var URLValue: URL? {
        if let URL = URL(string: self) {
            return URL
        }
        let set = CharacterSet()
            .union(.urlHostAllowed)
            .union(.urlPathAllowed)
            .union(.urlQueryAllowed)
            .union(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
    }
    public var URLStringValue: String {
        return self
    }
}

extension String{
    /**
     将当前字符串拼接到cache目录后面
     */
    public func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        return (path as NSString).appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到doc目录后面
     */
    public func docDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        return (path as NSString).appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到tmp目录后面
     */
    public func tmpDir() -> String{
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
}

extension String{
    ///判断String是否存在汉字
    public func isIncludeChineseIn() -> Bool {
        for (_, value) in self.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
}

// MARK:- 通用正则处理
extension String {
    
    // MARK:-  字符输入长度限制
    func trimAll(_ trim: String, rangeCount: Int) -> Bool {
        
        if (trim.lengthOfBytes(using: String.Encoding.utf8) == rangeCount) {
            printLog("输入限制为%d个字符")
            return false
        }else {
            return true
        }
    }
    
    // MARK: 用户名正则表达式
    func validateUserName() -> Bool {
        let phoneRegex = try? NSRegularExpression(pattern: "^[A-Za-z0-9]{3,20}$", options: NSRegularExpression.Options.caseInsensitive)
        return phoneRegex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.length)) != nil
    }
    
    // MARK: 手机号正则表达式
    func validateMobile() -> Bool {
        let phoneRegex = try? NSRegularExpression(pattern: "^1(3[0-9]|5[0-35-9]|8[02345-9]|70|77)\\d{8}$", options: NSRegularExpression.Options.caseInsensitive)
        return phoneRegex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.length)) != nil
    }
    
    // MARK:- 图形验证码正则表达式
    func validatePicture() -> Bool {
        let pictureCodeRegex: String = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{4}"
        let pictureCodeTest = NSPredicate(format: "SELF MATCHES", pictureCodeRegex)
        return pictureCodeTest.evaluate(with: self)
    }
    
    // MARK: 邮箱正则表达式
    func validateEmail() -> Bool {
        let emailRegex = try? NSRegularExpression(pattern: "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?", options: NSRegularExpression.Options.caseInsensitive)
        return emailRegex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.length)) != nil
    }
    
    // MARK: 密码正则表达式（6-16位密码且包含英文字母和数字组合，不能使用特殊字符）
    func validatePassword() -> Bool {
        let passwordRegex: String = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,16}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    
    // MARK: 邮政编码正则表达式（中国邮政编码为6位数字）
    func validateZipCode() -> Bool {// [1-9]\d{5}(?!\d)$
        let zipCodeRegex: String = "[1-9]\\d{5}(?!\\d)$"
        let zipCodeTest = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        return zipCodeTest.evaluate(with: self)
    }
    
    // MARK: 纯数字正则表达式
    func validateShouldNum() -> Bool {
        if self.length <= 0 {
            return false
        }
        let shouldNumRegex: String = "[0-9]*"
        let shouldNumTest = NSPredicate(format: "SELF MATCHES %@", shouldNumRegex)
        return shouldNumTest.evaluate(with: self)
    }
    
    // MARK: 身份证正则表达式
    func validIDCardNumber() -> Bool{
        do {
            let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length))
            
            return results.count > 0
            
        }catch {
            return false
        }
    }
}


// MARK:- 字符复制

extension String {
    
    /// 字符串复制
    public func stringGeneral() {
        guard self.length > 0 else {
            printLog("复制内容不能为空")
            return
        }
        
        UIPasteboard.general.string = self
        MBConfiguredHUD.showSuccess("复制成功")
    }

}


extension String {
    
    /// 拓展方法
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
}


extension String {
    static func randomCode(length:Int) -> String {
        let base = pow(10, length - 1) as NSDecimalNumber
        let max = (pow(10, length) - (base as Decimal) - 1) as NSDecimalNumber
        let code = String(Int(arc4random_uniform(UInt32(max.intValue))) + base.intValue)
        return code
    }
}


extension String {
    /// 是否包含空/空格字符
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}

extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}
