//
//  ViewPrincipalAPI.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation

class ViewPrincipalAPI {
    
    struct Resource {
        private static let url = "https://portfolio-brunovieira.herokuapp.com"
        
        static let perfilAndFeatures = Resource.url + "/dataSource"
    }
    
    let api = Services()
    
    func getViewPrincipalDataSource(_ completion: @escaping (_ model: ViewPrincipalModel?, _ error: String?) -> Void) {
        self.api.request(Resource.perfilAndFeatures) { (model: ViewPrincipalModel?, error) in
            completion(model, error)
        }
    }
}
