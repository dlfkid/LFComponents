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
    
    public var badgeView: BadgeView {
        return _bottomView.badgeView
    }
    
    public func addDot() {
        _bottomView.addDot()
    }
    
    public func addBadge(text: String?) {
        _bottomView.addBadge(text: text)
    }
    
    public func addBadge(number: Int) {
        _bottomView.addBadge(number: number)
    }
    
    public func addBadge(icon: UIImage?) {
        _bottomView.addBadge(icon: icon)
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
