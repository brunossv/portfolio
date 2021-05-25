//
//  MessageChatViewModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 02/08/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation

class MessageChatViewModel {
    let model: MessageChatModel = MessageChatModel()
    var chatUser: UserChat?
    var messages: [[MessageChat]]? = []
    
    func downloadNewsMessages(_ completion: @escaping () -> Void) {
        
        let groupMessages: (([MessageChat]) -> [[MessageChat]]) = { (messages) in
            
            var array: [[MessageChat]] = [[]]
            let arraySorted = messages.sorted(by: { $0.createdDate ?? Date() < $1.createdDate ?? Date() })
            let groupedMessages = Dictionary(grouping: arraySorted) { (element) -> Date in
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
            
            let sortedKeys = groupedMessages.keys.sorted(by: { $0 < $1 })
            sortedKeys.forEach { (key) in
                print(key)
                let values = groupedMessages[key]
                array.append(values ?? [])
            }
            
            return array
        }
        
        self.messages = groupMessages(self.model.getAllMessages(from:  self.chatUser?.id ?? 0, and: self.model.currentUser?.id ?? 0) ?? [])
        completion()
    }
    
    func sendNewMessage( message: String?, _ completion: @escaping () -> Void) {
        guard let messages = self.messages else { return }
        let lastIndex = messages.count - 1
        if let newMessage = message,
           let idUser = self.chatUser?.id,
           let fromName = self.model.currentUser?.name,
           let fromId = self.model.currentUser?.id,
           lastIndex < messages.count {
            
            let parameters: [String:Any] = [
                "to_id":idUser,
                "from_id":fromId,
                "from_name":fromName,
                "text":newMessage
            ]
            
            MessageSingleton.shared.emit(parametro: parameters) { [weak self] in
                guard let _ = self?.model.saveSendedMessage(newMessage, to: Int(idUser), sendDate: Date()) else { return }
                completion()
            }
        }
    }
    
    func markAllReaded() {
        if let currentUser = self.model.currentUser?.id, let idContato = self.chatUser?.id {
            self.model.markReadMessagesDidntReaded(from: idContato, and: currentUser)
        }
        
        return
    }
}
