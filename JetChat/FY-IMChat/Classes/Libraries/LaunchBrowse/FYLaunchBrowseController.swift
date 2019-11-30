//
//  LWLaunchBrowseController.swift
//  LWLaunchBrowseController
//
//  Created by iOS.Jet on 2019/2/22.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RxSwift

class SBLaunchConfig: NSObject {
    var image : UIImage?
    var title : String?
    
    init(image : UIImage?, title: String?) {
        super.init()
        
        self.image = image
        self.title = title
    }
}

class FYLaunchBrowseController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let kCellWidth  = kScreenW
    let kCellHeight = kScreenH
    
    // MARK:- setter
    
    var pageIndicatorTintColor: UIColor? {
        didSet {
            guard pageIndicatorTintColor != nil else {
                return
            }
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    var currentPageIndicatorTintColor: UIColor? {
        didSet {
            guard currentPageIndicatorTintColor != nil else {
                return
            }
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    
    var entryImage: UIImage? {
        didSet {
            guard entryImage != nil else {
                return
            }
            
            entryButton.setImage(entryImage, for: .normal)
        }
    }
    
    var buttonTitle: String? {
        didSet {
            guard buttonTitle != nil else {
                return
            }
            
            entryButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    
    // MARK:- Lazy
    var launchImages: [SBLaunchConfig] = []
    
    lazy var flowLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: kCellWidth, height: kCellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    lazy var collectionView : UICollectionView = {
        let frame = UIScreen.main.bounds
        let collection = UICollectionView.init(frame: frame, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = false
        collection.isPagingEnabled = true
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(FYLaunchImageViewCell.self, forCellWithReuseIdentifier: "LaunchBrowseCellIdentifier")
        collection.backgroundColor = UIColor.white

        return collection
    }()
    
    lazy var pageControl: UIPageControl = {
        let x: CGFloat = 50
        let w: CGFloat = kScreenW - x * 2
        let h: CGFloat = 38
        let y: CGFloat = kCellHeight - h - 50
        let pageView = UIPageControl(frame: CGRect(x: x, y: y, width: w, height: h))
        pageView.pageIndicatorTintColor = .groupTableViewBackground
        pageView.currentPageIndicatorTintColor = .red
        pageView.currentPage = 0
        return pageView
    }()
    
    lazy var entryButton: UIButton = {
        let button = UIButton(type: .custom)
        let w: CGFloat = 240
        let h: CGFloat = 40
        let x: CGFloat = (kCellWidth - w) / 2
        let y: CGFloat = kCellHeight - h - 33
        button.frame = CGRect(x: x, y: y, width: w, height: h)
        //button.setTitle(Lca.zero_app_guide_enter_app.rLocalized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        //button.setBackgroundImage(R.image.icon_launch_btn(), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.PingFangRegular(14)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.isHidden = true
        button.rx.tap.throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else{ return }
                self.skipTabBar()
            })
            .disposed(by: rx.disposeBag)
        return button
    }()
    
    // MARK:- Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWithHexStr("0F0F0F")

        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(entryButton)
        
        pageControl.numberOfPages = launchImages.count
        collectionView.reloadData()
    }
    
}

// MARK:- UICollectionViewDelegate && UICollectionViewDataSource

extension FYLaunchBrowseController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launchImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchBrowseCellIdentifier", for: indexPath) as! FYLaunchImageViewCell
        if launchImages.count > indexPath.row {
            cell.model = launchImages[indexPath.row]
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let offsetX = scrollView.contentOffset.x
            let index = offsetX / kCellWidth
            pageControl.currentPage = Int(index)
            
            if Int(index) >= launchImages.count - 1 {
                entryButton.isHidden = false
                pageControl.isHidden = true
            }else {
                entryButton.isHidden = true
                pageControl.isHidden = false
            }
        }
    }
}

// MARK:- Action

extension FYLaunchBrowseController {
    
    func skipTabBar() { }
}
