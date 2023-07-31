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
    
    private lazy var dotButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 16, y: 300, width: 130, height: 44)
        button.setTitle("Dot", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var clearDotButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 16 - 130,
                              y: 300, width: 130, height: 44)
        button.setTitle("Clear Dot", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var textBadgeInputView: UITextField = {
        let textField = UITextField(frame: CGRect(x: 16, y: 400, width: UIScreen.main.bounds.width - 32, height: 44))
        textField.placeholder = "Input text here"
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()
    
    private lazy var textBadgeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 16, y: 500, width: 130, height: 44)
        button.setTitle("Text Badge", for: .normal)
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
            githubIcon.badges.set(.number(notificationCount))
            rightBarButtonItem.badges.set(.number(notificationCount))
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
        
        view.addSubview(dotButton)
        view.addSubview(clearDotButton)
        
        dotButton.center.y = CGRectGetMaxY(incrementButton.frame) + 18
        clearDotButton.center.y = CGRectGetMaxY(incrementButton.frame) + 18
        
        dotButton.addTarget(self,
                            action: #selector(self.makeDot),
                            for: .touchUpInside)
        
        clearDotButton.addTarget(self,
                                 action: #selector(self.clearDot),
                                 for: .touchUpInside)
        
        view.addSubview(textBadgeButton)
        
        view.addSubview(textBadgeInputView)
        
        textBadgeInputView.center.y = CGRectGetMinY(githubIcon.frame) - 40
        textBadgeInputView.delegate = self
        
        textBadgeButton.center.y = CGRectGetMaxY(dotButton.frame) + 18
        
        textBadgeButton.addTarget(self,
                                  action: #selector(textBadgeAction),
                                  for: .touchUpInside)
        
        
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension BadgesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        notificationText = textBadgeInputView.text ?? ""
        return true
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
    
    @objc private func makeDot() {
        githubIcon.badges.set(.dot)
        rightBarButtonItem.badges.set(.dot)
    }
    
    @objc private func clearDot() {
        githubIcon.badges.set(.clean)
        rightBarButtonItem.badges.set(.clean)
    }
    
    @objc private func textBadgeAction() {
        githubIcon.badges.set(.text(notificationText))
        rightBarButtonItem.badges.set(.text(notificationText))
    }
}
