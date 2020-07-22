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
        case equalCow
        case chicken
        case equalChicken
        case bear
        case equalBear
        case dog
        case equalDog
        case elephant
        case equalElephant
        case frog
        case equalFrog
        case bird
        case equalBird
        case kangaroo
        case equalKangaroo
        
        var cardImage: UIImage? {
            switch self {
            case .cow, .equalCow:
                return UIImage(named: "cow")
            case .chicken, .equalChicken:
                return UIImage(named: "chicken")
            case .bear, .equalBear:
                return UIImage(named: "bear")
            case .dog, .equalDog:
                return UIImage(named: "dog")
            case .elephant, .equalElephant:
                return UIImage(named: "elephant")
            case .frog, .equalFrog:
                return UIImage(named: "frog")
            case .bird, .equalBird:
                return UIImage(named: "bird")
            case .kangaroo, .equalKangaroo:
                return UIImage(named: "kangaroo")
            }
        }
        
        var reletedTo: Cards {
            switch self {
            
            case .cow:
                return .equalCow
            case .equalCow:
                return .cow
            case .chicken:
                return .equalChicken
            case .equalChicken:
                return .chicken
            case .bear:
                return .equalBear
            case .equalBear:
                return .bear
            case .dog:
                return .equalDog
            case .equalDog:
                return .dog
            case .elephant:
                return .equalElephant
            case .equalElephant:
                return .elephant
            case .frog:
                return .equalFrog
            case .equalFrog:
                return .frog
            case .bird:
                return .equalBird
            case .equalBird:
                return .bird
            case .kangaroo:
                return .equalKangaroo
            case .equalKangaroo:
                return .kangaroo
            }
        }
        
    }
    
    var updateViewCards: ((_ card1: Cards?,_ card2: Cards?) -> Void)?
    
    var cardsRightAwnser: [Cards:Bool] = {
        var array: [Cards:Bool] = [:]
        
        for card in Cards.allCases {
            array[card] = false
        }
        return array
    }()
    
    var cardsClicked: (card1: Cards?, card2: Cards?) = (nil, nil)
    
    private func checkinBothCardsClicked() {
        
        defer {
            self.cardsClicked = (nil, nil)
        }
        
        if let card1 = self.cardsClicked.card1, let card2 = self.cardsClicked.card2, card1 == card2.reletedTo {
            self.cardsRightAwnser[card1] = true
            self.cardsRightAwnser[card2] = true
        } else {
            self.updateViewCards?(self.cardsClicked.card1, self.cardsClicked.card2)
        }
    }
    
    func selectACard(_ card: Cards) {

        if let _ = self.cardsClicked.card1 {
            self.cardsClicked.card2 = card
            self.checkinBothCardsClicked()
        } else {
            self.cardsClicked.card1 = card
        }
    }
    
}
