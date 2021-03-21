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
    
    var imageSelected = false
    var imageTapped = false
    var selectedImage = UIImage()
    var usernameChanged = false
    var updatedUsername: String?
    
    weak var delegate: SettingsViewControllerDelegate?
    
    let alert = UIAlertController(title: nil,
                                  message: "Updating your profile",
                                  preferredStyle: .alert)
    
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
        if gesture.direction == .down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func Keyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            view.layoutIfNeeded()
        }
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
    
    func handleUpdateProfile() {
        self.present(alert, animated: true, completion: nil)
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
            self.userProfileEdited()
        }

        
        //        if imageSelected {
        //            updateProfileImage()
        //        }
        //
        //        if usernameChanged {
        //            updateUserFullname()
        //        }
        //
        //        userProfileEdited()
    }
    
    
    func updateUserFullname(completion: @escaping() -> Void) {
        print("updateUserFullname start")
        
        let fullname = updatedUsername ?? self.user.fullname ?? ""
        
        let values = ["fullname": fullname] as [String : Any]
        
        DB.REF_USERS.child(user.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to update user fullname with error \(error.localizedDescription)")
                return
            }
            
            self.user.fullname = fullname
            print("updateUserFullname end")
            completion()
        })
        
    }
    
    func updateProfileImage(completion: @escaping() -> Void) {
        print("updateProfileImage start")
        let profileImg = selectedImage
        guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        
        if self.user.profileImageUrl == "" {
            uploadProfileImage(withData: uploadData, withFilename: filename, completion: completion)
        } else {
            deleteImageFromStorage(completion: {
                self.uploadProfileImage(withData: uploadData, withFilename: filename, completion: completion)
            })
        }
    }
    
    func uploadProfileImage(withData uploadData: Data, withFilename filename: String, completion: @escaping() -> Void) {
        
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            
            if let error = error {
                print("DEBUG: Failed to upload image to Firebase Storage with error", error.localizedDescription)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, error) in
                guard let profileImageUrl = downloadURL?.absoluteString else {
                    print("DEBUG: Profile image url is nil")
                    return
                }
                self.user.profileImageUrl = profileImageUrl
                
                DB_REF.child("users/\(self.user.uid)/profileImageUrl").setValue(profileImageUrl) { (error, ref) in
                    if let error = error {
                        print("DEBUG: Failed to update user profile URL in Firebase", error.localizedDescription)
                        return
                    }
                    print("updateProfileImage end")
                    completion()
                }
            })
        })
    }
    
    func deleteImageFromStorage(completion: @escaping() -> Void) {
        guard let storagePath = user.profileImageUrl else { return }
        let desertRef = Storage.storage().reference(forURL: storagePath)
        desertRef.delete { error in
            if let error = error {
                print("DEBUG: Failed to delete image", error.localizedDescription)
                return
            }
            completion()
        }
    }
    
    func userProfileEdited() {
        print("userProfileEdited start")
        
        self.alert.dismiss(animated: true, completion: {
            //            self.delegate?.userProfileEdited()
            print("userProfileEdited end")
        })
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //            self.alert.dismiss(animated: true, completion: {
        //                self.delegate?.userProfileEdited()
        //            })
        //        }
    }
}

// MARK: - SettingsViewDelegate

extension SettingsViewController: SettingsViewDelegate {
    func handleSelectProfilePhoto() {
        print("handleSelectProfilePhoto")
        imageTapped = true
        handleSelectProfilePhotoTapped()
    }
    
    func handleActionButton() {
        print("handleActionButton")
        handleUpdateProfile()
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
            print("ERROR: You did not change you username")
            usernameChanged = false
            return
        }
        
        guard trimmedString != "" else {
            print("ERROR: Please enter a valid username")
            usernameChanged = false
            return
        }
        
        updatedUsername = trimmedString?.lowercased()
        usernameChanged = true
    }
}
