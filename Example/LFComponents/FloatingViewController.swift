//
//  ShowCaseRefreshViewController.swift
//  ExampleDemo
//
//  Created by Ravendeng on 2024/10/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class FloatingViewController: UIViewController {
    
    private lazy var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .lightGray
        return containerView
    }()
    
    private lazy var draggableView: UIView = {
        let dragView = UIView(frame: .zero)
        dragView.backgroundColor = .cyan
        return dragView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "悬浮窗"
        containerView.translatesAutoresizingMaskIntoConstraints = false
        draggableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.addSubview(draggableView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            draggableView.widthAnchor.constraint(equalToConstant: 150),
            draggableView.heightAnchor.constraint(equalToConstant: 90),
            draggableView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            draggableView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

}
