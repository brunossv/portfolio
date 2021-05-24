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
    
    var currentUser: CurrentUser? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentUser")
        if let currentUser = try? self.context.fetch(fetch).first, let user = currentUser as? CurrentUser {
            return user
        }
        return nil
    }
    
    func saveCurrentUser(_ id: Int16,_ name: String?) {
        let currentUser = NSEntityDescription.insertNewObject(forEntityName: "CurrentUser", into: self.context) as? CurrentUser
        currentUser?.name = name
        currentUser?.id = id
        
        try? self.context.save()
    }
    
    func saveSendedMessage(_ text: String?, to idUser: Int, sendDate: Date) -> MessageChat? {
        guard let sendedMessage = NSEntityDescription.insertNewObject(forEntityName: "MessageChat",
                                                                    into: self.context) as? MessageChat else { return nil }
        sendedMessage.sendDate = sendDate
        sendedMessage.deliveryDate = sendDate
        sendedMessage.text = text
        sendedMessage.createdDate = Date()
        
        if let currentUser = self.currentUser, let userContact = self.searchUser(by: idUser) {
            currentUser.addToSend(sendedMessage)
            userContact.addToReceived(sendedMessage)
        }
        try? self.context.save()
        return sendedMessage
    }
    
    func saveReceivedMessage(_ text: String?, from name: String, and id: Int, date: Date) {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "MessageChat",
                                                                into: self.context) as? MessageChat else { return }
        message.text = text
        message.createdDate = date
        message.deliveryDate = date
        message.read = false
        
        if let userFrom = self.searchUser(by: id), let currentUser = self.currentUser {
            currentUser.addToReceived(message)
            userFrom.addToSend(message)
            
            try? self.context.save()
        } else if let userFrom = NSEntityDescription.insertNewObject(forEntityName: "UserChat", into: self.context) as? UserChat,
                  let currentUser = self.currentUser {
            userFrom.id = Int16(id)
            userFrom.name = name
            
            currentUser.addToReceived(message)
            userFrom.addToSend(message)
            
            try? self.context.save()
            
        } else {
             return
        }
    }
    
    func saveNewsMessagesFromWeb(_ messages: [MessageChatReceivedModel]) {
        
        for message in messages {
            
            guard let userMessage = NSEntityDescription.insertNewObject(forEntityName: "MessageChat",
                                                                        into: self.context) as? MessageChat else { return }
            userMessage.deliveryDate = message.deliveryDate
            userMessage.sendDate = message.sendDate
            userMessage.text = message.text
            userMessage.createdDate = Date()
            
//            if let userResult = self.searchUser(by: message.userId ?? -1) {
//                userResult.addToMessages(userMessage)
//            } else {
//                let userModel = NSEntityDescription.insertNewObject(forEntityName: "UserChat", into: self.context)
//                (userModel as? UserChat)?.name = "Desconhecido"
//                (userModel as? UserChat)?.addToMessages(userMessage)
//            }
            
            try? self.context.save()
        }
    }
    
    func getAllMessages(from fromId: Int16, and currentUserId: Int16) -> [MessageChat]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageChat")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: true)]
//        fetchRequest.predicate = NSPredicate(format: "ANY self.to.id == \(currentUserId) AND ANY self.from.id == \(fromId)")
        fetchRequest.predicate = NSPredicate(format: "self.to.id == \(fromId) AND self.from.id == \(currentUserId) OR self.to.id == \(currentUserId) AND self.from.id == \(fromId)")
        
        return try? self.context.fetch(fetchRequest) as? [MessageChat]
    }
    
    func getLastMessage(from fromId: Int16, and currentUserId: Int16) -> MessageChat? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageChat")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "self.to.id == \(currentUserId) AND self.from.id == \(fromId) || self.to.id == \(fromId) AND self.from.id == \(currentUserId)")
        if let message = try? self.context.fetch(fetchRequest).first as? MessageChat {
            return message
        }
        return nil
    }
    
    func markReadMessagesDidntReaded(from fromId: Int16, and currentUserId: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageChat")
        fetchRequest.predicate = NSPredicate(format: "self.read == false AND self.to.id == \(fromId) AND self.from.id == \(currentUserId)")
        
        if let messages = try? self.context.fetch(fetchRequest) as? [MessageChat] {
            for message in messages {
                message.read = true
            }
            try? self.context.save()
        }
        return
    }
    
    func countMessagesDidntRead(from fromId: Int16, and currentUserId: Int16) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageChat")
        fetchRequest.predicate = NSPredicate(format: "self.read == false AND self.to.id == \(fromId) AND self.from.id == \(currentUserId)")
        
        if let messages = try? self.context.fetch(fetchRequest) as? [MessageChat] {
            return messages.count
        }
        return 0
    }
    
    @discardableResult
    func createUserChat(id: Int16, nome: String) -> UserChat? {
        let userModel = NSEntityDescription.insertNewObject(forEntityName: "UserChat", into: self.context) as? UserChat
        userModel?.name = nome
        userModel?.id = id
        
        try? self.context.save()
        
        return userModel
    }
    
    func saveNewUsers(users: [ContatosModel]) {
        for user in users {
            if self.searchUser(by: user.id ?? -1) == nil {
                self.createUserChat(id: Int16(user.id ?? -1), nome: user.nome ?? "")
            } else {
                continue
            }
        }
    }
    
    func getAllUsers() -> [UserChat]? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserChat")
        fetch.predicate = NSPredicate(format: "self.id != \(self.currentUser?.id ?? -1)")
        return try? self.context.fetch(fetch) as? [UserChat]
    }
    
    func searchUser(by id: Int) -> UserChat? {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserChat")
        fetch.predicate = NSPredicate(format: "id == \(id)")
        
        if let foundedUser = try? self.context.fetch(fetch).first {
            return foundedUser as? UserChat
        }
        return nil
    }
}


struct MessageChatReceivedModel: Decodable {
    var deliveryDate: Date?
    var sendDate: Date?
    var text: String?
    var userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case user = "user_id"
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
        
        self.userId = try values.decode(Int.self, forKey: .user)
        self.text = try values.decode(String.self, forKey: .text)
        self.deliveryDate = translateDate(try values.decode(String.self, forKey: .deliveryDate))
        self.sendDate = translateDate(try values.decode(String.self, forKey: .sendDate))
    }
    
    struct UserModel: Decodable {
        var name: String?
    }
}
