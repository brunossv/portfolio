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
    }
    
    func startTheGame() {
        self.jogoContainer.subviews.forEach({ $0.removeFromSuperview() })
        self.generateMemoryViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.cleanAllCards()
        }
        
    }
    
    func cleanAllCards() {
        self.jogoContainer.subviews.forEach({ ($0 as? UIButton)?.isSelected = false })
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
        self.jogoContainer.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCards()
            self.jogoContainer.isUserInteractionEnabled = true
        }
    }
    
    func updateCards() {
        
        for (key, value) in self.viewModel.cardsSelected {
            if value && self.viewModel.cardsSelected[key.reletedTo] ?? false {
                (self.jogoContainer.viewWithTag(key.rawValue) as? CardsView)?.isSelected = value
                (self.jogoContainer.viewWithTag(key.reletedTo.rawValue) as? CardsView)?.isSelected = value
            } else {
                (self.jogoContainer.viewWithTag(key.rawValue) as? CardsView)?.isSelected = false
                (self.jogoContainer.viewWithTag(key.reletedTo.rawValue) as? CardsView)?.isSelected = false
                self.viewModel.cardsSelected[key] = false
                self.viewModel.cardsSelected[key.reletedTo] = false
            }
        }
    }
    
    @objc
    func cardDidTapped(_ sender: UIButton) {
        
        
        if let card = JogoDaMemoriaViewModel.Cards(rawValue: sender.tag) {
            guard let value = self.viewModel.cardsSelected[card], !value else { return }
            
            self.viewModel.cardsSelected[card] = true
            (self.jogoContainer.viewWithTag(sender.tag) as? CardsView)?.isSelected = true
        }
        
        if self.viewModel.cardsClicked.card1 {
            self.viewModel.cardsClicked.card2 = true
            self.stopWhenHitTwice()
        } else {
            self.viewModel.cardsClicked.card1 = true
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
