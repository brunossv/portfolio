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
        let view = UITableView(frame: .zero, style: .grouped)
       view.translatesAutoresizingMaskIntoConstraints = false
       
       return view
    }()
    
    private let textView: TypeUserMessageView = {
        let view = TypeUserMessageView(frame: CGRect(x: .zero, y: .zero, width: 0, height: 44))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var viewModel: MessageChatViewModel = MessageChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureSubViews()
        self.configureViewController()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        self.getMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MessageSingleton.shared.didReceiveMessage = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func getMessages() {
        self.viewModel.downloadNewsMessages { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.scrollToBottom(aanimate: false, delay: 0)
        }
    }
    
    func scrollToBottom(aanimate: Bool = true, delay: TimeInterval = 0.25) {
        let lastSection = self.tableView.numberOfSections - 1
        let lastRow = self.tableView.numberOfRows(inSection: lastSection) - 1
        
        if lastSection > 0 && lastRow > 0 {
            let indexPath = IndexPath(row: lastRow, section: lastSection)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    
    func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.textView.sendMessageUser = { [weak self] (message) in
            guard let self = self else { return }
            if message.isEmpty {
                return
            }
            self.sendNewMessage(text: message)
        }
    }
    
    func sendNewMessage(text: String) {
        
        self.viewModel.sendNewMessage(message: text, { [weak self] in
            self?.getMessages()
        })
    }
    
    var textViewBottom: NSLayoutConstraint = NSLayoutConstraint()
    
    func configureSubViews() {
        self.view.addSubview(self.textView)
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.textView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.textView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        textViewBottom = self.textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        textViewBottom.isActive = true
        
        NSLayoutConstraint.activate([
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.textView.topAnchor),
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
//        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
//        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
    }
    
//    override var inputAccessoryView: UIView? {
//        return self.textView
//    }
    
    // MARK: - Notifications
    
    @objc func keyboardWasShow(notification: NSNotification) {
        if let info = notification.userInfo {
            if let rect = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
                let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                tableView.contentInset = insets
                tableView.scrollIndicatorInsets = insets
                self.textViewBottom.constant = -rect.height
                self.scrollToBottom()
            }
        }
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.textViewBottom.constant = 0
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        self.scrollToBottom()
    }
}

extension MessageChatViewController: UITableViewDelegate {
    
}

extension MessageChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerMasterView: UIView = UIView(frame: CGRect(x: .zero, y: .zero, width: .zero, height: 55))
        
        let containerView: UIView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.backgroundColor = #colorLiteral(red: 0.9798085387, green: 1, blue: 1, alpha: 0.4814590669)
//        containerView.layer.borderWidth = 0.3
//        containerView.layer.borderColor = UIColor.lightGray.cgColor
//        containerView.layer.cornerRadius = 10
//        containerView.layer.masksToBounds = true
        
        let dateLabel: UILabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        dateLabel.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        
        containerMasterView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: containerMasterView.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: containerMasterView.centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            dateLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)
        ])
        
        if let messages = self.viewModel.messages, section < messages.count, let creadtedDate = messages[section].first?.createdDate {
            dateLabel.text = creadtedDate.format(to: "dd-MM")
            return containerMasterView
        } else {
            return UIView()
        }
    }   
    
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
        
        let model = self.viewModel.messages?[indexPath.section][indexPath.row]
        (cell as? MessageChatTableViewCell)?.message = model?.text
        
        if let id = model?.to?.value(forKey: "id") as? Int, let currentId = self.viewModel.model.currentUser?.id, currentId == id {
            (cell as? MessageChatTableViewCell)?.cameFrom = .user
        } else {
            (cell as? MessageChatTableViewCell)?.cameFrom = .received
        }
        
        return cell
    }
}

private extension Date {
    func format(to string: String) -> String {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = string
        dateFormmater.dateStyle = .medium
        return dateFormmater.string(from: self)
    }
}
