//
//  ScoreBoardTableViewCell.swift
//  Portifolio
//
//  Created by Bruno Soares on 25/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit

class ScoreBoardTableViewCell: UITableViewCell {
    
    private enum PositionScore: Int {
        case first = 1
        case second = 2
        case third = 3
    }
    
    lazy var positionScoreImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        return view
    }()
    
    lazy var positionScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy var nickNameScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var timeScoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 9, weight: .light)
        view.numberOfLines = 0
        
        return view
    }()
    
    var nickName: String? {
        get { return self.nickNameScoreLabel.text }
        set { self.nickNameScoreLabel.text = newValue }
    }
    
    var timeScore: String? {
        get { return self.timeScoreLabel.text }
        set { self.timeScoreLabel.text = newValue }
    }
    
    var positionScore: Int? {
        didSet {
            guard let position = positionScore else { return }
            self.positionScoreLabel.text = nil
            
            switch PositionScore.init(rawValue: position) {
            case .first:
                self.positionScoreImageView.image = UIImage(named: "firstPlace")
                self.nickNameScoreLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

            case .second:
                self.positionScoreImageView.image = UIImage(named: "secondPlace")
                self.nickNameScoreLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

            case .third:
                self.positionScoreImageView.image = UIImage(named: "thirdPlace")
                self.nickNameScoreLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                
            default:
                self.nickNameScoreLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
                self.positionScoreLabel.text = "\(position)"
                self.positionScoreImageView.image = nil
                break
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
        self.contentView.addSubview(self.positionScoreImageView)
        self.contentView.addSubview(self.positionScoreLabel)
        self.contentView.addSubview(self.nickNameScoreLabel)
        self.contentView.addSubview(self.timeScoreLabel)
        
        NSLayoutConstraint.activate([
            self.positionScoreImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.positionScoreImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            self.positionScoreImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15),
            self.positionScoreImageView.heightAnchor.constraint(equalToConstant: 35),
            self.positionScoreImageView.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            self.positionScoreLabel.centerYAnchor.constraint(equalTo: self.positionScoreImageView.centerYAnchor),
            self.positionScoreLabel.centerXAnchor.constraint(equalTo: self.positionScoreImageView.centerXAnchor),
            self.positionScoreLabel.heightAnchor.constraint(equalToConstant: 35),
            self.positionScoreLabel.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            self.nickNameScoreLabel.centerYAnchor.constraint(equalTo: self.positionScoreImageView.centerYAnchor, constant: -5),
            self.nickNameScoreLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            self.nickNameScoreLabel.leftAnchor.constraint(equalTo: self.positionScoreImageView.rightAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            self.timeScoreLabel.topAnchor.constraint(equalTo: self.nickNameScoreLabel.bottomAnchor),
            self.timeScoreLabel.leftAnchor.constraint(equalTo: self.nickNameScoreLabel.leftAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initViews()
    }
}
