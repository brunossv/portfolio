//
//  MessageChatViewModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 02/08/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation

class MessageChatViewModel {
    private let model: MessageChatModel = MessageChatModel()
    
    
    
    var messages: [[MessageChat]]?
    
    func downloadAndSaveNewMessages() {
        
        let groupMessages: (([MessageChat]) -> [[MessageChat]]) = { (messages) in
            
            var array: [[MessageChat]] = [[]]
            let groupedMessages = Dictionary(grouping: messages) { (element) -> Date in
                let date = DateFormatter()
                date.dateFormat = "yyyy-MM-dd"
                if let sendDate = element.sendDate {
                    return date.date(from: date.string(from: sendDate)) ?? Date()
                } else if let createdDate = element.createdDate {
                    return date.date(from: date.string(from: createdDate)) ?? Date()
                } else {
                    return date.date(from: date.string(from: Date())) ?? Date()
                }
            }
            //provide a sorting for your keys somehow
            let sortedKeys = groupedMessages.keys.reversed()
            sortedKeys.forEach { (key) in
                let values = groupedMessages[key]
                array.append(values ?? [])
            }
            
            return array
        }
        
        self.messages = groupMessages(self.model.searchAllMessages() ?? [])
    }
    
    func sendNewMessage( message: String?, _ completion: @escaping () -> Void) {
        self.model.saveNewMessages()
    }
    
    func saveCurrentUser(_ name: String?) {
        self.model.saveCurrentUser(name)
    }
    
    var currentUser: CurrentUser? {
        return self.model.currentUser()
    }
}
