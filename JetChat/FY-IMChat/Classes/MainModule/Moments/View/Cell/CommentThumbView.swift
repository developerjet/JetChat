//
//  CommentThumbView.swift
//  JetChat
//
//  Created by Jett on 2020/5/11.
//  Copyright © 2022 Jett. All rights reserved.
//

import Foundation

/// 点赞头像
class CommentThumbView: NineImageView {
    
    static let itemWidth: CGFloat = (kScreenW - 30 - 16*2) / 7
    
    var onClick: ((Int)->Void)?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(NineImageViewCell.self, indexPath: indexPath)
        cell.imageView.setImageWithURL(images[indexPath.item])
        if isRounds {
            cell.imageView.layer.cornerRadius = 5
            cell.imageView.layer.masksToBounds = true
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CommentThumbView.itemWidth, height: CommentThumbView.itemWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点赞头像 \(indexPath)")
        onClick?(indexPath.item)
    }
}
