//
//  ViewController.swift
//  LFComponents
//
//  Created by RavenDeng on 07/28/2023.
//  Copyright (c) 2023 RavenDeng. All rights reserved.
//

import UIKit

enum UIComponentType: CaseIterable {
    case Badges
}

extension UIComponentType {
    var caseTitle: String {
        switch self {
            case .Badges:
                return "Badges"
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
        cell.textLabel?.text = componentCase.caseTitle
        return cell
    }
}

