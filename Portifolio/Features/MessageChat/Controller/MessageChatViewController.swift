//
//  MessageChatViewController.swift
//  Portifolio
//
//  Created by Bruno Soares on 01/08/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit

class MessageChatViewController: UIViewController {
    
    private enum CellIdentifier: String, CaseIterable {
        case message = "MessageChatTableViewCell"
        
        var type: AnyClass? {
            switch self {
            case .message:
                return MessageChatTableViewCell.self
            }
        }
    }
    
    private let tableView: UITableView = {
       let view = UITableView()
       view.translatesAutoresizingMaskIntoConstraints = false
       
       return view
    }()
    
    private let textView: TypeUserMessageView = {
        let view = TypeUserMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var viewModel: MessageChatViewModel = MessageChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureSubViews()
        self.configureViewController()
        self.viewModel.downloadAndSaveNewMessages()
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemGroupedBackground
        self.textView.sendMessageUser = { [weak self] (message) in
            self?.tableView.reloadData()
        }
        
        if let _ = self.viewModel.currentUser {
            
        } else {
            self.viewModel.saveCurrentUser("Bruno")
        }
    }
    
    func configureSubViews() {
        self.view.addSubview(self.textView)
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.textView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.textView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -45),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureTableView() {
        for cell in CellIdentifier.allCases {
            self.tableView.register(cell.type, forCellReuseIdentifier: cell.rawValue)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .interactive
    }
    
    override var inputAccessoryView: UIView? {
        return self.textView
    }
}

extension MessageChatViewController: UITableViewDelegate {
    
}

extension MessageChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < self.viewModel.messages?.count ?? 0 {
            return self.viewModel.messages?[section].count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.message.rawValue, for: indexPath)
        
        (cell as? MessageChatTableViewCell)?.cameFrom = .user
        (cell as? MessageChatTableViewCell)?.message = self.viewModel.messages?[indexPath.section][indexPath.row].text
        
        return cell
    }
}
