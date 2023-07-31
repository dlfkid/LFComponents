//
//  UIBarButtonItemBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation

extension UIBarButtonItem: BadgesAdaptable {
    public func cleanBadge() {
        _bottomView.badges.set(.clean)
    }
    
    public func setBadge(height: CGFloat) {
        _bottomView.setBadge(height: height)
    }
    
    
    public var badgeView: BadgeView {
        return _bottomView.badgeView
    }
    
    public func addDot(color: UIColor?) {
        _bottomView.badges.set(.dot)
    }
    
    public func addBadge(text: String?) {
        _bottomView.badges.set(.text(text))
    }
    
    public func addBadge(number: Int) {
        _bottomView.badges.set(.number(number))
    }
    
    /// 通过Xcode视图调试工具找到UIBarButtonItem的Badge所在父视图为:UIImageView
    private var _bottomView: UIView {
        let navigationButton = (self.value(forKey: "_view") as? UIView) ?? UIView()
        let systemVersion = (UIDevice.current.systemVersion as NSString).doubleValue
        let controlName = (systemVersion < 11.0 ? "UIImageView" : "UIButton" )
        for subView in navigationButton.subviews {
            if subView.isKind(of: NSClassFromString(controlName)!) {
                subView.layer.masksToBounds = false
                return subView
            }
        }
        return navigationButton
    }
}
