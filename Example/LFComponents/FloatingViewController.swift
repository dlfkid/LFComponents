//
//  ShowCaseRefreshViewController.swift
//  ExampleDemo
//
//  Created by Ravendeng on 2024/10/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

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
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        containerView.addSubview(draggableView)
        draggableView.frame = CGRect(x: 60, y: 90, width: 150, height: 90)
        draggableView.lfc.makeDraggable()
        draggableView.lfc.makeHalfShink(interval: 5)
        draggableView.lfc.isKeepBounds = true
    }
}
