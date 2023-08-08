//
//  TramViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class TramViewController: UIViewController {
    
    public weak var delegate: SideMenuControllable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Tram"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(menuButtonAction))
    }

}

extension TramViewController {
    @objc private func menuButtonAction() {
        guard let delegate = delegate else {
            return
        }
        delegate.sidemenuSwitchState()
    }
}
