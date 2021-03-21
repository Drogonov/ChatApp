//
//  DB.swift
//  ChatApp
//
//  Created by Admin on 19.03.2021.
//

import Foundation
import Firebase

struct DB {
    static let REF = Database.database().reference()
    static let REF_USERS = REF.child("users")
    static let REF_MESSAGES = REF.child("messages")
    
}

