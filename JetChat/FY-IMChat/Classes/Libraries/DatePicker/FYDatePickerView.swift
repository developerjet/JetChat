//
//  FYDatePickerView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/4/24.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import SwiftTheme

class FYDatePickerView: UIView {
    
    let kButtonX: CGFloat = 14
    let kButtonW: CGFloat = 100
    let kButtonH: CGFloat = 40
    let kContentH: CGFloat = 230
    
    // MARK:- lazy var
    
    var dateSelectedClosure : ((String)->Void)?
    
    /// 是否点击全屏关闭
    var isScreenClose: Bool = false {
        didSet {
            if isScreenClose == true {
                self.maskWindow.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    /// 自定义时间显示格式
    var formatter: String = "yyyy/MM/dd" {
        didSet {
            if formatter.isEmpty == false {
                self.dateFormatter.dateFormat = formatter
            }
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = self.formatter
        formatter.locale = Locale.current
        return formatter
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    lazy var maskWindow: UIView = {
        let maskView = UIView(frame: self.bounds)
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.49)
        maskView.isUserInteractionEnabled = true
        maskView.alpha = 0.0
        return maskView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: kContentH))
        view.theme_backgroundColor = "Global.backgroundColor"
        return view
    }()
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: kButtonX, y: 0, width: kButtonW, height: kButtonH)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.PingFangRegular(16)
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: self.contentView.width - kButtonW - kButtonX, y: 0, width: kButtonW, height: kButtonH)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.PingFangRegular(16)
        button.titleLabel?.textAlignment = .right
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(finished), for: .touchUpInside)
        return button
    }()
    
    lazy var datePicker: UIDatePicker = {
        let y: CGFloat = self.confirmBtn.maxY
        let h: CGFloat = self.contentView.height - y
        let picker = UIDatePicker(frame: CGRect(x: 0, y: y, width: kScreenW, height: h))
        let minDate = Date(timeIntervalSince1970: 60 * 60)
        let maxDate = Date(timeIntervalSinceNow: 60 * 60)
        picker.locale = Locale(identifier: "zh-Hans") //默认中文
        picker.datePickerMode = .date
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        picker.theme_tintColor = "Global.textColor"
        picker.textColor = AppThemes.lastSetedTheme() == .light ? .black : .white
        return picker
    }()
    
    
    // MARK:- Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        
        makeUI()
    }
    
    func makeUI() {
        addSubview(maskWindow)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(confirmBtn)
        contentView.addSubview(datePicker)
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FYDatePickerView {
    
    /// 传入日期选择到对应日期(默认格式：yyyy/MM/dd)
    ///
    /// - Parameter dateString: 日期
    func selectToDate(_ dateString: String) {
        if dateString.isEmpty == false {
            if let date = self.dateFormatter.date(from: dateString) {
                self.datePicker.setDate(date, animated: false)
            }
        }
    }
}

// MARK:- Action

extension FYDatePickerView {
    
    @objc func show() {
        maskWindow.alpha = 1.0
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            let y: CGFloat = kScreenH - self.kContentH
            self.contentView.frame = CGRect(x: 0, y: y, width: kScreenW, height: self.kContentH)
        }
    }
    
    @objc func showAddInView(_ view: UIView) {
        maskWindow.alpha = 1.0
        view.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            let y: CGFloat = kScreenH - self.kContentH
            self.contentView.frame = CGRect(x: 0, y: y, width: kScreenW, height: self.kContentH)
        }
    }
    
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            self.contentView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: self.kContentH)
        }) { (finished) -> Void in
            self.maskWindow.alpha  = 0.0
            self.contentView.alpha = 0.0
            self.removeFromSuperview()
        }
    }
    
    @objc func finished() {
        dismiss()
        
        if (dateSelectedClosure != nil) {
            let dateString = dateFormatter.string(from: datePicker.date)
            dateSelectedClosure!(dateString)
        }
    }
}
