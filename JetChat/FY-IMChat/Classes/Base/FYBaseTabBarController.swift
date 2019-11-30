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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        
//        DispatchQueue.main.async {
//           // normal
//            self.tabBarItem.theme_setTitleTextAttributes(ThemeStringAttributesPicker(keyPath: "Global.tabBarTitleColor_n") { value -> [NSAttributedString.Key : AnyObject]? in
//               guard let rgba = value as? String else {
//                   return nil
//               }
//
//               let color = UIColor(rgba: rgba)
//               let titleTextAttributes = [
//                   NSAttributedString.Key.foregroundColor: color,
//                   NSAttributedString.Key.font: UIFont.PingFangMedium(11),
//               ]
//               return titleTextAttributes
//           }, forState: .normal)
//
//           // selected
//            self.tabBarItem.theme_setTitleTextAttributes(ThemeStringAttributesPicker(keyPath: "Global.tabBarTitleColor_s") { value -> [NSAttributedString.Key : AnyObject]? in
//               guard let rgba = value as? String else {
//                   return nil
//               }
//
//               let color = UIColor(rgba: rgba)
//               let titleTextAttributes = [
//                   NSAttributedString.Key.foregroundColor: color,
//                   NSAttributedString.Key.font: UIFont.PingFangMedium(11),
//               ]
//               return titleTextAttributes
//           }, forState: .selected)
//       }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension FYBaseTabBarController {

    func createChildController(_ vc: UIViewController?,
                               title: String,
                               image: UIImage? = UIImage(),
                               selectedImage: UIImage? = UIImage()) {
        
        if let rootVC = vc {
            // config
            rootVC.title = title
            rootVC.tabBarItem.image = UIImage.imageWithRenderingMode(image)
            rootVC.tabBarItem.selectedImage = UIImage.imageWithRenderingMode(selectedImage)
            // nav
            let nav = FYBaseNavigationController(rootViewController: rootVC)
            addChild(nav)
        }
    }
}
