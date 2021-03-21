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
    private var chatCollectionView = ChatCollectionView()
    private var refreshControl = UIRefreshControl()
    
    private let firebaseServise = FirebaseService()
    
    private var textInputBottomConstraint: NSLayoutConstraint?
    
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
        fetchMessages {}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Selectors
    
    @objc func showMenu() {
        delegate?.handleMenuToggle()
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            delegate?.handleMenuToggle()
        }
    }
    
    @objc func Keyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            animateWithKeyboard(notification: notification as NSNotification) { (keyboardFrame) in
                self.textInputBottomConstraint?.constant = 0
                self.view.layoutIfNeeded()
                
            }
        } else {
            animateWithKeyboard(notification: notification as NSNotification) { (keyboardFrame) in
                self.textInputBottomConstraint?.constant = -keyboardFrame.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchMessages(completion: {
            self.refreshControl.endRefreshing()
        })
    }
    
    // MARK: - API
    
    func fetchMessages(completion: @escaping() -> Void) {
        firebaseServise.fetchMessages { (messages) in
            self.messages = messages
            self.configureUI()
            completion()
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureSwipeGesture()
        configureKeyboard()
        configureChatCollectionView()
        configureMessageInputView()
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
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                                right: view.safeAreaLayoutGuide.rightAnchor)
        textInputBottomConstraint = NSLayoutConstraint(item: messageInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(textInputBottomConstraint!)
        
    }
    
    private func configureChatCollectionView() {
        view.addSubview(chatCollectionView)
        chatCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  left: view.safeAreaLayoutGuide.leftAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  right: view.safeAreaLayoutGuide.rightAnchor,
                                  paddingBottom: 44)
        chatCollectionView.set(messages: messages, currentUID: user.uid)
        
        chatCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        chatCollectionView.scrollToLast()
    }
    
    private func configureKeyboard() {
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

// MARK: - MessageInputViewDelegate

extension ChatViewController: MessageInputViewDelegate {
    func handleUploadMessage(message: String) {
        let text = message.localizedLowercase.trimmingCharacters(in: .whitespaces)
        firebaseServise.uploadMessage(messageText: text,
                                      fromId: user.uid) { (wasUploadSuccessful) in
            if wasUploadSuccessful == true {
                self.messageInputView.clearMessageTextView()
                self.fetchMessages {}
            } else {
                self.showNotification(title: "Error uploading message", defaultAction: true, defaultActionText: "Ok") {}
            }
        }
    }
}
