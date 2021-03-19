//
//  DatabaseRef.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//

import Foundation
import Firebase

struct DatabaseRef {
    
    static let DB_REF = Database.database().reference()
    static let REF_USERS = DB_REF.child("users")
    static let REF_MESSAGES = DB_REF.child("messages")
    
}

