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
        lfc_badgeView.isHidden = false
        lfc_badgeView.text = text
        lfc_badgeView.image = nil
        bringSubviewToFront(lfc_badgeView)
    }
    
    /// 添加带数字的Badge, 默认右上角,红色,18pts
    ///
    /// Add the Badge with numbers, the default upper right corner, red backgroundColor, 18pts
    ///
    /// - Parameter number: 整形数字
    public func addBadge(number: Int) {
        guard number > 0 else {
            addBadge(text: "0")
            lfc_badgeView.isHidden = true
            return
        }
        guard number <= 999 else {
            addBadge(text: "999+")
            return
        }
        addBadge(text: "\(number)")
    }
    
    /// 添加带颜色的小圆点, 默认右上角, 红色, 8pts
    public func addDot() {
        addBadge(text: nil)
    }
    
    public func addBadge(icon: UIImage?) {
        lfc_badgeView.isHidden = false
        lfc_badgeView.image = icon
        lfc_badgeView.text = nil
        bringSubviewToFront(lfc_badgeView)
    }
    
    public func cleanBadge() {
        lfc_badgeView.isHidden = true
    }
}
