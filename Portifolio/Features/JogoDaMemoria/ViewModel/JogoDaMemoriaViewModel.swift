//
//  JogoDaMemoriaViewModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 19/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit

class JogoDaMemoriaViewModel {
    enum Cards: Int, CaseIterable {
        case cow = 1
        case chicken = 3
        case cat
        case dog
        case hourse
        case tartaruga
        case baleia
        case leao
        
        var equalCardTag: Int {
            return (self.rawValue + 1)
        }
        
        var cardImage: UIColor {
            switch self {
            case .cow:
                return .red
            case .chicken:
                return .blue
            case .cat:
                return .green
            case .dog:
                return .purple
            case .hourse:
                return .systemPink
            case .tartaruga:
                return .yellow
            case .baleia:
                return .gray
            case .leao:
                return .orange
            }
        }
    }
}
