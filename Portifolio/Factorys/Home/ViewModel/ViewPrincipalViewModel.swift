//
//  ViewPrincipalViewModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation

class ViewPrincipalViewModel {
    private let api = ViewPrincipalAPI()
    var model: ViewPrincipalModel?
    
    func getConfig(_ completion: @escaping (_ error: String?) -> Void) {
        
        self.api.getViewPrincipalDataSource { (model, error) in
            self.model = model
            completion(error)
        }
    }
}
