//
//  JogoDaMemoriaViewController.swift
//  Portifolio
//
//  Created by Bruno Soares on 19/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit

class JogoDaMemoriaViewController: UIViewController {
    
    lazy var jogoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    var viewModel: JogoDaMemoriaViewModel = JogoDaMemoriaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubViews()
        self.startTheGame()
        self.configureViewController()
    }
    
    func startTheGame() {
        self.jogoContainer.subviews.forEach({ $0.removeFromSuperview() })
        self.generateMemoryViews()
        self.jogoContainer.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cleanAllCards()
            self.jogoContainer.isUserInteractionEnabled = true
        }
        
    }
    
    func cleanAllCards() {
        self.jogoContainer.subviews.forEach({ ($0 as? UIButton)?.isSelected = false })
    }
    
    func configureViewController() {
        self.viewModel.updateViewCards = { [weak self] (card1, card2) in
            self?.stopWhenHitTwice()
            
            self?.jogoContainer.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.jogoContainer.isUserInteractionEnabled = true
                (self?.jogoContainer.viewWithTag(card1?.rawValue ?? 0) as? CardsView)?.isSelected = false
                (self?.jogoContainer.viewWithTag(card2?.rawValue ?? 0) as? CardsView)?.isSelected = false
            }
        }
    }
    
    func generateMemoryViews() {
        
        let cards: [JogoDaMemoriaViewModel.Cards] = JogoDaMemoriaViewModel.Cards.allCases.shuffled()
        
        var lastView: UIView = UIView()
        var firstViewLine: Bool = false
        
        for i in 0..<cards.count {
            let index = i + 1
            let cardView = CardsView()
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.tag = cards[i].rawValue
            cardView.setBackgroundImage(cards[i].cardImage, for: .selected)
            cardView.setBackgroundImage(UIImage(named: "noSelected"), for: .normal)
            cardView.isSelected = true
            cardView.addTarget(self, action: #selector(self.cardDidTapped(_:)), for: .touchUpInside)
            
            self.jogoContainer.addSubview(cardView)
            
            NSLayoutConstraint.activate([
                cardView.heightAnchor.constraint(equalToConstant: 65),
                cardView.widthAnchor.constraint(equalToConstant: 65),
            ])
            
            let offSetPadding: CGFloat = 10
            if index == 1 {
                NSLayoutConstraint.activate([
                    cardView.topAnchor.constraint(equalTo: self.jogoContainer.topAnchor, constant: offSetPadding),
                    cardView.leftAnchor.constraint(equalTo: self.jogoContainer.leftAnchor, constant: offSetPadding),
                ])
                
                lastView = cardView
                
            } else if i == cards.count - 1 {
                NSLayoutConstraint.activate([
                    cardView.topAnchor.constraint(equalTo: lastView.topAnchor),
                    cardView.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: offSetPadding),
                    cardView.rightAnchor.constraint(equalTo: self.jogoContainer.rightAnchor, constant: -offSetPadding),
                    cardView.bottomAnchor.constraint(equalTo: self.jogoContainer.bottomAnchor, constant: -offSetPadding)
                ])
                
            } else if (index % 4) == 0 {
                NSLayoutConstraint.activate([
                    cardView.topAnchor.constraint(equalTo: lastView.topAnchor),
                    cardView.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: offSetPadding),
                    cardView.rightAnchor.constraint(equalTo: self.jogoContainer.rightAnchor, constant: -offSetPadding)
                ])
                firstViewLine = true
                lastView = cardView
                
            } else {
                NSLayoutConstraint.activate([
                    cardView.topAnchor.constraint(equalTo: firstViewLine ? lastView.bottomAnchor : lastView.topAnchor, constant: firstViewLine ? offSetPadding : 0),
                    cardView.leftAnchor.constraint(equalTo: firstViewLine ? self.jogoContainer.leftAnchor : lastView.rightAnchor, constant: offSetPadding),
                ])
                firstViewLine = false
                lastView = cardView
            }
        }
        
    }
    
    func stopWhenHitTwice() {

    }
    
    @objc
    func cardDidTapped(_ sender: UIButton) {
        
        if let selectedCard = JogoDaMemoriaViewModel.Cards(rawValue: sender.tag) {
            guard let value = self.viewModel.cardsRightAwnser[selectedCard], !value else { return }
            
            if selectedCard == self.viewModel.cardsClicked.card1 {
                return
            } else {
                (self.jogoContainer.viewWithTag(sender.tag) as? CardsView)?.isSelected = true
                self.viewModel.selectACard(selectedCard)
            }
        }
    }
    
    func configureSubViews() {
        self.view.addSubview(self.jogoContainer)
        self.view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            self.jogoContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.jogoContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
}
