//
//  UIViewFoundationExtensions.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation

// MARK: - Base

// MARK: - BadgeView
extension UIView {
    
    public var lfc_badgeView: BadgeView {
        get {
            guard let aValue = objc_getAssociatedObject(self, &BadgeView.badgeViewIdentifier) as? BadgeView else {
                let badgeControl = BadgeView.default()
                self.addSubview(badgeControl)
                self.bringSubviewToFront(badgeControl)
                self.lfc_badgeView = badgeControl
                return badgeControl
            }
            return aValue
        }
        set {
            objc_setAssociatedObject(self, &BadgeView.badgeViewIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIView {

    // x

    var x : CGFloat {

        get {

            return frame.origin.x

        }

        set(newVal) {

            var tmpFrame : CGRect = frame

            tmpFrame.origin.x     = newVal

            frame                 = tmpFrame

        }

    }

    // y

    var y : CGFloat {

        get {

            return frame.origin.y

        }

        set(newVal) {

            var tmpFrame : CGRect = frame

            tmpFrame.origin.y     = newVal

            frame                 = tmpFrame

        }

    }

    // height

    var height : CGFloat {

        get {

            return frame.size.height

        }

        set(newVal) {

            var tmpFrame : CGRect = frame

            tmpFrame.size.height  = newVal

            frame                 = tmpFrame

        }

    }

    // width

    var width : CGFloat {

        get {

            return frame.size.width

        }

        set(newVal) {

            var tmpFrame : CGRect = frame

            tmpFrame.size.width   = newVal

            frame                 = tmpFrame

        }

    }

    // left

    var left : CGFloat {

        get {

            return x

        }

        set(newVal) {

            x = newVal

        }

    }

    // right

    var right : CGFloat {

        get {

            return x + width

        }

        set(newVal) {

            x = newVal - width

        }

    }

    // top

    var top : CGFloat {

        get {

            return y

        }

        set(newVal) {

            y = newVal

        }

    }

    // bottom

    var bottom : CGFloat {

        get {

            return y + height

        }

        set(newVal) {

            y = newVal - height

        }

    }

    var centerX : CGFloat {

        get {

            return center.x

        }

        set(newVal) {

            center = CGPoint(x: newVal, y: center.y)

        }

    }

    var centerY : CGFloat {

        get {

            return center.y

        }

        set(newVal) {

            center = CGPoint(x: center.x, y: newVal)

        }

    }

    var middleX : CGFloat {

        get {

            return width / 2

        }

    }

    var middleY : CGFloat {

        get {

            return height / 2

        }

    }

    var middlePoint : CGPoint {

        get {

           return CGPoint(x: middleX, y: middleY)

        }

    }
}
