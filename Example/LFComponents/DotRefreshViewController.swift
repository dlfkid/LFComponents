//
//  DotRefreshViewController.swift
//  NXDesign_Example
//
//  Created by Ravendeng on 2023/9/4.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

class DotRefreshViewController: UIViewController, RefreshShowable {
    
    private let reuseIdentifier = "dot.showcase"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    private var cases: [String] = [String]()
    
    var tintStyle: LFCRefreshTintStyle = .black
    
    var iconSize: LFCRefreshIconSize = .medium
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        if tintStyle == .white {
            tableView.backgroundColor = .darkGray
        }
        title = "Dot refresh"
                
        tableView.lfc.addRefreshHeader(type: .dots, style: tintStyle, size: iconSize, target: self, selector: #selector(refreshHeaderEvent))
        tableView.lfc.addRefreshFooter(type: .dots, style: tintStyle, size: iconSize, target: self, selector: #selector(refreshFooterEvent))
        tableView.lfc.addBaseHeaderStater(showClosure: { view in
            return "\(self.cases.count) items of data loaded"
        }, dismissClosure: nil)
        tableView.lfc.addBaseFooterStater(showClosure: { view in
            return "No more content"
        }, dismissClosure: nil)
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
            for value in (count + 1)...(count + 15) {
                data.append("Cell \(value)")
            }
            
            self.cases.append(contentsOf: data)
            self.tableView.reloadData()
            if isRefresh {
                self.tableView.lfc.stopHeaderRefreshing()
                return
            }
            if self.cases.count > 25 {
                self.tableView.lfc.stopFooterRefreshingAndNoMoreData()
            } else {
                self.tableView.lfc.stopFooterRefreshing()
            }
        }
    }
}

extension DotRefreshViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = cases[indexPath.row]
        return cell
    }
}
