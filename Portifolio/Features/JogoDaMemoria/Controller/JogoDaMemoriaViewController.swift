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
        view.isHidden = true
        view.alpha = 0
        
        return view
    }()
    
    lazy var cronometroContainer: UILabel = {
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
        view.isHidden = true
        view.alpha = 0
        
        return view
    }()
    
    private lazy var scoreContainerView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillEqually
        
        return view
    }()
    
    var viewModel: JogoDaMemoriaViewModel = JogoDaMemoriaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubViews()
        self.configureViewController()
        self.updateScoreContainerView()
    }
    
    func startTheGame() {
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
        self.cronometroContainer.text = "00:00"
        self.viewModel.stopTheGame()
        self.stopTheGameAnimation()
    }

    func startTheGameAnimation() {
        let alfaViewOpac: CGFloat = 0.5
        let inicialPosition: CGFloat = -20
        self.jogoContainer.alpha = alfaViewOpac
        self.cronometroContainer.alpha = alfaViewOpac
        self.jogoContainer.transform.ty = inicialPosition
        self.cronometroContainer.transform.ty = inicialPosition
        self.jogoContainer.isHidden = false
        self.cronometroContainer.isHidden = false
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: .calculationModeCubic, animations: {
            let alfaViewFull: CGFloat = 1
            self.jogoContainer.alpha = alfaViewFull
            self.cronometroContainer.alpha = alfaViewFull
            self.jogoContainer.transform.ty = 0
            self.cronometroContainer.transform.ty = 0
            self.view.layoutSubviews()
            
        }, completion: nil)
    }
    
    func stopTheGameAnimation() {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: .calculationModeCubic, animations: {
            let alfaViewTranslucid: CGFloat = 0
            let finalPosition: CGFloat = -20
            self.jogoContainer.alpha = alfaViewTranslucid
            self.cronometroContainer.alpha = alfaViewTranslucid
            self.jogoContainer.transform.ty = finalPosition
            self.cronometroContainer.transform.ty = finalPosition
            self.view.layoutSubviews()
            
        }, completion: { (_) in
            self.jogoContainer.subviews.forEach({ $0.removeFromSuperview() })
            self.jogoContainer.isHidden = true
            self.cronometroContainer.isHidden = true
            
        })
    }
    
    func cleanAllCards() {
        self.jogoContainer.subviews.forEach({ ($0 as? UIButton)?.isSelected = false })
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
    
    func showViewCongratulations(with score: String?) {
        let alert = CongratulationsAlertView()
        alert.timeScore = score
        alert.uiDelegate = self
        alert.modalPresentationStyle = .custom
        alert.modalTransitionStyle = .crossDissolve
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateScoreContainerView() {
        self.scoreContainerView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        for (i, (player, score)) in self.viewModel.firstThreePlacesScore().enumerated() {
            
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 16
            view.layer.borderWidth = 1.5
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.masksToBounds = true
            view.textColor = .white
            view.textAlignment = .center
            view.font = UIFont.systemFont(ofSize: 24, weight: .regular)
            view.numberOfLines = 0
            let scoreTime = score
            view.attributedText = NSAttributedString(string: "\(i + 1)° \(player)\n\(scoreTime)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .light)])
            
            switch i {
            case 0:
                self.scoreContainerView.addArrangedSubview(view)
                view.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3568627451, blue: 0.431372549, alpha: 1)
            case 1:
                
                if self.scoreContainerView.arrangedSubviews.count > 0 {
                    self.scoreContainerView.insertArrangedSubview(view, at: 0)
                } else {
                    self.scoreContainerView.addArrangedSubview(view)
                }
                view.backgroundColor = #colorLiteral(red: 0.537254902, green: 0.6901960784, blue: 0.6823529412, alpha: 1)
            case 2:
                self.scoreContainerView.addArrangedSubview(view)
                view.backgroundColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.368627451, alpha: 1)
                
            default:
                continue
            }
        }
    }

    func generateMemoryViews() {
        
        self.jogoContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        let cards: [JogoDaMemoriaViewModel.Cards] = JogoDaMemoriaViewModel.Cards.allCases.shuffled()
        
        var lastView: UIView = UIView()
        var firstViewLine: Bool = false
        
        for i in 0..<cards.count {
            let index = i + 1
            let cardView = UIButton()
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
                    cardView.leftAnchor.constraint(greaterThanOrEqualTo: lastView.rightAnchor, constant: offSetPadding),
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
                (self.jogoContainer.viewWithTag(sender.tag) as? UIButton)?.isSelected = true
                self.viewModel.selectACard(selectedCard)
            }
        }
    }
    
    func configureSubViews() {
        self.view.addSubview(self.jogoContainer)
        self.view.addSubview(self.cronometroContainer)
        self.view.addSubview(self.scoreContainerView)
        
        NSLayoutConstraint.activate([
            self.jogoContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.jogoContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.cronometroContainer.topAnchor.constraint(equalTo: self.jogoContainer.bottomAnchor, constant: 5),
            self.cronometroContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cronometroContainer.widthAnchor.constraint(equalToConstant: 135),
            self.cronometroContainer.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        NSLayoutConstraint.activate([
            self.scoreContainerView.topAnchor.constraint(greaterThanOrEqualTo: self.view.centerYAnchor, constant: 20),
            self.scoreContainerView.topAnchor.constraint(greaterThanOrEqualTo: self.cronometroContainer.bottomAnchor, constant: 20),
            self.scoreContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.scoreContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.scoreContainerView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func configureViewController() {
        
        self.view.backgroundColor = .systemGroupedBackground
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitle("Stop", for: .selected)
        startButton.addTarget(self, action: #selector(self.startGameDidTapped(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: startButton), animated: true)
        
        self.viewModel.updateViewCards = { [weak self] (card1, card2) in
            
            self?.jogoContainer.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.jogoContainer.isUserInteractionEnabled = true
                (self?.jogoContainer.viewWithTag(card1?.rawValue ?? 0) as? UIButton)?.isSelected = false
                (self?.jogoContainer.viewWithTag(card2?.rawValue ?? 0) as? UIButton)?.isSelected = false
            }
        }
        
        self.viewModel.updateViewCronometer = { [weak self] (time) in
            self?.cronometroContainer.text = time
        }
        
        self.viewModel.playerDidWin = { [weak self] (scoreString) in
            self?.stopTheGameAnimation()
            self?.showViewCongratulations(with: scoreString)
            (self?.navigationItem.rightBarButtonItem?.customView as? UIButton)?.isSelected = false
        }
    }
    
}

extension JogoDaMemoriaViewController: CongratulationsAlertViewDelegate {
    func saveScore(_ player: String?) {
        self.viewModel.saveNewScoreWithPlayer(name: player ?? "")
        self.updateScoreContainerView()
    }
}
