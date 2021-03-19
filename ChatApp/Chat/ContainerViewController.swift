//
//  ContainerViewController.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit
import Firebase

class ContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var loginVC = LoginViewController()
    private var chatVC: UIViewController!
    private var menuVC: MenuViewController!
    private var isExpanded = false
    private let blackView = UIView()
    private lazy var xOrigin = self.view.frame.width - 80
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureMenuVC(withUser: user)
            configureChatVC(withUser: user)

            print("didSet Container")
            print(user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    }
        
    // MARK: - Selectors
    
    @objc func dismissMenu() {
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        print("checkIfUserIsLoggedIn")
        if Auth.auth().currentUser?.uid == nil {
            loginVC.delegate = self
            presentLoginController()
        } else {
            configure()
        }
    }
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    func signOut(completion: @escaping() -> Void) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    // MARK: - Helper Functions
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: self.loginVC)
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        fetchUserData()
    }
    
    func configureChatVC(withUser user: User) {
        let chatViewController = ChatViewController(user: user)
        chatViewController.delegate = self
        chatVC = UINavigationController(rootViewController: chatViewController)
        
        addChild(chatVC)
        chatVC.didMove(toParent: self)
        view.addSubview(chatVC.view)
        configureBlackView()
    }
    
    func configureMenuVC(withUser user: User) {
        menuVC = MenuViewController(user: user)
        menuVC.delegate = self

        addChild(menuVC)
        menuVC.didMove(toParent: self)
        view.addSubview(menuVC.view)
    }
    
    func configureBlackView() {
        self.blackView.frame = CGRect(x: xOrigin,
                                      y: 0,
                                      width: 80,
                                      height: self.view.frame.height)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        view.addSubview(blackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blackView.addGestureRecognizer(tap)
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.chatVC.view.frame.origin.x = self.xOrigin
                self.blackView.frame.origin.x = self.xOrigin
                self.blackView.alpha = 1
            }, completion: nil)
        } else {
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.chatVC.view.frame.origin.x = 0
                self.blackView.frame.origin.x = 0
            }, completion: completion)
        }
    }
}

extension ContainerViewController: LoginViewControllerDelegate {
    func loginWithEmail(_ controller: LoginViewController) {
        checkIfUserIsLoggedIn()
    }
}

extension ContainerViewController: ChatViewControllerDelegate {
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    func userProfileEdited() {
        DispatchQueue.global().sync {
            isExpanded.toggle()
            animateMenu(shouldExpand: isExpanded)
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    func handleLogout() {
        DispatchQueue.global().sync {
            isExpanded.toggle()
            animateMenu(shouldExpand: isExpanded)
            DispatchQueue.main.async {
                self.signOut {
                    self.checkIfUserIsLoggedIn()
                }
            }
        }
    }
    
    func handleChatToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}
