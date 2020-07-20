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
        view.backgroundColor = .black
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubViews()
        self.generateMemoryViews()
    }
    
    func generateMemoryViews() {
        
        let firstCards: [JogoDaMemoriaViewModel.Cards] = JogoDaMemoriaViewModel.Cards.allCases.shuffled()
        let secondCards: [JogoDaMemoriaViewModel.Cards] = firstCards.shuffled()
        
        var lastView: UIView = UIView()
        for i in 0..<firstCards.count {
            let firstView = UIButton()
            firstView.translatesAutoresizingMaskIntoConstraints = false
            firstView.tag = firstCards[i].rawValue
            firstView.backgroundColor = .white
            firstView.addTarget(self, action: #selector(self.cardDidTapped(_:)), for: .touchUpInside)
            
            let secondView = UIButton()
            secondView.translatesAutoresizingMaskIntoConstraints = false
            secondView.tag = secondCards[i].equalCardTag
            secondView.backgroundColor = .white
            secondView.addTarget(self, action: #selector(self.cardDidTapped(_:)), for: .touchUpInside)
            
            self.jogoContainer.addSubview(firstView)
            self.jogoContainer.addSubview(secondView)
            
            NSLayoutConstraint.activate([
                firstView.heightAnchor.constraint(equalToConstant: 50),
                firstView.widthAnchor.constraint(equalToConstant: 50),
            ])
            
            NSLayoutConstraint.activate([
                secondView.heightAnchor.constraint(equalToConstant: 50),
                secondView.widthAnchor.constraint(equalToConstant: 50)
            ])
            
            let offSetPadding: CGFloat = 2
            if i == 0 {
                NSLayoutConstraint.activate([
                    firstView.topAnchor.constraint(equalTo: self.jogoContainer.topAnchor, constant: offSetPadding),
                    firstView.leftAnchor.constraint(equalTo: self.jogoContainer.leftAnchor, constant: offSetPadding),
                ])
                
                NSLayoutConstraint.activate([
                    secondView.topAnchor.constraint(equalTo: firstView.topAnchor),
                    secondView.leftAnchor.constraint(equalTo: firstView.rightAnchor, constant: offSetPadding),
                ])
                lastView = secondView
                
            } else if (i % 2) == 0 {
                NSLayoutConstraint.activate([
                    firstView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: offSetPadding),
                    firstView.leftAnchor.constraint(equalTo: self.jogoContainer.leftAnchor, constant: offSetPadding),
                ])
                
                NSLayoutConstraint.activate([
                    secondView.topAnchor.constraint(equalTo: firstView.topAnchor),
                    secondView.leftAnchor.constraint(equalTo: firstView.rightAnchor, constant: offSetPadding),
                ])
                lastView = secondView
                
            } else if i == firstCards.count - 1 {
                NSLayoutConstraint.activate([
                    firstView.topAnchor.constraint(equalTo: lastView.topAnchor),
                    firstView.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: offSetPadding),
                ])
                
                NSLayoutConstraint.activate([
                    secondView.topAnchor.constraint(equalTo: firstView.topAnchor),
                    secondView.leftAnchor.constraint(equalTo: firstView.rightAnchor, constant: offSetPadding),
                    secondView.rightAnchor.constraint(equalTo: self.jogoContainer.rightAnchor, constant: -offSetPadding),
                    secondView.bottomAnchor.constraint(equalTo: self.jogoContainer.bottomAnchor, constant: -offSetPadding)
                ])
                
            } else {
                NSLayoutConstraint.activate([
                    firstView.topAnchor.constraint(equalTo: lastView.topAnchor),
                    firstView.leftAnchor.constraint(equalTo: lastView.rightAnchor, constant: offSetPadding),
                ])
                
                NSLayoutConstraint.activate([
                    secondView.topAnchor.constraint(equalTo: firstView.topAnchor),
                    secondView.leftAnchor.constraint(equalTo: firstView.rightAnchor, constant: offSetPadding),
                    secondView.rightAnchor.constraint(equalTo: self.jogoContainer.rightAnchor, constant: -offSetPadding)
                ])
                lastView = secondView
            }
        }
    }
    
    @objc
    func cardDidTapped(_ sender: UIButton) {
        print(sender.tag)
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
