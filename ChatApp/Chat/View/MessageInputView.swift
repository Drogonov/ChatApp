//
//  MessageInputAccesoryView.swift
//  ChatApp
//
//  Created by Admin on 18.03.2021.
//

import UIKit

protocol MessageInputViewDelegate {
    func handleUploadMessage(message: String)
}

class MessageInputView: UIView {
    
    // MARK: - Properties
    
    var delegate: MessageInputViewDelegate?
    
    private let messageInputTextView: MessageInputTextView = {
        let tv = MessageInputTextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUploadMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .systemBackground
        
        addSubview(sendButton)
        sendButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingRight: 8, width: 50, height: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 8, paddingLeft: 4, paddingRight: 8)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clearMessageTextView() {
        messageInputTextView.placeholderLabel.isHidden = false
        messageInputTextView.text = nil
    }
    
    // MARK: - Handlers
    
    @objc func handleUploadMessage() {
        guard let message = messageInputTextView.text else { return }
        if message != "" {
            delegate?.handleUploadMessage(message: message)
        }
    }
}

