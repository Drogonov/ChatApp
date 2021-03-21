//
//  DataFetcher.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//

import Firebase

protocol DataFetcherDelegate {
    func fetchUserData(uid: String, completion: @escaping(User) -> Void)
    func fetchMessageData(messageKey: String, completion: @escaping(Message) -> Void)
    func fetchMessagesKeys(completion: @escaping([String]) -> Void)
}

class DataFetcher: DataFetcherDelegate {
    func fetchUserData(uid: String, completion: @escaping (User) -> Void) {
        DB.REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
    
    func fetchMessageData(messageKey: String, completion: @escaping (Message) -> Void) {
        DB.REF_MESSAGES.child(messageKey).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let message = Message(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(message)
            }
        }
    }
    
    func fetchMessagesKeys(completion: @escaping ([String]) -> Void) {
        DB.REF_MESSAGES.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let messages = snapshot.value as! NSDictionary
                let messagesKeyArray = messages.allKeys as! [String]
                DispatchQueue.main.async {
                    completion(messagesKeyArray)
                }
            }
        }
    }
    
    
}

