//
//  Service.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import Firebase

// MARK: - DatabaseRefs

let STORAGE_REF = Storage.storage().reference()

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_MESSAGES = DB_REF.child("messages")


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
    
    func fetchMessagesKeys(completion: @escaping([String]) -> Void) {
        REF_MESSAGES.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let messages = snapshot.value as! NSDictionary
                let messagesKeyArray = messages.allKeys as! [String]
                completion(messagesKeyArray)
            }
        }
    }
    
    func fetchMessage(messageKey: String, completion: @escaping(Message) -> Void) {
        REF_MESSAGES.child(messageKey).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let message = Message(dictionary: dictionary)
            completion(message)
        }
    }
    
    func fetchMessages(completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        fetchMessagesKeys { (keys) in
            let group = DispatchGroup()
            for i in 0..<keys.count {
                group.enter()
                fetchMessage(messageKey: keys[i]) { (message) in defer { group.leave() }
                    messages.append(message)
                }
            }
            group.notify(queue: .main) {
                completion(messages)
            }
        }
    }
    
    // MARK: - ChangeData
    
    func updateUserValues(uid: String, values: [String: Any], completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func uploadMessage(messageText: String, fromId: String, fromName: String?, imageUrl: String?, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let values = ["messageText": messageText,
                      "fromId": fromId,
                      "fromName": fromName,
                      "imageUrl": imageUrl] as [String : Any]
        
        guard let messageID = REF_MESSAGES.childByAutoId().key else { return }
        REF_MESSAGES.child(messageID).updateChildValues(values) { (err, ref) in
            completion(err, ref)
        }
    }
}
