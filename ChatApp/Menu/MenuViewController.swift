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
    func userProfileEdited()
}

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User {
        didSet {
            configureUI()
        }
    }
    
    weak var delegate: MenuViewControllerDelegate?
    private lazy var tableView = MenuTableView(frame: .zero, user: user)
    private lazy var settingsVC = SettingsViewController(user: user)
    
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
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .left {
            delegate?.handleChatToggle()
        }
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        configureSwipeGesture()
        configureNavigationBar()
        configureTableView()
        
        settingsVC.delegate = self
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
    }
    
    private func configureSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func presentSettingsVC() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: self.settingsVC)
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .popover
            nav.navigationBar.tintColor = UIColor.systemRed
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}

// MARK: - MenuTableViewDelegate

extension MenuViewController: MenuTableViewDelegate {
    func handleSettingsToggle() {
        presentSettingsVC()
    }
    
    func handleLogoutToggle() {
        delegate?.handleLogout()
    }
}

// MARK: - SettingsViewControllerDelegate

extension MenuViewController: SettingsViewControllerDelegate {
    func userProfileEdited() {
        delegate?.userProfileEdited()
    }
}
