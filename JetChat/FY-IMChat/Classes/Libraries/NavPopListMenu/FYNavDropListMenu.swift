//
//  FYNavDropListMenu.swift
//  PopMenu
//
//  Created by iOS.Jet on 2019/2/20.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import SwiftTheme


/// 声明代理方法
protocol FYPopListMenuDelegate : Any {
    func menu(_ model: CommonMenuConfig, didSelectRowAt index: Int)
}

extension FYPopListMenuDelegate {
    func menu(_ model: CommonMenuConfig, didSelectRowAt index: Int) {}
}

class FYNavDropListMenu: UIView {
    
    let kMaxCount: CGFloat = 6
    let kRowHeight: CGFloat = 50
    let triangleHeight: CGFloat = 12
    
    var tableH: CGFloat = 0
    let tableW: CGFloat = 140
    
    let xSpace: CGFloat = 15
    var ySpace: CGFloat = kNavigaH + 1
    
    var didClosedClosure : (()->Void)?
    
    var didSelectedClosure : ((Int, CommonMenuConfig)->Void)?
    
    var dataSource: [CommonMenuConfig] = []
    
    /// 设置代理
    var delegate: FYPopListMenuDelegate?
    
    /// 尖角
    var triangleView: UIView?
    var triangleFrame: CGRect?
    
    // MARK:- var lazy
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        tap.numberOfTapsRequired = 1
        return tap
    }()

    lazy var menuMaskView: UIView = {
        let maskView = UIView.init()
        maskView.isUserInteractionEnabled = true
        maskView.addGestureRecognizer(tapGesture)
        maskView.backgroundColor = UIColor.clear
        maskView.alpha = 0
        return maskView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
        table.cornerRadius = 5
        table.estimatedRowHeight = 0
        table.rowHeight = kRowHeight
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        table.isScrollEnabled = dataSource.count > Int(kMaxCount)
        table.register(FYNavDropMenuCell.self, forCellReuseIdentifier: "kPopMenuCellIdentifier")
        return table
    }()
    
    lazy var contentView: UIView = {
        let content = UIView.init()
        content.backgroundColor = UIColor.clear
        content.makeLayerShadowCorner()
        content.alpha = 0
        return content
    }()
    
    
    // MARK:- Life cycle
    
    convenience init(dataSource: [CommonMenuConfig], ySpace: CGFloat = kNavigaH + 1) {
        self.init()
        self.ySpace = ySpace
        self.dataSource = dataSource
        
        makeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        makeUI()
    }
    
    func makeUI() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.clear
        guard dataSource.count > 0 else {
            return
        }
        
        self.menuMaskView.frame = self.bounds
        self.addSubview(menuMaskView)
        
        tableH = dataSource.count > Int(kMaxCount) ? kMaxCount : CGFloat(dataSource.count) * kRowHeight
        
        contentView.frame = CGRect(x: kScreenW - tableW - xSpace, y: ySpace, width: tableW, height: tableH + triangleHeight)
        addSubview(contentView)
        
        triangleFrame = CGRect(x: tableW - 25, y: 0, width: 16, height: triangleHeight)
        drawTriangleView()
        
        tableView.frame = CGRect(x: 0, y: triangleHeight, width: tableW, height: tableH)
        contentView.addSubview(tableView)
    }
    
    // 绘制三角形尖角
    func drawTriangleView() {
        if triangleView == nil {
            triangleView = UIView()
            triangleView?.alpha = 0.0
            triangleView?.theme_backgroundColor = "Global.backgroundColor"
            contentView.addSubview(triangleView!)
        }
        
        triangleFrame = CGRect(x: self.triangleFrame!.minX, y: triangleFrame!.minY, width: triangleFrame!.width, height: triangleFrame!.height)
        triangleView?.frame = triangleFrame!
        
        let shaperLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: triangleFrame!.width * 0.5, y: 0), transform: .identity)
        path.addLine(to: CGPoint(x: 0, y: triangleFrame!.height), transform: .identity)
        path.addLine(to: CGPoint(x: triangleFrame!.width, y: triangleFrame!.height), transform: .identity)
        shaperLayer.path = path
        
        triangleView?.layer.mask = shaperLayer
    }
}


// MARK:- Action

extension FYNavDropListMenu {
    
    func show() {
        self.contentView.alpha   = 1.0
        self.menuMaskView.alpha  = 1.0
        self.triangleView?.alpha = 1.0
        UIApplication.shared.keyWindow?.addSubview(self)
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = CFTimeInterval(0.2) //动画时间
        var values = [AnyHashable]()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.95, 0.95, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        self.contentView.layer.add(animation, forKey: nil)
    }
    
    @objc func dismiss(_ isAnimate: Bool = true) {
        // 关闭
        self.didClosedClosure?()
        
        self.contentView.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.triangleView?.alpha = 0
            self.menuMaskView.alpha  = 0
            self.contentView.alpha   = 0
            self.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
}

// MARK:- UITableViewDataSource && Delegate

extension FYNavDropListMenu: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kPopMenuCellIdentifier", for: indexPath) as! FYNavDropMenuCell
        if let model = dataSource[safe: indexPath.row] {
            cell.model = model
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            delegate?.menu(model, didSelectRowAt: indexPath.row)
            // block
            if didSelectedClosure != nil {
                didSelectedClosure?(indexPath.row, model)
            }
        }
        
        dismiss()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kRowHeight
    }
}

