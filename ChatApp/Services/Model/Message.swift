//
//  Message.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import Foundation
import Firebase

struct Message: Comparable {
    
    var messageText: String
    var fromId: String
    var fromName: String?
    var imageUrl: String?
    var creationDate: Date
    var initialForProfileImage: String { return String(fromName?.prefix(2) ?? fromId.prefix(2)) }
    
    init(dictionary: [String: Any]) {
        self.messageText = dictionary["messageText"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.fromName = dictionary["fromName"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.creationDate = Date(timeIntervalSince1970: dictionary["creationDate"] as? Double ?? 0)
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}
