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
    
    lazy var conometroContainer: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.6784313725, blue: 0.9490196078, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.masksToBounds = true
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        view.text = "0:0"
        
        return view
    }()
    
    var viewModel: JogoDaMemoriaViewModel = JogoDaMemoriaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubViews()
        self.configureViewController()
    }
    
    func startTheGame() {
        self.createCronometreView()
        self.generateMemoryViews()
        self.startTheGameAnimation()
        self.viewModel.startTheGame()
        self.jogoContainer.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.cleanAllCards()
            self.jogoContainer.isUserInteractionEnabled = true
        }
    }
    
    func stopTheGame() {
        self.conometroContainer.text = "0:0"
        self.viewModel.stopTheGame()
        self.stopTheGameAnimation()
    }
    
    func createCronometreView() {
        self.view.addSubview(self.conometroContainer)
        
        NSLayoutConstraint.activate([
            self.conometroContainer.topAnchor.constraint(equalTo: self.jogoContainer.bottomAnchor, constant: 5),
            self.conometroContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.conometroContainer.widthAnchor.constraint(equalToConstant: 135),
            self.conometroContainer.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func startTheGameAnimation() {
        self.jogoContainer.alpha = 0.5
        self.conometroContainer.alpha = 0.5
        self.jogoContainer.transform.ty = -20
        self.conometroContainer.transform.ty = -20
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: .calculationModeCubic, animations: {
            self.jogoContainer.alpha = 1
            self.conometroContainer.alpha = 1
            self.jogoContainer.transform.ty = 0
            self.conometroContainer.transform.ty = 0
        }, completion: nil)
    }
    
    func stopTheGameAnimation() {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: .calculationModeCubic, animations: {
            self.jogoContainer.alpha = 0
            self.conometroContainer.alpha = 0
            self.jogoContainer.transform.ty = -20
            self.conometroContainer.transform.ty = -20
        }, completion: nil)
    }
    
    func cleanAllCards() {
        self.jogoContainer.subviews.forEach({ ($0 as? UIButton)?.isSelected = false })
    }
    
    func configureViewController() {
        
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitle("Stop", for: .selected)
        startButton.addTarget(self, action: #selector(self.startGameDidTapped(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: startButton), animated: true)
        
        self.viewModel.updateViewCards = { [weak self] (card1, card2) in
            
            self?.jogoContainer.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.jogoContainer.isUserInteractionEnabled = true
                (self?.jogoContainer.viewWithTag(card1?.rawValue ?? 0) as? CardsView)?.isSelected = false
                (self?.jogoContainer.viewWithTag(card2?.rawValue ?? 0) as? CardsView)?.isSelected = false
            }
        }
        
        self.viewModel.updateViewCronometer = { [weak self] (hour, minute) in
            self?.conometroContainer.text = "\(hour < 10 ? "0\(hour)" : "\(hour)"):\(minute < 10 ? "0\(minute)" : "\(minute)")"
        }
        
        self.viewModel.playerDidWin = { [weak self] in
            self?.stopTheGameAnimation()
            self?.viewModel.saveNewScoreWithPlayer(name: "Bruno")
            self?.updateScoreList()
            (self?.navigationItem.rightBarButtonItem?.customView as? UIButton)?.isSelected = false
        }
        
        self.updateScoreList()
    }
    
    func updateScoreList() {
        self.viewModel.fetchAllScores { [weak self] in
            self?.viewModel.scoreModel?.forEach( { print($0.player, $0.minute, $0.second) })
        }
    }
    
    @objc
    func startGameDidTapped(_ sender: UIButton) {
        if sender.isSelected {
            self.stopTheGame()
        } else {
            self.startTheGame()
        }
        sender.isSelected = !sender.isSelected
    }
    
    func showViewCongratulations() {
        
    }
    
    func generateMemoryViews() {
        
        self.jogoContainer.subviews.forEach({ $0.removeFromSuperview() })
        
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
            self.jogoContainer.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
            self.jogoContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
}
