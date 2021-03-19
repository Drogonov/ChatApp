//
//  ChatCollectionView.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//

import Foundation
import UIKit

class ChatCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var messages = [Message]()
    var currentUID: String?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = UIColor.white
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.reuseId)
        
    }
    
    func set(messages: [Message], currentUID: String) {
        self.messages = messages
        self.currentUID = currentUID
        contentOffset = CGPoint.zero
        reloadData()
    }
    
    func configureMessage(cell: ChatCell, message: Message) {
        if message.fromId == currentUID {
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
        } else {
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: ChatCell.reuseId, for: indexPath) as! ChatCell
        cell.set(withText: messages[indexPath.row].messageText,
                 withInitials: messages[indexPath.row].initialForProfileImage,
                 withImageUrl: messages[indexPath.row].imageUrl)
        configureMessage(cell: cell, message: messages[indexPath.row])
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.item]
        let height = estimateFrameForText(message.messageText).height + 20
        return CGSize(width: collectionView.bounds.width, height: height)
        
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
