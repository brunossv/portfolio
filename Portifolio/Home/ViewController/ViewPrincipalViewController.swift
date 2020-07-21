//
//  ViewPrincipalViewController.swift
//  Portifolio
//
//  Created by Bruno Soares on 18/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import UIKit

class ViewPrincipalViewController: UIViewController {
    
    enum ReusableIdentifier: String, CaseIterable {
        case perfilCell = "PerfilTableViewCell"
        case optionsCell = "OptionsViewTableViewCell"
        var type: AnyClass? {
            switch self {
            case .perfilCell:
                return PerfilTableViewCell.self
            case .optionsCell:
                return OptionsViewTableViewCell.self
            }
        }
    }
    
    let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    override func loadView() {
        self.view = self.tableView
    }
    
    var viewModel: ViewPrincipalViewModel = ViewPrincipalViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getConfig { [weak self] (error) in
            self?.tableView.reloadData()
        }
        
        self.configureTableView()
        self.configureViewController()
    }
    
    func configureViewController() {
        self.title = "Portfólio"
        self.tableView.backgroundColor = UIColor.systemGroupedBackground
        for cell in ReusableIdentifier.allCases {
            self.tableView.register(cell.type, forCellReuseIdentifier: cell.rawValue)
        }
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension ViewPrincipalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 1 {
            let viewController = LearnMoreViewController()
            viewController.html = self.viewModel.model?.learnMore?.html
            self.navigationController?.pushViewController(viewController, animated: true)
            
        } else if indexPath.section == 1 {
            let model = self.viewModel.model?.features?[indexPath.row].type
            switch model {
            case .jogoMemoria:
                let viewController = JogoDaMemoriaViewController()
                viewController.title = self.viewModel.model?.features?[indexPath.row].title
                self.navigationController?.pushViewController(viewController, animated: true)
            case .messages:
                let blankViewController = UIViewController()
                blankViewController.view.backgroundColor = .white
                self.navigationController?.pushViewController(blankViewController, animated: true)
            case .caller:
                let blankViewController = UIViewController()
                blankViewController.view.backgroundColor = .white
                self.navigationController?.pushViewController(blankViewController, animated: true)
            default:
                break
            }
        }
    }
}

extension ViewPrincipalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return (self.viewModel.model?.features?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.optionsCell.rawValue, for: indexPath)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifier.perfilCell.rawValue, for: indexPath)
                (cell as? PerfilTableViewCell)?.name = self.viewModel.model?.perfil?.name
                (cell as? PerfilTableViewCell)?.position = self.viewModel.model?.perfil?.position
                (cell as? PerfilTableViewCell)?.age = "\(self.viewModel.model?.perfil?.age ?? 0)"
                (cell as? PerfilTableViewCell)?.descriptionInfo = self.viewModel.model?.perfil?.description
            } else if indexPath.row == 1 {
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = self.viewModel.model?.learnMore?.title
            }
        } else {
            let row = indexPath.row
            if let features = self.viewModel.model?.features, row < features.count {
                cell.textLabel?.text = features[row].title
                cell.isSelected = features[row].available ?? true
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
}
