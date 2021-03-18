//
//  SettingsView.swift
//  ChatApp
//
//  Created by Admin on 18.03.2021.
//

import UIKit

protocol SettingsViewDelegate: class {
    func handleSelectProfilePhoto()
    func handleActionButton()
}


class SettingsView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    weak var delegate: SettingsViewDelegate?
    
    private let plusPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Plus_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFit
        
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 140 / 2
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    private var userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "user@email.com"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.placeholder = "Enter info here"
        return tf
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let updateProfileButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setTitle("Update profile", for: .normal)
        return button
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleSelectProfilePhoto() {
        delegate?.handleSelectProfilePhoto()
    }
    
    @objc func handleActionButton() {
        delegate?.handleActionButton()
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        
        addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: self.topAnchor,
                            paddingTop: 16,
                            width: 140,
                            height: 140)
        plusPhotoBtn.centerX(inView: self)
        plusPhotoBtn.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        
        addSubview(userEmailLabel)
        userEmailLabel.anchor(top: plusPhotoBtn.bottomAnchor,
                              left: self.leftAnchor,
                              right: self.rightAnchor,
                              paddingTop: 12,
                              paddingLeft: 40,
                              paddingRight: 40)
        
        addSubview(nameTextField)
        nameTextField.anchor(top: userEmailLabel.bottomAnchor,
                             left: self.leftAnchor,
                             right: self.rightAnchor,
                             paddingTop: 12,
                             paddingLeft: 40,
                             paddingRight: 40,
                             height: 50)
//        nameTextField.centerX(inView: self)
        
        addSubview(separatorView)
        separatorView.anchor(top: nameTextField.bottomAnchor,
                             left: self.leftAnchor,
                             right: self.rightAnchor,
                             paddingTop: 16,
                             paddingLeft: 40,
                             paddingRight: 40,
                             height: 0.75)
        
        addSubview(updateProfileButton)
        updateProfileButton.anchor(top: separatorView.bottomAnchor,
                                   left: self.leftAnchor,
                                   right: self.rightAnchor,
                                   paddingTop: 16,
                                   paddingLeft: 40,
                                   paddingRight: 40)
//        updateProfileButton.centerX(inView: self)
        updateProfileButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
    }
    
    func setSelectedImage(selectedImage: UIImage) {
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.label.cgColor
        plusPhotoBtn.layer.borderWidth = 2
        plusPhotoBtn.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func getTextFromNameTextField() -> String? {
        return nameTextField.text
    }
    
    func set(email: String, placeholder: String?) {
        userEmailLabel.text = email
        
        if placeholder == nil {
            nameTextField.placeholder = "Enter UserName"
        } else {
            nameTextField.placeholder = placeholder
        }
    }
    
}
