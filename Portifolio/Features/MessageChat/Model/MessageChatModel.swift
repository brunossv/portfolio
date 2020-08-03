//
//  MessageChatModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 02/08/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct MessageChatModel {
    private var context: NSManagedObjectContext = {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        return context ?? AppDelegate().persistentContainer.viewContext
    }()
    
    func currentUser() -> CurrentUser? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentUser")
        return try? self.context.fetch(fetch).first as? CurrentUser
    }
    
    func saveCurrentUser(_ name: String?) {
        let currentUser = NSEntityDescription.insertNewObject(forEntityName: "CurrentUser", into: self.context)
        (currentUser as? CurrentUser)?.name = name
    }
    
    func saveNewMessage(_ text: String?) -> MessageChat? {
        guard let userMessage = NSEntityDescription.insertNewObject(forEntityName: "MessageChat",
                                                                    into: self.context) as? MessageChat else { return nil }
        userMessage.sendDate = Date()
        userMessage.text = text
        userMessage.createdDate = Date()
        
        let userModel = NSEntityDescription.insertNewObject(forEntityName: "UserChat", into: self.context) as? UserChat
        userModel?.name = self.currentUser()?.name
        userMessage.user = userModel
        
        return userMessage
    }
    
    func saveNewsMessagesFromWeb(_ messages: [MessageChatReceivedModel]) {
        
        for message in messages {
            
            guard let userMessage = NSEntityDescription.insertNewObject(forEntityName: "MessageChat",
                                                                        into: self.context) as? MessageChat else { return }
            userMessage.deliveryDate = message.deliveryDate
            userMessage.sendDate = message.sendDate
            userMessage.text = message.text
            userMessage.createdDate = Date()
            
            if let userResult = self.searchUser(by: message.user?.name) {
                userResult.addToMessages(userMessage)
            } else {
                let userModel = NSEntityDescription.insertNewObject(forEntityName: "UserChat", into: self.context)
                (userModel as? UserChat)?.name = message.user?.name
                (userModel as? UserChat)?.addToMessages(userMessage)
            }
            
            try? self.context.save()
        }
    }
    
    func searchAllMessages() -> [MessageChat]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageChat")
        return try? self.context.fetch(fetchRequest) as? [MessageChat]
    }
    
    func searchUser(by name: String?) -> UserChat? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserChat")
        fetch.predicate = NSPredicate(format: "name == %@", name ?? "")
        
        return try? self.context.fetch(fetch).first as? UserChat
    }
}


struct MessageChatReceivedModel: Decodable {
    var deliveryDate: Date?
    var sendDate: Date?
    var text: String?
    var user: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case user
        case deliveryDate
        case sendDate
        case text
    }
    
    init() { }
    
    init(from decoder: Decoder) throws {
        
        let translateDate: ((String?) -> Date?) = { (dateString) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: dateString ?? "")
        }
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.user = try values.decode(UserModel.self, forKey: .user)
        self.text = try values.decode(String.self, forKey: .text)
        self.deliveryDate = translateDate(try values.decode(String.self, forKey: .deliveryDate))
        self.sendDate = translateDate(try values.decode(String.self, forKey: .sendDate))
    }
    
    struct UserModel: Decodable {
        var name: String?
    }
}
