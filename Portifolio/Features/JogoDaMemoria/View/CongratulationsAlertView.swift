//
//  CongratulationsAlertView.swift
//  Portifolio
//
//  Created by Bruno Soares on 20/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation
import UIKit

protocol CongratulationsAlertViewDelegate: class {
    func saveScore(_ player: String?)
}

class CongratulationsAlertView: UIViewController {
    
    private enum PositionScore: Int {
        case first = 1
        case second = 2
        case third = 3
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var congratulationsLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        view.numberOfLines = 0
        view.text = "Congratulations!!!"
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var positionScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var timeScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var nickNameTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var viewBackgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dismissButton: UIButton = { [unowned self] in
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.setTitle("OK", for: .normal)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(self.dismissButtonAction(_:)), for: .touchUpInside)
        return view
    }()
    
    weak var uiDelegate: CongratulationsAlertViewDelegate?
    
    var timeScore: String? {
        get { return self.timeScoreLabel.text }
        set { self.timeScoreLabel.text = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSubViews()
    }
    
    @objc
    func dismissButtonAction(_ sender: UIButton) {
        self.uiDelegate?.saveScore(self.nickNameTextField.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureSubViews() {
        self.view.backgroundColor = .clear
        self.view.addSubview(self.viewBackgroundView)
        self.view.addSubview(self.containerView)
        self.view.addSubview(self.congratulationsLabel)
        self.view.addSubview(self.positionScoreLabel)
        self.view.addSubview(self.timeScoreLabel)
        self.view.addSubview(self.nickNameTextField)
        self.view.addSubview(self.dismissButton)
        
        NSLayoutConstraint.activate([
             self.viewBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
             self.viewBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
             self.viewBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
             self.viewBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -10),
            self.containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.congratulationsLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20),
            self.congratulationsLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
//            self.congratulationsLabel.heightAnchor.constraint(equalToConstant: 65),
            self.congratulationsLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.8)
        ])
        
        NSLayoutConstraint.activate([
            self.positionScoreLabel.centerYAnchor.constraint(equalTo: self.congratulationsLabel.centerYAnchor),
            self.positionScoreLabel.centerXAnchor.constraint(equalTo: self.congratulationsLabel.centerXAnchor),
            self.positionScoreLabel.heightAnchor.constraint(equalToConstant: 65),
            self.positionScoreLabel.widthAnchor.constraint(equalToConstant: 65)
        ])
        
        NSLayoutConstraint.activate([
            self.timeScoreLabel.topAnchor.constraint(equalTo: self.congratulationsLabel.bottomAnchor, constant: 5),
            self.timeScoreLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10),
            self.timeScoreLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -10),
            self.timeScoreLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.nickNameTextField.topAnchor.constraint(equalTo: self.timeScoreLabel.bottomAnchor, constant: 5),
            self.nickNameTextField.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 15),
            self.nickNameTextField.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -15),
            self.nickNameTextField.widthAnchor.constraint(equalToConstant: 240),
            self.nickNameTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: self.nickNameTextField.bottomAnchor, constant: 15),
            self.dismissButton.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20),
            self.dismissButton.leftAnchor.constraint(equalTo: self.nickNameTextField.leftAnchor, constant: 15),
            self.dismissButton.rightAnchor.constraint(equalTo: self.nickNameTextField.rightAnchor, constant: -15),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
