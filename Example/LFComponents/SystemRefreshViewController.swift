//
//  SystemRefreshViewController.swift
//  NXDesignDevDemo
//
//  Created by Ravendeng on 2023/1/5.
//

import Foundation
import LFComponents

class SystemRefreshViewController: UIViewController, RefreshShowable {
    
    private let reuseIdentifier = "system.showcase"
    
    var tintStyle: LFCRefreshTintStyle = .black
    
    var iconSize: LFCRefreshIconSize = .medium
    
    var cases: [String] = [String]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
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
        title = "System Refresh"
        tableView.lfc.addRefreshHeader(type:.system, style: tintStyle, size: iconSize, target: self, selector: #selector(refreshHeaderEvent))
        tableView.lfc.addRefreshFooter(type: .system, style: tintStyle, size: iconSize, target: self, selector: #selector(refreshFooterEvent))
        tableView.lfc.addBaseHeaderStater(showClosure: { view in
            return "\(self.cases.count) items of data loaded"
        }, dismissClosure: nil)
        tableView.lfc.addBaseFooterStater(showClosure: { view in
            return "No more content"
        }, dismissClosure: nil)
    }
    
    @objc private func refreshHeaderEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appendDataStopRefresh(isRefresh: true)
        }
    }
    
    @objc private func refreshFooterEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appendDataStopRefresh(isRefresh: false)
        }
    }
    
    private func appendDataStopRefresh(isRefresh: Bool) {
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
        if self.cases.count > 35 {
            self.tableView.lfc.stopFooterRefreshingAndNoMoreData()
        } else {
            self.tableView.lfc.stopFooterRefreshing()
        }
    }
}

extension SystemRefreshViewController: UITableViewDelegate, UITableViewDataSource {
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

