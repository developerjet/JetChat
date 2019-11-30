//
//  LWCommonClock.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/3/6.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class CountDownHandy: NSObject {

    /// 默认的短信验证码发送倒计时(60s)
    ///
    /// - Parameters:
    ///   - button: 按钮
    class func beginClockSMS(_ button: UIButton) {
        
        CountDownHandy().startClockWithButton(button, time: 120)
    }
    
    /// 多个按钮控制短信验证码发送倒计时(60s)
    ///
    /// - Parameters:
    ///   - button1: 按钮1
    ///   - button2: 按钮2
    class func setGreyClockSMS(_ button1: UIButton, button2: UIButton) {
        
        CountDownHandy().startGrayWithButton(button1, button2: button2, time: 60)
    }
    
    /// 短信验证码发送倒计时
    ///
    /// - Parameters:
    ///   - button: 按钮
    ///   - time: 总倒计时长
    class func beginClockTime(_ button: UIButton, time: Int) {
        guard time > 0 else {
            return
        }
        
        CountDownHandy().startClockWithButton(button, time: time)
    }
    
    
    /// 开始倒计时
    func startClockWithButton(_ button: UIButton, time: Int) {
        
        let oldDate = Date()
        var newTime = time
        
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {
            // 停止计时
            if newTime <= 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
                    button.isEnabled = true
                    //button.setTitle(Lca.c_register_create_send.rLocalized(), for: .normal)
                }
                return
            }
            else{
                let newDate = Date()
                let timeInterva = newDate.timeIntervalSince(oldDate)
                var calTime = time - Int(timeInterva)
                if calTime <= 0{
                    calTime = 0
                }
                DispatchQueue.main.async {
                    button.setTitle("\(calTime)s", for: .normal)
                    button.isEnabled = false
                }
                if calTime <= 1{
                    newTime = 1
                }
                newTime = newTime - 1
            }
        }
        
        /// 开启定时器
        codeTimer.activate()
    }
    
    /// 开始置灰色倒计时
    func startGrayWithButton(_ button1: UIButton, button2: UIButton, time: Int) {
        var newTime = time
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {
            newTime = newTime - 1
            DispatchQueue.main.async {
                button1.isEnabled = false
                button2.isEnabled = false
            }
            
            // 停止计时
            if newTime < 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
                    button1.isEnabled = true
                    button2.isEnabled = true
                    //button1.setTitle(Lca.c_register_create_send.rLocalized(), for: .normal)
                }
                return
            }
            
            DispatchQueue.main.async {
                
                button1.setTitle("\(newTime)s", for: .normal)
            }
        }
        
        /// 开启定时器
        codeTimer.activate()
    }
}
