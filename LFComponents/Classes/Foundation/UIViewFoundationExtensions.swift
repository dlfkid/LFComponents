//
//  UIViewFoundationExtensions.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation

// MARK: - Base

extension UIView {
    internal func topConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .top)
    }
    
    internal func leadingConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .leading)
    }
    
    internal func bottomConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .bottom)
    }

    internal func trailingConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .trailing)
    }
    
    internal func widthConstraint() -> NSLayoutConstraint? {
        return constraint(with: self, attribute: .width)
    }
    
    internal func heightConstraint() -> NSLayoutConstraint? {
        return constraint(with: self, attribute: .height)
    }

    internal func centerXConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .centerX)
    }
    
    internal func centerYConstraint(with item: AnyObject?) -> NSLayoutConstraint? {
        return constraint(with: item, attribute: .centerY)
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
    
    private func constraint(with item: AnyObject?, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if let isSame = constraint.firstItem?.isEqual(item), isSame, constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
}

// MARK: - BadgeView
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
