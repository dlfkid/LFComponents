//
//  BadgesViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/7/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

class BadgesViewController: UIViewController {
    
    private let githubIcon = UIImageView(image: UIImage(named: "github_color"))
    
    private lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 16, y: 200, width: 130, height: 44)
        button.setTitle("Decrement (-1)", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 16 - 130,
                              y: 200, width: 130, height: 44)
        button.setTitle("Increment (+1)", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "RightItem", style: .done, target: self, action: #selector(rightBarButtonAction))
        return item
    }()

    var notificationCount: Int = 0 {
        didSet {
            githubIcon.badges.set(.dot)
        }
    }
    
    var notificationText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Badges"
        view.backgroundColor = .white
        view.addSubview(githubIcon)
        githubIcon.sizeToFit()
        githubIcon.center.x = LayoutConstants.centerX
        githubIcon.center.y = LayoutConstants.centerY - 100
        
        view.addSubview(incrementButton)
        view.addSubview(decrementButton)
        
        incrementButton.center.y = CGRectGetMaxY(githubIcon.frame) + 18
        decrementButton.center.y = CGRectGetMaxY(githubIcon.frame) + 18
        
        incrementButton.addTarget(self,
                                  action: #selector(self.testIncrement),
                                  for: .touchUpInside)
        decrementButton.addTarget(self,
                                  action: #selector(self.testDecrement),
                                  for: .touchUpInside)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension BadgesViewController {
    @objc private func testIncrement() {
        notificationCount += 1
    }
    
    @objc private func testDecrement() {
        notificationCount -= 1
    }
    
    @objc private func rightBarButtonAction() {
        
    }
}
