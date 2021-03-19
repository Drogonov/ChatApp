//
//  User.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import Foundation

struct User {
    let uid: String
    let email: String
    var fullname: String?
    var profileImageUrl: String?
    
    var initialForProfileImage: String { return String(fullname?.prefix(2) ?? uid.prefix(2)) }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
