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
    weak var delegate: ChatViewControllerDelegate?

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
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureSwipeGesture()
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
}
