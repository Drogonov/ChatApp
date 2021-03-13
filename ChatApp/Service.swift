//
//  Service.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import Firebase

// MARK: - DatabaseRefs

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
    static let shared = Service()
    
    func connectionCheck(completion: @escaping(Bool) -> Void) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { (snapshot) in
          if snapshot.value as? Bool ?? false {
            completion(true)
          } else {
            completion(false)
          }
        })
    }
    
    // MARK: - FetchData
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    // MARK: - ChangeData
    
    func updateUserValues(uid: String, values: [String: Any], completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
}
