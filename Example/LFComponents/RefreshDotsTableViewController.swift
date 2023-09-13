//
//  RefreshDotsTableViewController.swift
//  LFComponents_Example
//
//  Created by 邓凌峰(DengLingfeng)-顺丰科技技术集团 on 2023/9/13.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

class RefreshDotsTableViewController: UITableViewController {

    var cases: [String] = []
    
    let reuseIdentifier = "dotsRefreshCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Refresh Dots"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.backgroundColor = .white
        tableView.isRefreshFooterHidden = true
        tableView.addRefreshHeader(type: .dots, target: self, selector: #selector(refreshHeaderEvent))
        tableView.addRefreshFooter(type: .dots, target: self, selector: #selector(refreshFooterEvent))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let title = cases[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }
    
    @objc private func refreshHeaderEvent() {
        appendDataStopRefresh(isRefresh: true)
    }
    
    @objc private func refreshFooterEvent() {
        appendDataStopRefresh(isRefresh: false)
    }
    
    private func appendDataStopRefresh(isRefresh: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            if isRefresh { self.cases = [] }
            let count = self.cases.count
            
            var data: [String] = []
            for value in (count + 1)...(count + 5) {
                data.append("Cell \(value)")
            }
            
            self.cases.append(contentsOf: data)
            self.tableView.stopRefreshing()
            self.tableView.reloadData()
            self.tableView.isRefreshFooterHidden = self.cases.isEmpty
        }
    }

}
