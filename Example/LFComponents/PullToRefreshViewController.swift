//
//  PullToRefreshViewController.swift
//  LFComponents_Example
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2023/9/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

enum PullToRefreshStyle: CaseIterable {
    case systemLike
    case ring
    case dots
}

extension PullToRefreshStyle {
    var name: String {
        switch self {
        case .systemLike:
            return "System Like"
        case .ring:
            return "Ring"
        case .dots:
            return "Dots"
        }
    }
}

class PullToRefreshViewController: UIViewController {
    
    static let cellIdentifier = "pull_to_refresh_cells"
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let dataSource: [PullToRefreshStyle] = PullToRefreshStyle.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pull to Refresh"
        tableView.frame = UIScreen.main.bounds
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PullToRefreshViewController.cellIdentifier)
    }
}

extension PullToRefreshViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let style = dataSource[indexPath.row]
        switch style {
        case .systemLike:
            navigationController?.pushViewController(RefreshSystemViewController(), animated: true)
        case .ring:
            navigationController?.pushViewController(RefreshRingViewController(), animated: true)
        case .dots:
            navigationController?.pushViewController(RefreshDotsTableViewController(), animated: true)
        }
    }
}

extension PullToRefreshViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PullToRefreshViewController.cellIdentifier, for: indexPath)
        let style = dataSource[indexPath.row]
        cell.textLabel?.text = style.name
        return cell
    }
}
