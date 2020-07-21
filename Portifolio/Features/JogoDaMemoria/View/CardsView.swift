//
//  CardsView.swift
//  Portifolio
//
//  Created by Bruno Soares on 20/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit

class CardsView: UIButton {
    
    var isClicked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
