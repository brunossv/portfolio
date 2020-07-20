//
//  PerfilTableViewCell.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit

class PerfilTableViewCell: UITableViewCell {
    
    enum SubViews: Int {
        case name = 1
        case position
        case age
    }
    
    lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.backgroundColor = .black
        
        return view
    }()
    
    lazy var perfilInfoStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var descriptionLabel: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.dataDetectorTypes = .all
        view.isScrollEnabled = false
        return view
    }()
    
    var name: String? {
        get { return (self.perfilInfoStackView.viewWithTag(SubViews.name.rawValue) as? UILabel)?.text }
        set { (self.perfilInfoStackView.viewWithTag(SubViews.name.rawValue) as? UILabel)?.text = newValue }
    }
    
    var position: String? {
        get { return (self.perfilInfoStackView.viewWithTag(SubViews.position.rawValue) as? UILabel)?.text }
        set { (self.perfilInfoStackView.viewWithTag(SubViews.position.rawValue) as? UILabel)?.text = newValue }
    }
    
    var age: String? {
        get { return (self.perfilInfoStackView.viewWithTag(SubViews.age.rawValue) as? UILabel)?.text }
        set { (self.perfilInfoStackView.viewWithTag(SubViews.age.rawValue) as? UILabel)?.text = newValue }
    }
    
    var descriptionInfo: String? {
        get { return self.descriptionLabel.text }
        set { self.descriptionLabel.text = newValue }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initViews()
    }
    
    func configureViews() {
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.perfilInfoStackView)
        self.contentView.addSubview(self.descriptionLabel)
        
        let contentPadding: CGFloat = 14
        
        NSLayoutConstraint.activate([
            self.avatarView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentPadding),
            self.avatarView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentPadding),
            self.avatarView.heightAnchor.constraint(equalToConstant: 60),
            self.avatarView.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            self.perfilInfoStackView.topAnchor.constraint(equalTo: self.avatarView.topAnchor),
            self.perfilInfoStackView.leftAnchor.constraint(equalTo: self.avatarView.rightAnchor, constant: 10),
            self.perfilInfoStackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.perfilInfoStackView.bottomAnchor.constraint(equalTo: self.avatarView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.avatarView.bottomAnchor, constant: 6),
            self.descriptionLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentPadding),
            self.descriptionLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        let nameLabel = ViewFactorys.labels(UIFont.systemFont(ofSize: 14, weight: .semibold), color: .label)
        nameLabel.tag = SubViews.name.rawValue
        
        let positionLabel = ViewFactorys.labels(UIFont.systemFont(ofSize: 14, weight: .light), color: .label)
        positionLabel.tag = SubViews.position.rawValue
        
        let ageLabel = ViewFactorys.labels(UIFont.systemFont(ofSize: 14, weight: .light), color: .label)
        ageLabel.tag = SubViews.age.rawValue
        
        self.perfilInfoStackView.addArrangedSubview(nameLabel)
        self.perfilInfoStackView.addArrangedSubview(positionLabel)
        self.perfilInfoStackView.addArrangedSubview(ageLabel)
        
    }
    
    private func initViews() {
        self.configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initViews()
    }
}
