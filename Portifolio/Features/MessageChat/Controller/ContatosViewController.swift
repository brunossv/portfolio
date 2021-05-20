//
//  ContatosViewController.swift
//  Portifolio
//
//  Created by Bruno Vieira on 04/05/21.
//  Copyright © 2021 Bruno Vieira. All rights reserved.
//

import UIKit

class ContatosViewController: UIViewController {
    
    private enum Cells: String, CaseIterable {
        case message = "ContatosTableViewCell"
        
        var type: AnyClass? {
            switch self {
            case .message:
                return ContatosTableViewCell.self
            }
        }
        
        var identifier: String {
            switch self {
            case .message:
                return "ContatosTableViewCell"
            }
        }
    }
    
    private let tableView: UITableView = {
       let view = UITableView()
       view.translatesAutoresizingMaskIntoConstraints = false
       
       return view
    }()
    
    var viewModel: ContatosViewModel = ContatosViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubViews()
        self.configureTableView()
        self.configureViewController()
    }
    
    func getCurrentUser(_ completion: @escaping () -> Void) {
        if let current = self.viewModel.currentUser {
            print("Current User: " + (current.name ?? ""))
            self.viewModel.listemNewMessages()
            self.title = self.viewModel.currentUser?.name
            completion()
            
        } else {
            var textField: UITextField?
            let action = UIAlertAction(title: "Salvar", style: .default, handler: { (_) in
                guard let textField = textField else { return }
                self.viewModel.saveCurrentUser(textField.text ?? "", { [weak self] (error) in
                    self?.viewModel.listemNewMessages()
                    self?.title = self?.viewModel.currentUser?.name
                    completion()
                })
            })

            let viewController = UIAlertController(title: "Digite seu nome", message: nil, preferredStyle: .alert)
            viewController.addAction(action)
            
            viewController.addTextField { (view) in
                textField = view
            }
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func configureViewController() {
        
        enum Requests {
            case getUser
            case getChatUsers
        }
        
        func callRequests(requests: [Requests]) {
            guard let request = requests.first else { return }
            switch request {
            case .getUser:
                self.getCurrentUser {
                    callRequests(requests: Array(requests.dropFirst()))
                }
                
            case .getChatUsers:
                self.viewModel.getAllUsers { [weak self] (error) in
                    callRequests(requests: Array(requests.dropFirst()))
                    self?.tableView.reloadData()
                }
            }
        }
        
        callRequests(requests: [.getUser, .getChatUsers])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MessageSingleton.shared.didReceiveMessage = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func configureSubViews() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -45),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureTableView() {
        for cell in Cells.allCases {
            self.tableView.register(cell.type, forCellReuseIdentifier: cell.rawValue)
        }
        self.view.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .interactive
    }
}

extension ContatosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let contatos = self.viewModel.contatos, indexPath.row < contatos.count {
            let viewModel = MessageChatViewModel()
            viewModel.chatUser = contatos[indexPath.row]
            
            let viewController = MessageChatViewController()
            viewController.viewModel = viewModel
            let backItem = UIBarButtonItem()
            backItem.title = contatos[indexPath.row].name
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ContatosViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.contatos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.message.identifier, for: indexPath) as? ContatosTableViewCell
        
        let message = self.viewModel.fetchLastMessage(index: indexPath.row)
        cell?.nick = self.viewModel.contatos?[indexPath.row].name
        cell?.preview = message?.text
        cell?.time = self.viewModel.formatarMensagemData(msgData: message?.createdDate)
        
        return cell ?? UITableViewCell()
    }
}
