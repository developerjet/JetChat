//
//  String+Date.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import Foundation
import SwiftDate

extension String {
    
    /// 通用时间 HH:mm MM-dd
    ///
    /// - Returns: 本地时间
    func commonDateString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("HH:mm MM-dd", locale: region.locale)
        return now
    }
    
    /// 日期时间 yyyy-MM-dd HH:mm:ss
    ///
    /// - Returns: 本地时间
    func allDateString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("yyyy-MM-dd HH:mm:ss", locale: region.locale)
        return now
    }
    
    /// 日期 yyyy-MM-dd
    ///
    /// - Returns: 本地时间
    func dateDayString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("yyyy-MM-dd", locale: region.locale)
        return now
    }
    
    /// 日期 yyyy.MM.dd
    ///
    /// - Returns: 本地时间
    func dotDateString() -> String? {
        let region = Region.current
        let update = self.toISODate(region: region)
        let date = update?.date.convertTo(region: region)
        let now = date?.toFormat("yyyy.MM.dd", locale: region.locale)
        return now
    }
    
    /**
     时间戳转为时间
     
     - returns: 时间字符串
     */
    func timeStampToString() -> String {
        let string = NSString(string: self)
        let timeSta: TimeInterval = string.doubleValue / 1000.0
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    /**
     时间戳转为NSDate
     
     - returns: NSDate
     */
    func timeStampToDate() -> Date {
        let string = NSString(string: self)
        let timeSta: TimeInterval = string.doubleValue
        let date = Date(timeIntervalSince1970: timeSta)
        return date
    }
    
    /**
     时间转为时间戳
     
     - returns: 时间戳字符串
     */
    func stringToTimeStamp() -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: self)
        let dateStamp: TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return String(dateSt)
    }
    
    
    /**
     时间戳处理(当前时间比较)
     
     - returns: 对比时间
     */
    func compareCurrentTime() -> String {
        let string = NSString(string: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeDate = formatter.date(from: string as String)
        let currentDate = Date()
        let timeInterval: TimeInterval = currentDate.timeIntervalSince(timeDate!)
        
        var temp: Double = 0
        var result = String()
        if (timeInterval/60 < 1) {
            result = "刚刚"
        }else if ((timeInterval/60)<60){
            temp = timeInterval/60
            result = String(format:"%ld分钟前", Int(temp))
            
        }else if ((timeInterval/60/60)<24){
            temp = timeInterval/60/60
            result = String(format:"%ld小时前", Int(temp))
            
        }else if ((timeInterval/60/60/24)<30){
            temp = timeInterval/60/60/24
            result = String(format:"%ld天前", Int(temp))
            
        }else if ((timeInterval/60/60/24/30)<12){
            temp = timeInterval/60/60/24/30
            result = String(format:"%ld月前", Int(temp))
            
        }else{
            temp = timeInterval/60/60/24/30/12;
            result = String(format:"%ld年前", Int(temp))
        }
        
        return result
    }
    
    
    /**
     传入cell文本内容，解析成元素为昵称的数组
     
     - returns: 昵称数组
     */
    func checkAtUserNickname() -> [String]? {
        do {
            let pattern = "@\\S*"
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length))
            
            var resultStrings = [String]()
            for result in results {
                resultStrings.append(String((self as NSString).substring(with: result.range)))
            }
            return resultStrings
        }
        catch {
            return nil
        }
    }
    
    
    func validNumber() -> Bool{
        do {
            let pattern = "^[0-9]*$"
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let results = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length))
            
            return results.count > 0
            
        }catch {
            return false
        }
        
    }
    
    
    /// 获取文本的最大高度
    func getTextMaxHeigh(_ font: UIFont, width:CGFloat) -> CGFloat {
        let normalText = NSString.init(string: self)
        let size = CGSize(width: width, height: 1000)
        let dic: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return stringSize.height
    }
    
    /// 获取文本的最大宽度
    func getTextMaxWidth(_ font: UIFont, height: CGFloat) -> CGFloat {
        let normalText = NSString.init(string: self)
        let size = CGSize(width: 1000, height: height)
        let dic:[NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font]
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        return stringSize.width
    }
}

// MARK: - 当前时间比较

extension String {
    
    func detailDate24Week(time: Double, format: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = format
        let timeInterval = TimeInterval(time / 1000.0)
        
        //获取到Date
        let confromTimeDate = Date.init(timeIntervalSince1970: timeInterval)
        var calender = NSCalendar.current
        let unitFlags = Set<Calendar.Component>([.year,.month,.day,.hour,.minute])
        
        let comp = calender.dateComponents(unitFlags, from: Date())
        _ = String(comp.year!)
        _ = String(comp.day!)
        
        let comp2 = calender.dateComponents(unitFlags, from: confromTimeDate)
        _ = String(comp2.year!)
        _ = String(comp2.month!)
        _ = String(comp2.day!)
        
        var hour = String(comp2.hour!)
        var minute = String(comp2.minute!)
        
        // 设置区域
        calender.locale = Locale.init(identifier: "zh_CN")
        // 设置时区
        /*
         设置时区，设置为 GMT+8，即北京时间(+8)
         */
        calender.timeZone = TimeZone.init(abbreviation: "EST")!
        calender.timeZone = TimeZone.init(secondsFromGMT: +28800)!
        // 设定每周的第一天从星期几开始
        /*
         1 代表星期日开始，2 代表星期一开始，以此类推。默认值是 1
         */
        calender.firstWeekday = 1
        
        //ordinalityOfUnit
        let timeWeek = calender.component(.weekOfYear, from: confromTimeDate)
        let systimeWeek = calender.component(.weekOfYear, from: Date.init())
        
        if calender.isDateInToday(confromTimeDate) {
            if hour.doubleValue < 10 {
                hour = "0\(hour)"
            }
            if minute.doubleValue < 10 {
                minute = "0\(minute)"
            }
            
            return "今天 \(hour):\(minute)"
            
        }else if calender.isDateInYesterday(confromTimeDate) {
            if hour.doubleValue < 10 {
                hour = "0\(hour)"
            }
            if minute.doubleValue < 10 {
                minute = "0\(minute)"
            }
            
            return "昨天 \(hour):\(minute)"
            
        }else if timeWeek == systimeWeek {
            let weeks = ["星期日", "星期一", "星期二","星期三","星期四","星期五","星期六"]
            let i = calender.ordinality(of: .weekday, in: .weekOfYear, for: confromTimeDate)
            //此处一定要记得减1
            return weeks[i!-1]
            
        }else {
            
            return self.getCurrentTime(timeNum: time, format: "MM-dd")
        }
        
    }
     
    //MARK: - 时间格式转换"YYYY-MM-dd HH:mm:ss"
    func getCurrentTime(timeNum:Double , format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = format
        let timeInterval = TimeInterval(timeNum / 1000.0)
        let confromTimesp = NSDate(timeIntervalSince1970:timeInterval)
        let confromTimespStr = formatter.string(from: confromTimesp as Date)
        return confromTimespStr
    }
}

