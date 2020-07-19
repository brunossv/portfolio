//
//  ViewFactorys.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit

class ViewFactorys {
    
    static func labels(_ font: UIFont = .systemFont(ofSize: 13), color: UIColor = .white, align: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.textAlignment = align
        label.font = font
        label.textColor = color
        label.text = " "
        
        return label
    }
}
