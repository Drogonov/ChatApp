//
//  ChatCollectionView.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//

import Foundation
import UIKit

class ChatCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    var messages = [Message]()
    var currentUID: String?
    
    // MARK: - Init
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = .systemBackground
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.reuseId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    
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
            cell.bubbleView.backgroundColor = .systemRed
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
        } else {
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = .secondarySystemBackground
            cell.textView.textColor = .label
            cell.profileImageView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: ChatCell.reuseId, for: indexPath) as! ChatCell
        cell.set(text: messages[indexPath.row].messageText,
                 initials: messages[indexPath.row].initialForProfileImage,
                 imageUrl: messages[indexPath.row].imageUrl)
        configureMessage(cell: cell, message: messages[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.item]
        let height = message.messageText.height(width: 180, font: UIFont.systemFont(ofSize: 16)) + 20
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}
