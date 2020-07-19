//
//  ViewPrincipalModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation

struct ViewPrincipalModel: Decodable {
    var perfil: Perfil?
    var features: [Features]?
    var learnMore: LearnMore?
    
    enum CodingKeys: String, CodingKey {
        case perfil
        case features
        case learnMore = "learn_more"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
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
    }
}
