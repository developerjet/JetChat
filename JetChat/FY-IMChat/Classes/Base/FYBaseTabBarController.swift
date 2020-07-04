//
//  FYBaseTabBarController.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/2/28.
//  Copyright © 2019 development. All rights reserved.
//

import UIKit
import SwiftTheme

class FYBaseTabBarController: UITabBarController {
    
    // MARK:- life cycle
    
    private var indexFlag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializes()
        setupChildVC()
    }
    
    // MARK:- initialize
    
    private func initializes() {
        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        
        //tabBar.theme_tintColor = "Global.barTextColor"
        tabBar.theme_barTintColor = "Global.tabBarBgColor"
        tabBar.theme_backgroundColor = "Global.tabBarBgColor"
        
        if #available(iOS 13, *) {
            let normalAttr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                              NSAttributedString.Key.foregroundColor : UIColor.tabBarTitleNormalColor()]
            let selectedAttr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                                NSAttributedString.Key.foregroundColor : UIColor.tabBarTitleSelectColor()]
            let appearance = UITabBarAppearance()
            let par = NSMutableParagraphStyle.init()
            par.alignment = .center
            
            let noraml = appearance.stackedLayoutAppearance.normal
            noraml.titleTextAttributes = normalAttr
            
            let selected = appearance.stackedLayoutAppearance.selected
            selected.titleTextAttributes = selectedAttr
            self.tabBar.standardAppearance = appearance
            
        }else {
            let normalAttr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                              NSAttributedString.Key.foregroundColor : UIColor.tabBarTitleNormalColor()]
            let selectedAttr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                                NSAttributedString.Key.foregroundColor : UIColor.tabBarTitleSelectColor()]
            
            let tabBarItem = UITabBarItem.appearance()
            tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
            tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        }
    }
    
    private func setupChildVC() {
        
        let vc1 = FYSesstionListViewController()
        let vc2 = FYChatRoomListViewController()
        let vc3 = FYContactsListViewController()
        let vc4 = FYMineViewController()
        
        createChildController(vc1,
                              title: "会话",
                              image: R.image.ic_tabbar01_normal(),
                              selectedImage: R.image.ic_tabbar01_selected())
        
        createChildController(vc2,
                              title: "群组",
                              image: R.image.ic_tabbar02_normal(),
                              selectedImage: R.image.ic_tabbar02_selected())
        
        createChildController(vc3,
                              title: "好友",
                              image: R.image.ic_tabbar03_normal(),
                              selectedImage: R.image.ic_tabbar03_selected())
        
        createChildController(vc4, title: "我",
                              image: R.image.ic_tabbar04_normal(),
                              selectedImage: R.image.ic_tabbar04_selected())
    }
    
    /// 为tababr点击添加动画
    /// - Parameters:
    ///   - tabbar: tabbar
    ///   - item: tabbar菜单
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let index = tabBar.items?.firstIndex(of: item) {
            
            if indexFlag != index {
                
                animateWithIndex(index: index)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension FYBaseTabBarController {

    private func createChildController(_ vc: UIViewController?,
                               title: String,
                               image: UIImage? = UIImage(),
                               selectedImage: UIImage? = UIImage()) {
        
        if let rootVC = vc {
            // configure
            rootVC.title = title
            rootVC.tabBarItem.image = UIImage.imageWithRenderingMode(image)
            rootVC.tabBarItem.selectedImage = UIImage.imageWithRenderingMode(selectedImage)
            // nav
            let nav = FYBaseNavigationController(rootViewController: rootVC)
            addChild(nav)
        }
    }
    
    
    /// 实现点击选中缩放动画
    private func animateWithIndex(index: Int) {
        var buttons = [UIView]()
        for view in tabBar.subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                buttons.append(view)
            }
        }
        
        // 缩放动画
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulse.duration = 0.15
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = NSNumber(value: 0.7)
        pulse.toValue = NSNumber(value: 1.1)
        buttons[index].layer.add(pulse, forKey: nil)
        
        indexFlag = index
    }
}

