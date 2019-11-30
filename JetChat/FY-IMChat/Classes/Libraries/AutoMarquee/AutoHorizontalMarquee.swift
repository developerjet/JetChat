//
//  AutoHorizontalMarquee.swift
//  AutoHorizontalMarquee
//
//  Created by iOS.Jet on 2018/8/13.
//  Copyright © 2018年 iOS.Jet. All rights reserved.
//

import UIKit

enum AutoScrollStyle {
    case linked
    case grouped
}

/// 声明协议方法
protocol AutoMarqueeDelegate : class {
    func autoDidSelectIndex(view: AutoHorizontalMarquee, index: Int)
}

extension AutoMarqueeDelegate {
    func autoDidSelectIndex(view: AutoHorizontalMarquee, index: Int) {}
}

class AutoHorizontalMarquee: UIView {
    
    private let space: CGFloat = 10
    
    private var autoIndex: Int = 0
    private var isAutoScroll: Bool = false //是否已经滚动
    
    /// 数据加载样式
    var autoStyle: AutoScrollStyle = .linked
    
    /// 设置代理
    weak var delegate: AutoMarqueeDelegate?
    
    var image: UIImage = UIImage() {
        didSet {
            radioView.image = image
        }
    }
    
    var textFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            autoLabel.font = textFont
        }
    }
    
    var textColor: UIColor = .black {
        didSet {
            autoLabel.textColor = textColor
        }
    }
    
    var autoBackColor: UIColor = .white {
        didSet {
            leftView.backgroundColor = autoBackColor
            rightView.backgroundColor = autoBackColor
            autoBackView.backgroundColor = autoBackColor
        }
    }
    
    
    /// 定时器
    var timer: Timer?
    
    var textStringGroup: [String] = [String]() {
        didSet {
            guard textStringGroup.count != 0 else {
                return
            }
            
            // 如果已开启，先暂停定时器
            if isAutoScroll {
                stopTimer()
            }
            
            if autoStyle == .linked {
                reloadData(textStringGroup.joined(separator: "        "))
            }else {
                reloadData(textStringGroup.first!)
            }
            
            // 默认展示第一条
            autoLabel.frame.origin.x = ((autoLabel.superview?.frame.size.width)!)
            
            startTimer()
        }
    }

    
    // MARK:- Lazy var
    
    lazy var autoLabel: UILabel = {
        let autoLabel = UILabel.init(frame: autoBackView.bounds)
        autoLabel.font = UIFont.systemFont(ofSize: 14)
        autoLabel.textColor = UIColor.black
        return autoLabel
    }()

    lazy var autoBackView: UIImageView = {
        let h: CGFloat = self.frame.height
        let w: CGFloat = self.frame.width - space
        let backView = UIImageView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        backView.backgroundColor = UIColor.white
        backView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        backView.addGestureRecognizer(tap) //添加点按手势
        return backView
    }()
    
    /// 投影
    lazy var shadowView: UIImageView = {
        let w: CGFloat = 8
        let x: CGFloat = self.leftView.frame.size.width - w
        let y: CGFloat = (self.leftView.frame.size.height - 21) / 2
        let frame = CGRect(x: x, y: y, width: w, height: 21)
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "touying")
        return imageView
    }()
    
    /// 喇叭
    lazy var radioView: UIImageView = {
        let x: CGFloat = 15
        let w: CGFloat = 13
        let y: CGFloat = (leftView.frame.size.height - w) / 2
        let radio = UIImageView.init(frame: CGRect(x: x, y: y, width: w, height: w))
        radio.image = UIImage(named: "horn")
        return radio
    }()
    
    lazy var leftView: UIView = {
        let w: CGFloat = 45
        let view = UIView(frame: CGRect(x: 0, y: 0, width: w, height: self.autoBackView.height))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var rightView: UIView = {
        let w: CGFloat = self.space
        let x: CGFloat = self.width - w
        let view = UIView(frame: CGRect(x: x, y: 0, width: w, height: self.autoBackView.height))
        view.backgroundColor = UIColor.white
        return view
    }()

    // MARK:- Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        autoBackView.addSubview(autoLabel)
        addSubview(autoBackView)
        
        leftView.addSubview(radioView)
        leftView.addSubview(shadowView)
        addSubview(leftView)
        addSubview(rightView)
        autoBackView.bringSubviewToFront(leftView)
        autoBackView.bringSubviewToFront(rightView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.stopTimer()
    }
}

extension AutoHorizontalMarquee {
    
    func startTimer() {
        isAutoScroll = true
        
        timer = Timer(timeInterval: 0.015, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        timer?.fire() // 启动定时器
    }

    /// 开始滚动
    @objc func autoScroll() {
        // 匀速
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            let scaleX : CGFloat = 0.7
            self.autoLabel.maxX -= scaleX
        }, completion: nil)
        
        // 当前信息跑完时
        if (self.autoLabel.frame.maxX <= 0) {
            self.autoIndex += 1
            self.autoLabel.x = (self.autoLabel.superview?.frame.width)!
            
            // 更新内容
            if autoStyle == .linked {
                reloadData(textStringGroup.joined(separator: "        "))
            }else {
                reloadData(textStringGroup[autoIndex % (textStringGroup.count)])
            }
        }

    }
    
    func reloadData(_ text: String) {
        autoLabel.text = text
        autoLabel.sizeToFit()
        // setup center
        autoLabel.centerY = self.height * 0.5
    }
    
    
    func stopTimer() {
        if let nowTimer = timer {
            nowTimer.invalidate()
        }
    }
}

// MARK: - Action

extension AutoHorizontalMarquee {
    
    @objc func tapAction() {
        print("current Index \(autoIndex.description)")
        delegate?.autoDidSelectIndex(view: self, index: autoIndex)
    }
}

