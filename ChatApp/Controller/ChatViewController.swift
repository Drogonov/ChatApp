//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit
import Firebase

protocol ChatViewControllerDelegate: class {
    func handleMenuToggle()
}

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    private var messages = [Message]()
    
    weak var delegate: ChatViewControllerDelegate?
    
    private var messageInputView = MessageInputView()
    private lazy var yOrigin = CGFloat(300)
    
    private var chatCollectionView = ChatCollectionView()
    

    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()
    }
    
    func fetchMessages() {
        Service.shared.fetchMessages { (messages) in
            print(messages)
            self.messages = messages
            self.configureUI()
        }
    }
    
    // MARK: - Selectors
    
    @objc func showMenu() {
        print("showMenu")
        delegate?.handleMenuToggle()
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            print("showMenu")
            delegate?.handleMenuToggle()
        }
    }
    
    @objc func Keyboard(notification: Notification) {
        let height = keyboardHeight(notification: notification)
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.animateMessageInputView(keyboardHeight: height, keyboardShouldHide: true)
            view.layoutIfNeeded()
        } else {
            self.animateMessageInputView(keyboardHeight: height, keyboardShouldHide: false)
        }
    }
    
    func keyboardHeight(notification: Notification) -> CGFloat {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            return keyboardSize.height
        } else {
            return 0
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureSwipeGesture()
        configureMessageInputView()
        configureKeyboard()
        configureChatCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        navigationItem.title = "Chat App"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage().systemImage(withSystemName: "list.bullet"), style: .plain, target: self, action: #selector(showMenu))
        
    }
    
    private func configureSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    private func configureMessageInputView() {
        messageInputView.delegate = self
        view.addSubview(messageInputView)
        messageInputView.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.safeAreaLayoutGuide.rightAnchor,
                                height: 50)
    }
    
    private func configureChatCollectionView() {
        view.addSubview(chatCollectionView)
        chatCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  left: view.safeAreaLayoutGuide.leftAnchor,
                                  bottom: messageInputView.topAnchor,
                                  right: view.safeAreaLayoutGuide.rightAnchor)
        chatCollectionView.set(messages: messages, currentUID: user.uid)
    }
    
    private func configureKeyboard() {
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func animateMessageInputView(keyboardHeight: CGFloat, keyboardShouldHide: Bool) {
        if keyboardShouldHide {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.messageInputView.frame.origin.y = self.view.frame.height - 50
                self.chatCollectionView.frame.origin.y = 50 + 15
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.messageInputView.frame.origin.y = self.view.frame.height - keyboardHeight - 50
                self.chatCollectionView.frame.origin.y = -keyboardHeight + 50 + 15
            })
        }
    }
}

extension ChatViewController: MessageInputViewDelegate {
    func handleUploadMessage(message: String) {
        Service.shared.uploadMessage(messageText: message, fromId: user.uid, fromName: user.fullname, imageUrl: user.profileImageUrl) { (err, ref) in
            if let error = err {
                print("DEBUG: Failed to upload message with error \(error)")
                return
            }
            self.fetchMessages()
        }
    }
}
