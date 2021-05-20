//
//  JogoDaMemoriaTests.swift
//  PortifolioTests
//
//  Created by Bruno Soares on 21/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import XCTest
@testable import Portifolio

class JogoDaMemoriaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testHitAwnser() {
        let viewModel = JogoDaMemoriaViewModel()
        viewModel.selectACard(.bear)
        
        XCTAssertEqual(viewModel.cardsClicked.card1, .bear)
        
        //A partir da segunda carta selecionada, o model já é atualizado com o valor true, respectivo do conjunto acertado
        viewModel.selectACard(.equalBear)

        let cardsTrue = viewModel.cardsRightAwnser.filter( { $0.value == true })
        
        XCTAssertEqual(cardsTrue.count, 2)
        
        XCTAssertEqual(viewModel.cardsClicked.card1, nil)
        XCTAssertEqual(viewModel.cardsClicked.card2, nil)
        
    }
    
    func testMissAwnser() {
        let viewModel = JogoDaMemoriaViewModel()
        viewModel.selectACard(.bear)
        
        XCTAssertEqual(viewModel.cardsClicked.card1, .bear)
        
        viewModel.selectACard(.chicken)
        
        //Quando selecionar a segunda carta, esta clousure é chamada, informando que as cartas selecionadas, devem esconder a figura representativa.
        viewModel.updateViewCards = { (card1, card2) in
            XCTAssertEqual(card1, .bear)
            XCTAssertEqual(card2, .chicken)
        }

        //Verifica se existem cards marcados como true, quando o usuário errar
        let cardsTrue = viewModel.cardsRightAwnser.filter( { $0.value == true })
        XCTAssertEqual(cardsTrue.count, 0)
        
        XCTAssertEqual(viewModel.cardsClicked.card1, nil)
        XCTAssertEqual(viewModel.cardsClicked.card2, nil)
    }
    
    func testAllTheCardsMatch() {
        let viewModel = JogoDaMemoriaViewModel()
        viewModel.selectACard(.bear)
        viewModel.selectACard(.equalBear)
        viewModel.selectACard(.chicken)
        viewModel.selectACard(.equalChicken)
        viewModel.selectACard(.cow)
        viewModel.selectACard(.equalCow)
        viewModel.selectACard(.kangaroo)
        viewModel.selectACard(.equalKangaroo)
        viewModel.selectACard(.bird)
        viewModel.selectACard(.equalBird)
        viewModel.selectACard(.dog)
        viewModel.selectACard(.equalDog)
        viewModel.selectACard(.elephant)
        viewModel.selectACard(.equalElephant)
        viewModel.selectACard(.frog)
        viewModel.selectACard(.equalFrog)
        
        //Caso o número de acertos sejam iguais ao número de cards, o usuário marcou corretamente todos os cards.
        let cardsTrue = viewModel.cardsRightAwnser.filter( { $0.value == true })
        XCTAssertEqual(cardsTrue.count, JogoDaMemoriaViewModel.Cards.allCases.count)
    }

}
