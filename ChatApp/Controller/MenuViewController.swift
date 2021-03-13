//
//  MenuViewController.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit
import Firebase

protocol MenuViewControllerDelegate: class {
    func handleChatToggle()
    func handleLogout()
}

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User {
        didSet {
            print("didSet")
            print(user)
            configureUI()
        }
    }
    
    weak var delegate: MenuViewControllerDelegate?
    private lazy var tableView = MenuTableView(frame: .zero, user: user)
    
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
        print("viewDidLoad")
        print(user)
    }
    
    // MARK: - Selectors
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .left {
            print("showChat")
            delegate?.handleChatToggle()
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        configureSwipeGesture()
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor,
                         paddingRight: 80)
        tableView.set(withUser: user)
    }
    
    private func configureSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func presentSettingsVC() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: SettingsViewController(user: self.user))
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .popover
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}

extension MenuViewController: MenuTableViewDelegate {
    func handleSettingsToggle() {
        presentSettingsVC()
    }
    
    func handleLogoutToggle() {
//        self.dismiss(animated: true, completion: nil)
        delegate?.handleLogout()
    }
}
