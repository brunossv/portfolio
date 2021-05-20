//
//  MessageChatAPI.swift
//  Portifolio
//
//  Created by Bruno Vieira on 04/05/21.
//  Copyright © 2021 Bruno Vieira. All rights reserved.
//

import Foundation

struct Default<I: Decodable>: Decodable {
    var response: I?
    var message: String?
    var status: Int?
}

struct EmptyResponse: Decodable {
    var string: String?
}

class MessageChatAPI {
    struct Resources {
        private static var url: String { return "http://localhost:5000" }
//        private static var url: String { return "https://arctec.herokuapp.com" }
        
        static var createUser: String { return Resources.url + "/newUser"}
        static var getAllUsers: String { return Resources.url + "/getAllUsers"}
    }

    func getAllUsers(id: Int, _ completion: @escaping ([ContatosModel]?, String?) -> Void) {
        let parametros: [String:Any] = [
            "id":id
        ]
        
        Services().request(Resources.getAllUsers, parameters: parametros) { (model: Default<Array<ContatosModel>>?, error) in
            completion(model?.response, error)
        }
    }
    
    func createUser(nome: String, _ completion: @escaping (ContatosModel?, String?) -> Void) {
        let parametros: [String:Any] = [
            "nome":nome
        ]
        let headers: [String:String] = [
            "Content-Type":"application/json"
        ]
        Services().request(Resources.createUser, method: .post, parameters: parametros, headers: headers) { (model: Default<ContatosModel>?, error) in
            completion(model?.response, error)
        }
    }
}
