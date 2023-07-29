//
//  UIViewBadagesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import UIKit

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
