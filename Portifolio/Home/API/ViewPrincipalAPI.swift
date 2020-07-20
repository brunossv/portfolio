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
        private static let url = "http://localhost:8080"
        
        static let perfilAndFeatures = Resource.url + "/DataSource"
    }
    
    let api = Services()
    
    func getViewPrincipalDataSource(_ completion: @escaping (_ model: ViewPrincipalModel?, _ error: String?) -> Void) {
        self.api.request(Resource.perfilAndFeatures) { (model: ViewPrincipalModel?, error) in
            completion(model, error)
        }
    }
}
