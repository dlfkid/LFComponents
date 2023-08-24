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
    
    private var offsetX: CGFloat = 0
    private var offsetY: CGFloat = 0
    
    private var badgePosition = BadgePostion.topRightCorner
    
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
    
    private lazy var changePositionButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 16 - 130,
                              y: 500, width: 130, height: 44)
        button.setTitle("Change Position", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var iconBadgeButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 16 - 130,
                              y: 500, width: 130, height: 44)
        button.setTitle("Icon badge", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private lazy var offsetSliderX: UISlider = {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 100, height: 18))
        slider.maximumValue = 30
        slider.minimumValue = -30
        return slider
    }()
    
    private lazy var labelSliderX: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "offset X = 0"
        label.sizeToFit()
        return label
    }()
    
    private lazy var offsetSliderY: UISlider = {
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 100, height: 18))
        slider.maximumValue = 30
        slider.minimumValue = -30
        return slider
    }()
    
    private lazy var labelSliderY: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "offset Y = 0"
        label.sizeToFit()
        return label
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "RightItem", style: .done, target: self, action: #selector(rightBarButtonAction))
        return item
    }()

    var notificationCount: Int = 0 {
        didSet {
            githubIcon.badges.set(content: .number(notificationCount), position: badgePosition, offset: CGPoint(x: offsetX, y: offsetY))
            rightBarButtonItem.badges.set(content: .number(notificationCount), position: badgePosition, offset: CGPoint(x: offsetX, y: offsetY))
        }
    }
    
    var notificationText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = rightBarButtonItem
        title = "Badges"
        view.backgroundColor = .white
        view.addSubview(githubIcon)
        githubIcon.sizeToFit()
        githubIcon.center.x = LayoutConstants.screenWidth / 2
        githubIcon.center.y = LayoutConstants.screenHeight / 2 - 100
        
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
        
        view.addSubview(changePositionButton)
        changePositionButton.center.y = CGRectGetMaxY(textBadgeButton.frame) + 18
        changePositionButton.addTarget(self,
                                       action: #selector(changePositionAction),
                                       for: .touchUpInside)
        
        view.addSubview(iconBadgeButton)
        iconBadgeButton.y = textBadgeButton.y
        iconBadgeButton.centerX = clearDotButton.centerX
        iconBadgeButton.addTarget(self, action: #selector(iconBadgeAction), for: .touchUpInside)
        
        offsetSliderX.addTarget(self, action: #selector(sliderNewValueAction(_:)), for: .valueChanged)
        view.addSubview(offsetSliderX)
        offsetSliderX.bottom = textBadgeInputView.top - 16
        offsetSliderX.centerX = textBadgeInputView.centerX
        
        view.addSubview(labelSliderX)
        labelSliderX.centerY = offsetSliderX.centerY
        labelSliderX.right = offsetSliderX.left - 10
        
        offsetSliderY.addTarget(self, action: #selector(sliderNewValueAction(_:)), for: .valueChanged)
        view.addSubview(offsetSliderY)
        offsetSliderY.bottom = offsetSliderX.top - 16
        offsetSliderY.centerX = textBadgeInputView.centerX
        
        view.addSubview(labelSliderY)
        labelSliderY.centerY = offsetSliderY.centerY
        labelSliderY.right = offsetSliderY.left - 10
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
        githubIcon.badges.set(content: .dot, position: badgePosition, offset: CGPoint(x: offsetX, y: offsetY))
        rightBarButtonItem.badges.set(content: .dot, position: badgePosition, offset: CGPoint(x: offsetX, y: offsetY))
    }
    
    @objc private func clearDot() {
        githubIcon.badges.set(.clean)
        rightBarButtonItem.badges.set(.clean)
    }
    
    @objc private func textBadgeAction() {
        githubIcon.badges.set(content: .text(notificationText), position: badgePosition, offset: CGPoint(x: offsetX, y: offsetY))
        rightBarButtonItem.badges.set(content: .text(notificationText), position: badgePosition, offset: CGPoint(x: offsetX, y: offsetY))
    }
    
    @objc private func iconBadgeAction() {
        githubIcon.badges.set(content: .icon(UIImage(named: "verified")), position: badgePosition, offset: CGPoint(x: offsetX, y: offsetY))
    }
    
    @objc private func changePositionAction() {
        let actionSheet = UIAlertController(title: "Switch BadgePosition", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: BadgePostion.topRightCorner.positionDesc, style: .default)
        { (action) in
            self.badgePosition = .topRightCorner
        }
        let action2 = UIAlertAction(title: BadgePostion.leftMiddle.positionDesc, style: .default)
        { (action) in
            self.badgePosition = .leftMiddle
        }
        let action3 = UIAlertAction(title: BadgePostion.rightMiddle.positionDesc, style: .default)
        { (action) in
            self.badgePosition = .rightMiddle
        }
        let action4 = UIAlertAction(title: BadgePostion.topLeftCorner.positionDesc, style: .default)
        { (action) in
            self.badgePosition = .topLeftCorner
        }
        let action5 = UIAlertAction(title: BadgePostion.bottomLeftCorner.positionDesc, style: .default)
        { (action) in
            self.badgePosition = .bottomLeftCorner
        }
        let action6 = UIAlertAction(title: BadgePostion.bottomRightCorner.positionDesc, style: .default)
        { (action) in
            self.badgePosition = .bottomRightCorner
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        actionSheet.addAction(action5)
        actionSheet.addAction(action6)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    @objc private func sliderNewValueAction(_ sender: UISlider) {
        if sender == offsetSliderX {
            offsetX = CGFloat(sender.value)
            labelSliderX.text = String(format: "offset X: %.1f", offsetX)
            labelSliderX.sizeToFit()
            labelSliderX.right = offsetSliderX.left - 10
            return
        }
        if sender == offsetSliderY {
            offsetY = CGFloat(sender.value)
            labelSliderY.text = String(format: "offset Y: %.1f", offsetY)
            labelSliderY.sizeToFit()
            labelSliderY.right = offsetSliderY.left - 10
            return
        }
    }
}
