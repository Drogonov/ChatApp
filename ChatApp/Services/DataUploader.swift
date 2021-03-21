//
//  DataUploader.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//

import Firebase

protocol DataUploaderDelegate {
    func updateUserValues(uid: String, values: [String: Any], completion: @escaping(Error?, DatabaseReference) -> Void)
    func uploadMessage(messageText: String, fromId: String, fromName: String?, imageUrl: String?, completion: @escaping (Error?, DatabaseReference) -> Void)
    
}

class DataUploader: DataUploaderDelegate {
    func updateUserValues(uid: String, values: [String : Any], completion: @escaping (Error?, DatabaseReference) -> Void) {
        DB.REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    func uploadMessage(messageText: String, fromId: String, fromName: String?, imageUrl: String?, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let values = ["messageText": messageText,
                      "fromId": fromId,
                      "fromName": fromName as Any,
                      "imageUrl": imageUrl as Any] as [String : Any]
        
        guard let messageID = DB.REF_MESSAGES.childByAutoId().key else { return }
        DB.REF_MESSAGES.child(messageID).updateChildValues(values) { (err, ref) in
            completion(err, ref)
        }
    }
}


