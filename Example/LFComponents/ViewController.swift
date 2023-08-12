//
//  ViewController.swift
//  LFComponents
//
//  Created by RavenDeng on 07/28/2023.
//  Copyright (c) 2023 RavenDeng. All rights reserved.
//

import UIKit
import LFComponents

enum UIComponentType: CaseIterable {
    case Badges
    case Sidebar
}

extension UIComponentType {
    var caseTitle: String {
        switch self {
            case .Badges:
                return "Badges"
        case .Sidebar:
            return "SideBar"
        }
    }
}

class ViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let dataSource: [UIComponentType] = UIComponentType.allCases
    
    let cellIdentfier = "ui_compnents_identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.frame = UIScreen.main.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentfier)
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let componentCase = dataSource[indexPath.row]
        switch componentCase {
        case .Badges:
            let badgesViewController = BadgesViewController()
            navigationController?.pushViewController(badgesViewController, animated: true)
        case .Sidebar:
            let sidebarViewController = SideMenuContainerViewController()
            sidebarViewController.primaryViewControllerIndex = 3
            sidebarViewController.sideMenuViewController = SidemenuViewController()
            sidebarViewController.contentViewControllers = [
                AirplaneViewController(),
                CarViewController(),
                BusViewController(),
                TramViewController(),
            ]
            navigationController?.pushViewController(sidebarViewController, animated: true)
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let componentCase = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentfier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = componentCase.caseTitle
        return cell
    }
}

