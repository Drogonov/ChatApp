//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit
import Firebase
import FirebaseAuth

protocol SignUpViewControllerDelegate: class {
    func signUpWithEmail(_ controller: SignUpViewController)
}

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SignUpViewControllerDelegate?
    
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
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        configureNavigationBar()
        configureUserAuthView()
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Login"
    }
    
    func configureUserAuthView() {
        userAuthView.delegate = self
        userAuthView.config = .signUp
        
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
    
    func handleSignUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email] as [String : Any]
            
            Service.shared.updateUserValues(uid: uid, values: values) { (err, ref) in
                if let error = error {
                    print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                    return
                }
                self.delegate?.signUpWithEmail(self)
            }
        }
    }
}

// MARK: - UserAuthViewDelegate

extension SignUpViewController: UserAuthWithEmailViewDelegate {
    func handleAuthButton() {
        guard let email = userAuthView.emailTextField.text?.localizedLowercase.trimmingCharacters(in: .whitespaces) else { return }
        guard let password = userAuthView.passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let repeatedPassword = userAuthView.repeatPasswordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        if password == repeatedPassword {
            handleSignUp(email: email, password: password)
        } else {
            showNotification(title: "Repeated password is wrong, check it please", defaultAction: true, defaultActionText: "Ok") {}
        }
    }
}
