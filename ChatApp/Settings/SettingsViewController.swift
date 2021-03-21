//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit
import Firebase

protocol SettingsViewControllerDelegate: class {
    func userProfileEdited()
}

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    private var settingsView = SettingsView()
    
    weak var delegate: SettingsViewControllerDelegate?
    
    private var imageSelected = false
    private var imageTapped = false
    private var selectedImage = UIImage()
    private var usernameChanged = false
    private var updatedUsername: String?
    
    private let firebaseService = FirebaseService()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Selectors
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .down {
            self.showMenuVC()
        }
    }
    
    @objc func Keyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            view.layoutIfNeeded()
        }
    }
    
    @objc func showMenuVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        configureNavigationBar()
        configureSwipeGesture()
        configureSettingsView()
        configureKeyboard()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        
        navigationItem.title = "Settings"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage().systemImage(withSystemName: "chevron.left"), style: .plain, target: self, action: #selector(showMenuVC))
        
    }
    
    func configureSettingsView() {
        settingsView.delegate = self
        
        view.addSubview(settingsView)
        settingsView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.safeAreaLayoutGuide.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor)
        settingsView.set(email: user.email, placeholder: user.fullname)
        settingsView.nameTextField.delegate = self
    }
    
    private func configureSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    private func configureKeyboard() {
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - API
    
    func updateUserFullname(completion: @escaping() -> Void) {
        firebaseService.updateUserFullname(user: user, updatedUsername: updatedUsername) { (wasUpdateSuccessful) in
            if wasUpdateSuccessful == true {
                guard let username = self.updatedUsername else { return }
                self.user.fullname = username
                completion()
            } else {
                self.showNotification(title: "Error updating user Fullname", defaultAction: true, defaultActionText: "Ok") {}
                completion()
            }
        }
    }
    
    func updateProfileImage(completion: @escaping() -> Void) {
        let profileImg = selectedImage
        firebaseService.updateProfileImage(user: user, profileImg: profileImg) { (wasUpdateSuccessful, profileImageUrl) in
            if wasUpdateSuccessful == true {
                guard let url = profileImageUrl else { return }
                self.user.profileImageUrl = url
                completion()
            } else {
                self.showNotification(title: "Error updating user Profileimage", defaultAction: true, defaultActionText: "Ok") {}
                completion()
            }
        }
    }
}

// MARK: - SettingsViewDelegate

extension SettingsViewController: SettingsViewDelegate {
    func handleSelectProfilePhoto() {
        imageTapped = true
        handleSelectProfilePhotoTapped()
    }
    
    func handleActionButton() {
        showNotification(title: "Updating your profile", defaultAction: true, defaultActionText: "Ok") {}
        view.endEditing(true)
        
        let group = DispatchGroup()
        if imageSelected {
            group.enter()
            updateProfileImage(completion: {
                do { group.leave() }
            })
        }
        if usernameChanged {
            group.enter()
            updateUserFullname(completion: {
                do { group.leave() }
            })
        }
        group.notify(queue: .main) {
            self.delegate?.userProfileEdited()
        }
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension SettingsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func handleSelectProfilePhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        
        imageSelected = true
        selectedImage = profileImage
        
        self.dismiss(animated: true, completion: {
            self.settingsView.setSelectedImage(selectedImage: profileImage)
            self.configureUI()
        })
    }
}

// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let text = settingsView.getTextFromNameTextField()
        
        let trimmedString = text?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        guard user.fullname != trimmedString else {
            showNotification(title: "You did not change you username", defaultAction: true, defaultActionText: "Ok") {}
            print("ERROR: You did not change you username")
            usernameChanged = false
            return
        }
        
        guard trimmedString != "" else {
            showNotification(title: "Please enter a valid username", defaultAction: true, defaultActionText: "Ok") {}
            print("ERROR: Please enter a valid username")
            usernameChanged = false
            return
        }
        
        updatedUsername = trimmedString?.lowercased()
        usernameChanged = true
    }
}
