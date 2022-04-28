//
//  FYMomentsViewController.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 MacOsx. All rights reserved.
//

import UIKit
import IGListKit
import IGListDiffKit
import MJRefresh

class FYMomentsViewController: FYBaseIGListViewController {

    // MARK: - lazy var
    
    fileprivate var contentOffsetY: CGFloat = 0
    
    fileprivate var publish: NSObjectProtocol?
    fileprivate var location: NSObjectProtocol?
    fileprivate var delete: NSObjectProtocol?
    fileprivate var contentOffset: NSObjectProtocol?
    fileprivate var push: NSObjectProtocol?
    fileprivate var openURL: NSObjectProtocol?
    fileprivate var page: Int = 1
    
    private lazy var momentNavBar: FYMomentNavBar = {
        let nav = FYMomentNavBar(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kNavigaH))
        nav.onClick = { [weak self] index in
            switch index {
            case 100:
                self?.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
        return nav
    }()
    
    // MARK: - life cycle
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is FYMomentInfo:
            let section = FYMomentBindingSection()
            return section
        default:
            fatalError()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "朋友圈".rLocalized()
        
        addRefreshing()
        loadData()
    }
    
    override func makeUI() {
        super.makeUI()
        adapter.scrollViewDelegate = self
        
        view.addSubview(momentNavBar)
        momentNavBar.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(kNavigaH)
        }
    }
    
    private func addRefreshing() {
        
        collectionView.mj_header = FYMomentHeaderRefresh(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.collectionView.mj_header?.endRefreshing()
            }
        })
        
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.loadData("data2")
                self?.collectionView.mj_footer?.endRefreshing()
            }
        })
    }
    
    private func loadData(_ resource: String = "data1") {
        do {
            let url = Bundle.main.url(forResource: resource, withExtension: "json")!
            do {
                let data = try Data(contentsOf: url)
                let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if let jsonArray = jsonData as? NSArray {
                    if let modelArray = [FYMomentInfo].deserialize(from: jsonArray) {
                        for info in modelArray {
                            info?.id = Int(arc4random_uniform(255))
                            self.objects.append(info!)
                        }
                    }
                    
                    adapter.performUpdates(animated: true, completion: nil)
                }
                
            } catch  {
                print("decode failure")
            }
        }
    }
}

fileprivate extension FYMomentsViewController {
    
    func notification() {
        publish = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.publish, object: nil, queue: OperationQueue.main) {[weak self] (noti) in
            self?.loadData()
        }
        
        location = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.location, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            guard let object = noti.object as? FYMomentInfo else {
                return
            }
            print("click location", object)
        }
        
        delete = NotificationCenter.default.addObserver(forName: Notification.Name.list.delete, object: nil, queue: OperationQueue.main) {[weak self] (noti) in
            guard let object = noti.object as? FYMomentInfo, let self = self else {
                return
            }
            self.objects.removeAll { (element) -> Bool in
                guard let ele = element as? FYMomentInfo else {
                    return false
                }
                return ele.id == object.id
            }
            self.adapter.performUpdates(animated: true, completion: nil)
        }
        
        contentOffset = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.contentOffset, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let offset = noti.object as? CGFloat, let self = self else {
                return
            }
            if offset < 0 { return }
            self.collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
        })
        
        push = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.push, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let userId = noti.object as? Int, let self = self else {
                return
            }
            print(userId)
        })
        
        openURL = NotificationCenter.default.addObserver(forName: NSNotification.Name.list.openURL, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let url = noti.object as? URL, let self = self else {
                return
            }
            print(url)
        })
    }
}

// MARK: - <UIScrollViewDelegate>

extension FYMomentsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsetY = scrollView.contentOffset.y
        
        momentNavBar.navBarView.alpha = contentOffsetY / 150
        momentNavBar.titleLabel.alpha = contentOffsetY / 150

        if contentOffsetY / 150 > 0.6 {
            momentNavBar.isScrollUp = true
        } else {
            momentNavBar.isScrollUp = false
        }
    }
}
