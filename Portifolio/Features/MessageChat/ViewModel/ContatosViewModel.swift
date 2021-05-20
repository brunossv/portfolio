//
//  ContatosViewModel.swift
//  Portifolio
//
//  Created by Bruno Vieira on 04/05/21.
//  Copyright © 2021 Bruno Vieira. All rights reserved.
//

import Foundation

class ContatosViewModel {
    private let model: MessageChatModel = MessageChatModel()

    var api = MessageChatAPI()
    
    var contatos: [UserChat]? {
        return self.model.getAllUsers()
    }
    
    func saveCurrentUser(_ name: String,_ completion: @escaping (String?) -> Void) {
        self.api.createUser(nome: name) { (model, error) in
            if let msgError = error {
                completion(msgError)
                return
            }
            if let userId = model?.id {
                self.model.saveCurrentUser(Int16(userId), name)
                completion(nil)
            } else {
                completion("Erro ao criar usuário")
            }
        }
    }
    
    func getAllUsers(_ completion: @escaping (String?) -> Void) {
        guard let idCurrentUser = self.currentUser?.id  else {
            completion("Usuário não cadastrado")
            return
        }
        self.api.getAllUsers(id: Int(idCurrentUser)) { (model, error) in
            self.model.saveNewUsers(users: model ?? [])
            completion(error)
        }
    }
    
    func fetchLastMessage(index: Int) -> MessageChat? {
        if let contatos = contatos, index < contatos.count {
            let idContato = contatos[index].id
            
            return self.model.getLastMessage(from: idContato, and: self.currentUser?.id ?? 0)
        }
        
        return nil
    }
    
    func formatarMensagemData(msgData: Date?) -> String? {
        guard let data = msgData else {
            return nil
        }
        
        let calendar = Calendar(identifier: .gregorian)
        
        if calendar.isDateInToday(data) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: data)
            
        } else if calendar.isDateInYesterday(data) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: data)
        }
    }
    
    var currentUser: CurrentUser? {
        return self.model.currentUser
    }
    
    func listemNewMessages() {
        let user = self.model.currentUser?.id ?? 0
        MessageSingleton.shared.configure(listem: "\(user)")
    }
}
