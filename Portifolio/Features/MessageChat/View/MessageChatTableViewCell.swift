//
//  MessageChatTableViewCell.swift
//  Portifolio
//
//  Created by Bruno Soares on 01/08/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit

class MessageChatTableViewCell: UITableViewCell {
    
    enum Direciton: Int {
        case user = 0
        case received = 1
    }
    
    private lazy var messageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    
    private var leftBubbleConstraint: NSLayoutConstraint?
    private var rightBubbleConstraint: NSLayoutConstraint?
    
    var message: String? {
        get { return self.messageLabel.text }
        set { self.messageLabel.text = newValue }
    }
    
    var cameFrom: Direciton = .user {
        didSet {
            switch self.cameFrom {
            case .user:
                self.leftBubbleConstraint?.isActive = false
                self.rightBubbleConstraint?.isActive = true
                self.messageContainer.backgroundColor = self.tintColor
                self.messageLabel.textColor = .white
                
            case .received:
                self.leftBubbleConstraint?.isActive = true
                self.rightBubbleConstraint?.isActive = false
                self.messageContainer.backgroundColor = .systemGray4
                self.messageLabel.textColor = .black
                
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initViews()
    }
    
    func initViews() {
        self.configureSubViews()
    }
    
    private func configureSubViews() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.messageContainer)
        self.contentView.addSubview(self.messageLabel)
        
        NSLayoutConstraint.activate([
            self.messageContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.messageContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.messageContainer.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor, multiplier: 0.75),
        ])
        
        self.leftBubbleConstraint = self.messageContainer.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10)
        self.rightBubbleConstraint = self.messageContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10)
        
        let paddingH: CGFloat = 8
        let paddingW: CGFloat = 10
        NSLayoutConstraint.activate([
            self.messageLabel.topAnchor.constraint(equalTo: self.messageContainer.topAnchor, constant: paddingH),
            self.messageLabel.leftAnchor.constraint(equalTo: self.messageContainer.leftAnchor, constant: paddingW),
            self.messageLabel.rightAnchor.constraint(equalTo: self.messageContainer.rightAnchor, constant: -paddingW),
            self.messageLabel.bottomAnchor.constraint(equalTo: self.messageContainer.bottomAnchor, constant: -paddingH),
            self.messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initViews()
    }
}

