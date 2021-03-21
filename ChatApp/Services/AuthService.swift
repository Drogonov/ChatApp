//
//  AuthService.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//

import Firebase

protocol AuthServiceDelegate {
    func handleLogin(email: String, password: String, completion: @escaping(Bool) -> Void)
    func handleSignUp(email: String, password: String, completion: @escaping(Bool) -> Void)
}

class AuthService: AuthServiceDelegate {
    
    // MARK: - Properties
    
    private let dataUploader: DataUploaderDelegate
    
    // MARK: - Init
    
    init(dataUploader: DataUploaderDelegate = DataUploader()) {
        self.dataUploader = dataUploader
    }
    
    // MARK: - Delegate Methods
    
    func handleLogin(email: String, password: String, completion: @escaping(Bool) -> Void) {
        var wasAuthSuccessful = true
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                wasAuthSuccessful = false
                completion(wasAuthSuccessful)
                print("DEBUG: Failed to log user in with error \(error.localizedDescription)")
                return
            }
            completion(wasAuthSuccessful)
        }
    }
    
    func handleSignUp(email: String, password: String, completion: @escaping(Bool) -> Void) {
        var wasSignUpSuccessful = true
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                wasSignUpSuccessful = false
                completion(wasSignUpSuccessful)
                print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            let values = ["email": email] as [String : Any]
            
            self.dataUploader.updateUserValues(uid: uid, values: values) { (err, ref) in
                if let error = error {
                    wasSignUpSuccessful = false
                    completion(wasSignUpSuccessful)
                    print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                    return
                }
            }
            completion(wasSignUpSuccessful)
        }
    }
}
