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
        isHidden = false
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
            isHidden = true
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
        setBadge(height: 8.0)
        badgeView.backgroundColor = color
    }
    
    /// 设置Badge的偏移量, Badge中心点默认为其父视图的右上角
    ///
    /// Set Badge offset, Badge center point defaults to the top right corner of its parent view
    ///
    /// - Parameters:
    ///   - x: X轴偏移量 (x<0: 左移, x>0: 右移) axis offset (x <0: left, x> 0: right)
    ///   - y: Y轴偏移量 (y<0: 上移, y>0: 下移) axis offset (Y <0: up,   y> 0: down)
    private func moveBadge(x: CGFloat, y: CGFloat) {
        badgeView.offset = CGPoint(x: x, y: y)
        centerYConstraint(with: badgeView)?.constant = y
        
        let badgeHeight = badgeView.heightConstraint()?.constant ?? 0
        centerXConstraint(with: badgeView)?.isActive = false
        trailingConstraint(with: badgeView)?.isActive = false
        if let constraint = leadingConstraint(with: badgeView) {
            constraint.constant = x - badgeHeight * 0.5
            return
        }
        let leadingConstraint = NSLayoutConstraint(item: badgeView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: x - badgeHeight * 0.5)
        addConstraint(leadingConstraint)
    }
    
    /// 设置Badge的高度,因为Badge宽度是动态可变的,通过改变Badge高度,其宽度也按比例变化,方便布局
    ///
    /// (注意: 此方法需要将Badge添加到控件上后再调用!!!)
    ///
    /// Set the height of Badge, because the Badge width is dynamically and  variable.By changing the Badge height in proportion to facilitate the layout.
    ///
    /// (Note: this method needs to add Badge to the controls and then use it !!!)
    ///
    /// - Parameter height: 高度大小
    public func setBadge(height: CGFloat) {
        badgeView.layer.cornerRadius = height * 0.5
        badgeView.heightConstraint()?.constant = height
        moveBadge(x: badgeView.offset.x, y: badgeView.offset.y)
    }
}

// MARK: - Base
extension UIView {
    
    static var badgeViewIdentifier = "lf_badge_view_identifier"
    
    public var badgeView: BadgeView {
        get {
            guard let aValue = objc_getAssociatedObject(self, &UIView.badgeViewIdentifier) as? BadgeView else {
                let badgeControl = BadgeView.default()
                self.addSubview(badgeControl)
                self.bringSubview(toFront: badgeControl)
                self.badgeView = badgeControl
                self.addBadgeViewLayoutConstraint()
                return badgeControl
            }
            return aValue
        }
        set {
            objc_setAssociatedObject(self, &UIView.badgeViewIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func addBadgeViewLayoutConstraint() {
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = NSLayoutConstraint(item: badgeView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: badgeView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: badgeView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: badgeView, attribute: .height, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: badgeView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18)
        addConstraints([centerXConstraint, centerYConstraint])
        badgeView.addConstraints([widthConstraint, heightConstraint])
    }
}
