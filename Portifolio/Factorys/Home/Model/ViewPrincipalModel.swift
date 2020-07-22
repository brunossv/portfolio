//
//  ViewPrincipalModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation

struct ViewPrincipalModel: Decodable {
    var sections: Int?
    var perfil: Perfil?
    var features: [Features]?
    var learnMore: LearnMore?
    
    enum CodingKeys: String, CodingKey {
        case sections
        case perfil
        case features
        case learnMore = "learn_more"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.sections = try values.decode(Int.self, forKey: .sections)
        self.learnMore = try values.decode(LearnMore.self, forKey: .learnMore)
        self.features = try values.decode([Features].self, forKey: .features)
        self.perfil = try values.decode(Perfil.self, forKey: .perfil)
    }
    
    struct LearnMore: Decodable {
        var title: String?
        var html: String?
    }
    
    struct Perfil: Decodable {
        var name: String?
        var age: Int?
        var avatar: String?
        var position: String?
        var description: String?
    }
    
    struct Features: Decodable {
        var title: String?
        var id: Int?
        var available: Bool?
        var type: TypeFeature?
        
        enum CodingKeys: String, CodingKey {
            case title
            case id
            case available
        }
        
        init(from decoder: Decoder) throws {
            
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try values.decode(String.self, forKey: .title)
            self.id = try values.decode(Int.self, forKey: .id)
            self.available = try values.decode(Bool.self, forKey: .available)
            
            self.type = TypeFeature(rawValue: self.id ?? -1)
        }
        
        enum TypeFeature: Int {
            case jogoMemoria = 0
            case messages
            case caller
        }
    }
}
