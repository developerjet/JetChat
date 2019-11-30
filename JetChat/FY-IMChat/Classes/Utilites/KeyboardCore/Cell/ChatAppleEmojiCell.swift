//
//  ChatAppleEmojiCell.swift
//  FY-IMChat
//
//  Created by iOS.Jet on 2019/11/18.
//  Copyright © 2019 MacOsx. All rights reserved.
//

import UIKit

class ChatAppleEmojiCell: UICollectionViewCell {
    
    // MARK: - lazy var
    
    var model: ChatEmoticon? {
        didSet {
            guard let emoticon = model else {
                return
            }
            
            if emoticon.isDelete {
                emojiBtn.setTitle(nil, for: .normal)
                emojiBtn.setImage(UIImage(named: "ic_emotion_delete"), for: .normal)
                emojiBtn.setImage(UIImage(named: "ic_emotion_delete"), for: .highlighted)
            }else if emoticon.isSpace {
                emojiBtn.setImage(nil, for: .normal)
                emojiBtn.setTitle(nil, for: .normal)
            }else if emoticon.emojiCode?.length ?? 0 > 0 {
                emojiBtn.setTitle(emoticon.emojiCode, for: .normal)
                emojiBtn.setImage(nil, for: .normal)
            }else {
                guard let imgPath = emoticon.imgPath else {
                    return
                }
                
                emojiBtn.setTitle(nil, for: .normal)
                emojiBtn.setImage(UIImage(contentsOfFile: imgPath), for: .normal)
            }
        }
    }
    
    lazy var emojiBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - life cycle
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(emojiBtn)
        emojiBtn.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
