//
//  TypeUserMessageView.swift
//  Portifolio
//
//  Created by Bruno Soares on 01/08/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit

class TypeUserMessageView: UIView {
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        return view
    }()
    
    private lazy var sendButton: UIButton = { [unowned self] in
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        view.backgroundColor = self.tintColor
        view.tintColor = .white
        view.addTarget(self, action: #selector(self.didSendMessage(_:)), for: .touchUpInside)
        
        return view
    }()
    
    var sendMessageUser: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    func initViews() {
        self.configureSubViews()
    }
    
    private func configureSubViews() {
        self.addSubview(self.textView)
        self.addSubview(self.sendButton)
        
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.textView.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor, constant: -10),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.textView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.sendButton.centerYAnchor.constraint(equalTo: self.textView.centerYAnchor),
            self.sendButton.heightAnchor.constraint(equalToConstant: 30),
            self.sendButton.widthAnchor.constraint(equalToConstant: 30),
            self.sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        ])
    }
    
    @objc
    private func didSendMessage(_ sender: UIButton) {
        self.sendMessageUser?(self.textView.text)
        self.textView.text = ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initViews()
    }
}
