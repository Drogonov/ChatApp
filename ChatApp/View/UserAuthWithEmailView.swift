//
//  UserAuthWithEmailView.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit

protocol UserAuthWithEmailViewDelegate: class {
    func handleAuthButton()
}

enum UserAuthViewConfiguration {
    case login
    case signUp
    
    init() {
        self = .login
    }
}

class UserAuthWithEmailView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: UserAuthWithEmailViewDelegate?
    var config = UserAuthViewConfiguration() {
        didSet { configureUI(withConfig: config)}
    }
    
    var logoSize: CGFloat = 100
    var logoImageViewWidthConstraint: NSLayoutConstraint!
    var logoImageViewHeightConstraint: NSLayoutConstraint!
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Clogo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "envelope"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "lock"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var repeatPasswordContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "lock"), textField: repeatPasswordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    let repeatPasswordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Repeat Password",
                                       isSecureTextEntry: true)
    }()
    
    private let actionButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleActionButton() {
        delegate?.handleAuthButton()
    }
    
    // MARK: - Helper Functions
    
    func configureUI(withConfig config: UserAuthViewConfiguration) {
        configureLogoImage()
        backgroundColor = .systemBackground
        
        switch config {
        case .login:
            actionButton.setTitle("Log In", for: .normal)
            let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                       passwordContainerView,
                                                       actionButton])
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.spacing = 20
            
            addSubview(stack)
            stack.anchor(top: logoImageView.bottomAnchor,
                         left: self.leftAnchor,
                         right: self.rightAnchor,
                         paddingTop: 40,
                         paddingLeft: 16,
                         paddingRight: 16)
            
        case .signUp:
            actionButton.setTitle("Sign Up", for: .normal)
            let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                       passwordContainerView,
                                                       repeatPasswordContainerView,
                                                       actionButton])
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.spacing = 20

            addSubview(stack)
            stack.anchor(top: logoImageView.bottomAnchor,
                         left: self.leftAnchor,
                         right: self.rightAnchor,
                         paddingTop: 40,
                         paddingLeft: 16,
                         paddingRight: 16)
        }
    }
    
    func configureLogoImage() {
        addSubview(logoImageView)
        logoImageView.centerX(inView: self)
        logoImageView.anchor(top: self.topAnchor, paddingTop: 24)
        logoImageViewWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 125)
        logoImageViewWidthConstraint.isActive = true
        logoImageViewHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 125)
        logoImageViewHeightConstraint.isActive = true
    }
}
