//
//  BusViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

class BusViewController: UIViewController, SideMenuControllable {
    
    weak var sideMenuContainer: LFComponents.SideMenuContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        title = "Bus"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(menuButtonAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pop", style: .plain, target: self, action: #selector(popAction))
    }

}

extension BusViewController {
    @objc private func menuButtonAction() {
        guard let delegate = sideMenuContainer else {
            return
        }
        delegate.sidemenuSwitchState()
    }
    
    @objc private func popAction() {
        guard let delegate = sideMenuContainer else {
            return
        }
        delegate.navigationController?.popViewController(animated: true)
    }
}
