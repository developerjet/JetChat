//
//  ChatMoreMenuView.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/14.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

/// 行数
fileprivate let kRowNumber = 2
/// 列数
fileprivate let kColumnNumber = 4

fileprivate let kMoreMenuCellNumberOfOnePage = kRowNumber * kColumnNumber

protocol ChatMoreMenuViewDelegate {
    /// 获取选择的菜单
    func menu(_ view: ChatMoreMenuView, DidSelected type: ChatMoreMenuType)
}

extension ChatMoreMenuViewDelegate {
    
    func menu(_ view: ChatMoreMenuView, DidSelected type: ChatMoreMenuType) {}
}

class ChatMoreMenuView: UIView {
    
    // MARK: - lazy var
    
    var delegate: ChatMoreMenuViewDelegate?
    
    /// 隐藏分页指示器
    var hidePageController: Bool = false {
        didSet {
            self.pageControl.alpha = self.hidePageController ? 0.0 : 1.0
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.pageControl.isHidden = self.hidePageController
            }, completion: nil)
            
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
        
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

    lazy var dataSource: [ChatMoreMnueConfig] = {
        let configs = [
            ChatMoreMnueConfig(title: "图片", image: "ic_more_album", type: .album),
            ChatMoreMnueConfig(title: "拍照", image: "ic_more_camera", type: .camera),
            ChatMoreMnueConfig(title: "视频", image: "ic_more_video", type: .video),
            ChatMoreMnueConfig(title: "位置", image: "ic_more_location", type: .location),
            ChatMoreMnueConfig(title: "语音", image: "ic_more_voice", type: .voice),
            ChatMoreMnueConfig(title: "钱包", image: "ic_more_wallet", type: .wallet),
            ChatMoreMnueConfig(title: "转账", image: "ic_more_pay", type: .pay),
            ChatMoreMnueConfig(title: "名片", image: "ic_more_friendcard", type: .friendcard),
            ChatMoreMnueConfig(title: "收藏", image: "ic_more_favorite", type: .favorite),
            ChatMoreMnueConfig(title: "隐藏", image: "ic_more_sight", type: .sight)]
        return configs
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = ChatKeyboardFlowLayout(column: kColumnNumber, row: kRowNumber)
        // collectionView
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.backgroundColor = .kContentColor
        collection.register(cellWithClass: ChatMoreMenuCell.self)
        collection.showsHorizontalScrollIndicator = true
        collection.showsVerticalScrollIndicator = true
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        return collection
    }()
    
    lazy var pageControl: UIPageControl = {
        let pager = UIPageControl()
        pager.backgroundColor = .clear
        pager.pageIndicatorTintColor = UIColor.lightGray
        pager.currentPageIndicatorTintColor = UIColor.gray
        pager.currentPage = 0
        pager.isHidden = true
        pager.numberOfPages = self.dataSource.count / kMoreMenuCellNumberOfOnePage + (self.dataSource.count % kMoreMenuCellNumberOfOnePage == 0 ? 0 : 1)
        return pager
    }()
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           
        makeUI()
        reloadData()
    }
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        makeUI()
        reloadData()
    }
    
    func makeUI() {
        backgroundColor = .kContentColor
        addSubview(pageControl)
        addSubview(collectionView)
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-kSafeAreaBottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp_top)
        }
    }
    
    open func reloadData() {
        self.needsUpdateConstraints()
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.pageControl.alpha = 1.0
            self.pageControl.isHidden = false
        }, completion: nil)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}


// MARK:- UICollectionViewDataSource

extension ChatMoreMenuView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ChatMoreMenuCell.self, for: indexPath)
        if let model = dataSource[safe: indexPath.row] {
            cell.model = model
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension ChatMoreMenuView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = dataSource[safe: indexPath.row] {
            delegate?.menu(self, DidSelected: model.type!)
        }
    }
}

extension ChatMoreMenuView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let offsetX = scrollView.contentOffset.x
            let index = offsetX / kScreenW
            pageControl.currentPage = Int(index)
        }
    }
}
