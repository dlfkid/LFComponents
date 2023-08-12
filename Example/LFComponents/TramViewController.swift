//
//  TramViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

class TramViewController: UIViewController, SideMenuControllable {
    
    weak var sideMenuContainer: LFComponents.SideMenuContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Tram"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(menuButtonAction))
    }

}

extension TramViewController {
    @objc private func menuButtonAction() {
        guard let delegate = sideMenuContainer else {
            return
        }
        delegate.sidemenuSwitchState()
    }
}
