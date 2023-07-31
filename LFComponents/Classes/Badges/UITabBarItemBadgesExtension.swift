//
//  UITabBarItemBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation

extension UITabBarItem: BadgesAdaptable {
    public func setBadge(height: CGFloat) {
        _bottomView.badgeView.setBadge(height: height)
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
    
    public func cleanBadge() {
        _bottomView.badges.set(.clean)
    }
    
    /// 通过Xcode视图调试工具找到UITabBarItem原生Badge所在父视图
    private var _bottomView: UIView {
        let tabBarButton = (self.value(forKey: "_view") as? UIView) ?? UIView()
        for subView in tabBarButton.subviews {
            guard let superclass = subView.superclass else { return tabBarButton }
            if superclass == NSClassFromString("UIImageView") {
                return subView
            }
        }
        return tabBarButton
    }
}
