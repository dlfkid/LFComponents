//
//  UIViewFoundationExtensions.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation

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
    
    private func constraint(with item: AnyObject?, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if let isSame = constraint.firstItem?.isEqual(item), isSame, constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
}
