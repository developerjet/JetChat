//
//  FYFYMomentBindingSection.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/28.
//  Copyright © 2022 MacOsx. All rights reserved.
//

import UIKit
import IGListKit
import IGListDiffKit

enum ViewModelEnum: String {
    case top, header, image_single, location, bottom, comment
}

class FYMomentBindingSection: ListBindingSectionController<ListDiffable> {
    var momentInfo: FYMomentInfo!
    
    override init() {
        super.init()
        dataSource = self
        selectionDelegate = self
    }
    
    override func didUpdate(to object: Any) {
        guard let obj = object as? FYMomentInfo else { fatalError() }
        momentInfo = obj
        super.didUpdate(to: obj)
    }
    
    // MARK: cell
    func momentTopCell(at index: Int) -> MomentTopCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: MomentTopCell.self, for: self, at: index) as? MomentTopCell else { fatalError() }
        cell.bindViewModel(object!)
        return cell
    }
    
    func momentHeaderCell(at index: Int) -> MomentHeaderCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: MomentHeaderCell.self, for: self, at: index) as? MomentHeaderCell else { fatalError() }
        cell.bindViewModel(object!)
        cell.onClick = {[weak self] idx in
            self?.toExpend()
        }
        return cell
    }
    
    func momentHeaderImageCell(at index: Int) -> MomentHeaderImageCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: MomentHeaderImageCell.self, for: self, at: index) as? MomentHeaderImageCell else { fatalError() }
        cell.bindViewModel(object!)
        cell.onClick = {[weak self] idx in
            self?.toExpend()
        }
        return cell
    }
    
    func momentLocationCell(at index: Int) -> MomentLocationCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: MomentLocationCell.self, for: self, at: index) as? MomentLocationCell else { fatalError() }
        cell.bindViewModel(object!)
        return cell
    }
    
    func momentBottomCell(at index: Int) -> MomentBottomCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: MomentBottomCell.self, for: self, at: index) as? MomentBottomCell else { fatalError() }
        cell.bindViewModel(object!)
        cell.onClick = {[weak self] action in
            guard let self = self else { return }
            switch action {
            case .thumbup:
                self.toFavor()
            case .delete:
                self.toDelete()
            case .comment(let text):
                self.toComment(text)
            case .commentDraft(let text):
                self.toSaveDraft(text)
            }
        }
        
        cell.onRelativeRect = {[unowned self] () -> CGRect in
            let first = self.cellForItem(at: 0).frame
            let last = self.cellForItem(at: index).frame
            let rect = CGRect(x: 0, y: first.minY, width: first.width, height: last.maxY-first.minY)
            return rect
        }
        return cell
    }
    
    func momentCommentCell(at index: Int) -> MomentCommentCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: MomentCommentCell.self, for: self, at: index) as? MomentCommentCell else { fatalError() }
        cell.bindViewModel(object!)
        cell.actionDelegate = self
        return cell
    }
}


extension FYMomentBindingSection: ListBindingSectionControllerDataSource, ListBindingSectionControllerSelectionDelegate {
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        guard let object = object as? FYMomentInfo else { return [] }
        var results: [ListDiffable] = []
        if object.userInfo?.background_url != nil {
            results.append(ViewModelEnum.top.rawValue as ListDiffable)
        }
        if object.images.count == 1 {
            results.append(ViewModelEnum.image_single.rawValue as ListDiffable)
        }else {
            results.append(ViewModelEnum.header.rawValue as ListDiffable)
        }
        if !object.location.isEmpty {
            results.append(ViewModelEnum.location.rawValue as ListDiffable)
        }
        if object.userInfo == nil {
            results.append(ViewModelEnum.bottom.rawValue as ListDiffable)
            results.append(ViewModelEnum.comment.rawValue as ListDiffable)
        }
        return results
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        
        let viewModel = ViewModelEnum(rawValue: viewModel as! String)!
        switch viewModel {
        case .top:
            return momentTopCell(at: index)
        case .image_single:
            return momentHeaderImageCell(at: index)
        case .header:
            return momentHeaderCell(at: index)
        case .location:
            return momentLocationCell(at: index)
        case .bottom:
            return momentBottomCell(at: index)
        case .comment:
            return momentCommentCell(at: index)
        }
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let object = object as? FYMomentInfo else { fatalError() }
        let viewModel = ViewModelEnum(rawValue: viewModel as! String)!
        let width: CGFloat = collectionContext!.containerSize(for: self).width
        switch viewModel {
        case .top:
            return CGSize(width: width, height: 340)
        case .header, .image_single:
            return CGSize(width: width, height: object.cellHeight)
        case .location:
            return CGSize(width: width, height: 30)
        case .bottom:
            return CGSize(width: width, height: 30)
        case .comment:
            var height = object.contentHeight
            height += object.contentHeight > 0 ? 20 : 10
            return CGSize(width: width, height: height)
        }
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didSelectItemAt index: Int, viewModel: Any) {
        
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didDeselectItemAt index: Int, viewModel: Any) {
        
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didHighlightItemAt index: Int, viewModel: Any) {
        
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, didUnhighlightItemAt index: Int, viewModel: Any) {
        
    }
}

fileprivate extension FYMomentBindingSection {
    func toExpend() {
        guard let object = object as? FYMomentInfo else { fatalError() }
        object.isTextExpend = !object.isTextExpend
        self.didUpdate(to: object)
        self.collectionContext?.performBatch(animated: false, updates: { (context) in
            context.reload(self)
        }, completion: nil)
    }
    func toDelete() {
        NotificationCenter.default.post(name: NSNotification.Name.list.delete, object: object)
    }
    /// 点赞
    func toFavor() {
        guard let object = object as? FYMomentInfo else { fatalError() }
        self.didUpdate(to: object)
        self.collectionContext?.performBatch(animated: false, updates: { (context) in
            context.reload(self)
        }, completion: nil)
    }
    /// 评论
    func toComment(_ text: String) {
        print("comment: \(text)")
        guard let object = object as? FYMomentInfo else { fatalError() }
        self.didUpdate(to: object)
        self.collectionContext?.performBatch(animated: false, updates: { (context) in
            context.reload(self)
        }, completion: nil)
    }
    func toSaveDraft(_ text: String) {
        print("comment draft: \(text)")
    }
}

extension FYMomentBindingSection: MomentCommentDelegate {
    func contentDidSelected(_ model: FYCommentInfo, action: CommentContentClickAction) {
        print(action, model)
        switch action {
        case .avatar:
            print("点击头像")
        case .title:
            print("点击title")
        case .reply:
            print("回复的标题")
        case .bg(let isSelf):
            print("点击背景 \(isSelf)")
        case .comment(let text):
            print("评论: \(text)")
            toComment(text)
        case .commentDraft(let text):
            print("评论草稿: \(text)")
        }
    }
    
    func thumbDidSelected(_ model: FYCommentInfo) {
        print(model)
    }
}
