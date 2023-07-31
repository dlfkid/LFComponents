//
//  UIViewBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import UIKit

extension UIView: BadgesAdaptable {
    
    /// 添加带文本内容的Badge, 默认右上角, 红色, 18pts
    ///
    /// Add Badge with text content, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter text: 文本字符串
    public func addBadge(text: String?) {
        badgeView.isHidden = false
        badgeView.text = text
        if text == nil {
            if badgeView.widthConstraint()?.relation == .equal { return }
            badgeView.widthConstraint()?.isActive = false
            let constraint = NSLayoutConstraint(item: badgeView, attribute: .width, relatedBy: .equal, toItem: badgeView, attribute: .height, multiplier: 1.0, constant: 0)
            badgeView.addConstraint(constraint)
        } else {
            if badgeView.widthConstraint()?.relation == .greaterThanOrEqual { return }
            badgeView.widthConstraint()?.isActive = false
            let constraint = NSLayoutConstraint(item: badgeView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: badgeView, attribute: .height, multiplier: 1.0, constant: 0)
            badgeView.addConstraint(constraint)
        }
    }
    
    /// 添加带数字的Badge, 默认右上角,红色,18pts
    ///
    /// Add the Badge with numbers, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter number: 整形数字
    public func addBadge(number: Int) {
        if number <= 0 {
            addBadge(text: "0")
            badgeView.isHidden = true
            return
        }
        addBadge(text: "\(number)")
    }
    
    /// 添加带颜色的小圆点, 默认右上角, 红色, 8pts
    ///
    /// Add small dots with color, the default upper right corner, red backgroundColor, 8pts
    ///
    /// - Parameter color: 颜色
    public func addDot(color: UIColor?) {
        guard let color = color else {
            addDot(color: .red)
            return
        }
        addBadge(text: nil)
        badgeView.backgroundColor = color
    }
    
    public func cleanBadge() {
        badgeView.isHidden = true
    }
}
