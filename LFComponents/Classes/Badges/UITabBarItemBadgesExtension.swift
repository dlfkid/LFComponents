//
//  UITabBarItemBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation

extension UITabBarItem: BadgesAdaptable {
    public var lfc_badgeView: BadgeView {
        return _bottomView.lfc_badgeView
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
