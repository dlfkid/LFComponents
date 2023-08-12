//
//  AirplaneViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

class AirplaneViewController: UIViewController, SideMenuControllable {
    
    weak var sideMenuContainer: LFComponents.SideMenuContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        title = "AirPlane"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(menuButtonAction))
    }
}

extension AirplaneViewController {
    @objc private func menuButtonAction() {
        guard let delegate = sideMenuContainer else {
            return
        }
        delegate.sidemenuSwitchState()
    }
}
