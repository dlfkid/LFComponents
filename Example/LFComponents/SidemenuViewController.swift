//
//  SidemenuViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

class SidemenuViewController: UIViewController, SideMenuControllable {
    
    weak var sideMenuContainer: LFComponents.SideMenuContainerViewController?
    
    let reuseIdentifier = "SidemenuViewControllerCells"
    
    let menuOptions: [SidebarMenuOption] = SidebarMenuOption.allCases
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
    }
}

extension SidemenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = self.sideMenuContainer else {
            return
        }
        delegate.segueToPrimaryViewController(index: indexPath.row)
    }
}

extension SidemenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let option = menuOptions[indexPath.row]
        cell.textLabel?.text = option.name
        cell.imageView?.image = UIImage(systemName: option.iconName)
        cell.imageView?.tintColor = .white
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
}
