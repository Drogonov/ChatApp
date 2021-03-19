//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit
import Firebase
import FirebaseAuth

protocol LoginViewControllerDelegate: class {
    func loginWithEmail(_ controller: LoginViewController)
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let signUpVC = SignUpViewController()
    weak var delegate: LoginViewControllerDelegate?
    private lazy var userAuthView = UserAuthWithEmailView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func Keyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            userAuthView.logoSize = 125
            UIView.animate(withDuration: 0.5, animations: {
                self.userAuthView.logoImageViewHeightConstraint.constant = self.userAuthView.logoSize
                self.userAuthView.logoImageViewWidthConstraint.constant = self.userAuthView.logoSize
            })
        } else {
            userAuthView.logoSize = 70
            UIView.animate(withDuration: 0.5, animations: {
                self.userAuthView.logoImageViewHeightConstraint.constant = self.userAuthView.logoSize
                self.userAuthView.logoImageViewWidthConstraint.constant = self.userAuthView.logoSize
            })
        }
        view.layoutIfNeeded()
    }
    
    
    @objc func signUpTapped() {
        let controller = signUpVC
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        signUpVC.delegate = self
        configureNavigationBar()
        configureUserAuthView()
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        navigationItem.title = "Login"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(signUpTapped))
    }
    
    func configureUserAuthView() {
        userAuthView.delegate = self
        userAuthView.config = .login
        
        view.addSubview(userAuthView)
        userAuthView.centerX(inView: view)
        userAuthView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.safeAreaLayoutGuide.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor)
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Protocol Functions
    
    func handleLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to log user in with error \(error.localizedDescription)")
                return
            }
            self.delegate?.loginWithEmail(self)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UserAuthViewDelegate

extension LoginViewController: UserAuthWithEmailViewDelegate {
    func handleAuthButton() {
        guard let email = userAuthView.emailTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let password = userAuthView.passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        handleLogin(email: email, password: password)
    }
}

extension LoginViewController: SignUpViewControllerDelegate {
    func signUpWithEmail(_ controller: SignUpViewController) {
        self.delegate?.loginWithEmail(self)
        self.dismiss(animated: true, completion: nil)
    }
}
