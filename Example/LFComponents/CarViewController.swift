//
//  CarViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {
    
    public weak var delegate: SideMenuControllable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        title = "car"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(menuButtonAction))
    }
}

extension CarViewController {
    @objc private func menuButtonAction() {
        guard let delegate = delegate else {
            return
        }
        delegate.sidemenuSwitchState()
    }
}
