//
//  MessageSingleton.swift
//  Portifolio
//
//  Created by Bruno Vieira on 05/05/21.
//  Copyright © 2021 Bruno Vieira. All rights reserved.
//

import SocketIO

class MessageSingleton {
    
    struct Resources {
//                private static var url: String { return "http://localhost:5000" }
                private static var url: String { return "https://arctec.herokuapp.com/" }
        
        static var socket: String { get { return Resources.url } }
    }
    
    static let shared: MessageSingleton = MessageSingleton()
    
    private var manager: SocketManager = SocketManager(socketURL: URL(string: Resources.socket)!, config: [.reconnectWait(1), .reconnects(true), .compress, .log(true)])
    
    var socket: SocketIOClient?
    
    var didReceiveMessage: (() -> Void)?
    var didConnect: (() -> Void)?
    var didDisconnect: (() -> Void)?
    
    private init() { }
    
    func configure(listem: String) {
        self.socket = self.manager.defaultSocket
        
        self.socket?.on("connect") { [weak self] (data, emiter) in
            print("didConnect")
            self?.didConnect?()
        }
        
        self.socket?.on("error") { [weak self] (data, emiter) in
            print(data)
            print("connect_error")
            guard let socket = self?.socket else { return }
            
            if socket.status == .disconnected {
                self?.didDisconnect?()
            }
        }
        
        self.socket?.on("reconnects") { [weak self] (data, emiter) in
            print(data)
            print("disconnect")
            guard let socket = self?.socket else { return }
            
            if socket.status == .disconnected {
                self?.didDisconnect?()
            }
        }

        self.socket?.on(listem) { [weak self] (data, emiter) in

            if let data = data.first as? [String:Any],
               let id = data["from_id"] as? Int,
               let text = data["text"] as? String,
               let name = data["from_name"] as? String {
                
                let model = MessageChatModel()
                model.saveReceivedMessage(text, from: name, and: id, date: Date())
                
                self?.didReceiveMessage?()
            }
        }
        
        self.socket?.connect()
    }
    
    func emit(parametro: [String:Any], _ completion: @escaping () -> Void) {
        self.socket?.emit("talkingTo", parametro) {
            completion()
        }
    }
}

struct SocketParametros: SocketData {
    var id: String
    var text: String
    
    init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}
