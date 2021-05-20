//
//  ContatosTableViewCell.swift
//  Portifolio
//
//  Created by Bruno Vieira on 04/05/21.
//  Copyright © 2021 Bruno Vieira. All rights reserved.
//

import UIKit

class ContatosTableViewCell: UITableViewCell {
    
    lazy var nickNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        view.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.numberOfLines = 1
        
        return view
    }()
    
    lazy var lastMessageTimeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.numberOfLines = 2
        view.text = " "
        view.textAlignment = .right
        
        return view
    }()

    
    lazy var previewMessageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        view.numberOfLines = 2
        view.text = " "
        
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var nick: String? {
        get { self.nickNameLabel.text }
        set { self.nickNameLabel.text = newValue }
    }
    
    var preview: String? {
        get { self.previewMessageLabel.text }
        set { self.previewMessageLabel.text = newValue }
    }
    
    var time: String? {
        get { self.lastMessageTimeLabel.text }
        set { self.lastMessageTimeLabel.text = newValue }
    }
    
    var avatar: String? {
        didSet {
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    private func initialize() {
        self.configureSubviews()
    }
    
    func configureSubviews() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 77, bottom: 0, right: 0)
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nickNameLabel)
        self.contentView.addSubview(self.lastMessageTimeLabel)
        self.contentView.addSubview(self.previewMessageLabel)
        
        NSLayoutConstraint.activate([
//            self.avatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.avatarImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            self.avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            self.nickNameLabel.topAnchor.constraint(equalTo: self.avatarImageView.topAnchor),
            self.nickNameLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 12),
            self.nickNameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.lastMessageTimeLabel.leftAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            self.lastMessageTimeLabel.topAnchor.constraint(equalTo: self.avatarImageView.topAnchor),
            self.lastMessageTimeLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15),
//            self.lastMessageTimeLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        
        NSLayoutConstraint.activate([
            self.previewMessageLabel.topAnchor.constraint(equalTo: self.nickNameLabel.bottomAnchor),
            self.previewMessageLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 12),
            self.previewMessageLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
//            self.previewMessageLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.contentView.bottomAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
}
