//
//  Badges.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import UIKit

/// The available badge content type
public enum BadgeStyle {
    case dot
    case number(_ number: Int?)
    case text(_ text: String?)
    case icon(_ icon: UIImage?)
    case clean
}

public enum BadgePostion: CaseIterable {
    case topRightCorner
    case topLeftCorner
    case leftMiddle
    case rightMiddle
    case bottomRightCorner
    case bottomLeftCorner
}

extension BadgePostion {
    public var positionDesc: String {
        switch self {
        case .topRightCorner:
            return "Top right corner"
        case .topLeftCorner:
            return "Top left corner"
        case .leftMiddle:
            return "Left middle"
        case .rightMiddle:
            return "Right middle"
        case .bottomLeftCorner:
            return "Bottom left corner"
        case .bottomRightCorner:
            return "Bottom right corner"
        }
    }
}

public protocol BadgesAdaptable {
    var badgeView: BadgeView {get}
    
    func addDot()
    
    func addBadge(text: String?)
    
    func addBadge(number: Int)
    
    func addBadge(icon: UIImage?)
    
    func cleanBadge()
}

// MARK: - BadgesAdaptable default implementaions

extension BadgesAdaptable {
    public func move(badgeView: BadgeView, position: BadgePostion, offset: CGPoint) {
        guard let superView = badgeView.superview else {
            return
        }
        switch position {
        case .topRightCorner: do {
            badgeView.sizeToFit()
            let right = superView.width
            let offset = badgeView.image == nil ? 4.0 : 8.0
            badgeView.x = right + offset
            badgeView.y = 0
        }
            
        case .topLeftCorner: do {
            badgeView.sizeToFit()
            let right = 0.0
            let offset = badgeView.image == nil ? 4.0 : 8.0
            badgeView.x = right - offset
            badgeView.y = 0
        }
            
        case .leftMiddle: do {
            badgeView.sizeToFit()
            let offset = badgeView.image == nil ? 4.0 : 8.0
            badgeView.right = -offset
            badgeView.centerY = superView.height / 2
        }
            
        case .rightMiddle: do {
            badgeView.sizeToFit()
            let offset = badgeView.image == nil ? 4.0 : 8.0
            badgeView.left = superView.width + offset
            badgeView.centerY = superView.height / 2
        }
            
        case .bottomLeftCorner: do {
            badgeView.sizeToFit()
            let right = 0.0
            let offset = badgeView.image == nil ? 4.0 : 8.0
            badgeView.x = right - offset
            badgeView.bottom = superView.height
        }
            
        case .bottomRightCorner: do {
            badgeView.sizeToFit()
            let right = superView.width
            let offset = badgeView.image == nil ? 4.0 : 8.0
            badgeView.x = right + offset
            badgeView.bottom = superView.height
        }
        }
        // 向左不可超过自身一半, 或16px
        let limitMinX = -(badgeView.image == nil ? 16 : badgeView.width / 2)
        let x = max(limitMinX, offset.x)
        badgeView.x += x
        // 向上不可超过徽标2/1
        let limitY = -(badgeView.height / 2)
        let y = max(limitY, offset.y)
        badgeView.y += y
    }
}

public struct Badges<BaseView: BadgesAdaptable> {
    /// 宿主View
    fileprivate let baseView: BaseView
    public init(baseView: BaseView) {
        self.baseView = baseView
    }
    
    /// 便利构造方法, 在View右上角与自身顶部平齐距离自身4px的位置创建徽标
    /// - Parameter content: 徽标内容
    public func set(_ content: BadgeStyle) {
        set(content: content, position: .topRightCorner)
    }
    
    /// 设置徽标
    /// - Parameters:
    ///   - content: 徽标内容
    ///   - position: 徽标起始位置
    ///   - offset: 根据起始位置做的偏移量
    public func set(content: BadgeStyle, position: BadgePostion, offset: CGPoint = CGPointMake(0, 0), color: UIColor = .red) {
        switch content {
        case .dot:
            baseView.addDot()
            baseView.badgeView.backgroundColor = color
        case let .number(number: number):
            baseView.addBadge(number: number ?? 0)
            baseView.badgeView.backgroundColor = color
        case let .text(text: text):
            baseView.addBadge(text: text ?? "")
            baseView.badgeView.backgroundColor = color
        case let .icon(icon: icon):
            baseView.addBadge(icon: icon)
            baseView.badgeView.backgroundColor = .clear
        case .clean:
            baseView.cleanBadge()
        }
        baseView.move(badgeView: baseView.badgeView, position: position, offset: offset)
    }
}

public extension NSObjectProtocol where Self: BadgesAdaptable {
    var badges: Badges<Self> {
        return Badges(baseView: self)
    }
}

public class BadgeView: UIControl {
    static var badgeViewIdentifier: Void?
    
    /// 记录Badge的偏移量 Record the offset of Badge
    public var offset: CGPoint = CGPoint(x: 0, y: 0)
    
    private lazy var textLabel: UILabel = UILabel()
    
    private lazy var imageView: UIImageView = UIImageView()
    
    private var badgeViewColor: UIColor?
    private var badgeViewHeightConstraint: NSLayoutConstraint?
    
    /// Set Text
    public var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    /// Set Font
    public var font: UIFont? {
        didSet {
            textLabel.font = font
        }
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            if let color = backgroundColor, color != .clear {
                badgeViewColor = backgroundColor
            }
        }
    }
    
    public class func `default`() -> Self {
        return self.init(frame: .zero)
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        layer.masksToBounds = true
        layer.cornerRadius = 9.0
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.red
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textAlignment = .center
        addSubview(textLabel)
        addSubview(imageView)
    }
    
    public override func sizeToFit() {
        textLabel.sizeToFit()
        imageView.sizeToFit()
        let margin = text == nil && image == nil ? 6.0 : 5.0
        let width = max(textLabel.frame.width, imageView.frame.width) + margin
        let height = max(textLabel.frame.height, imageView.frame.height) + margin
        let actualWidth = max(width, height)
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: actualWidth, height: height)
        textLabel.center = CGPoint(x: self.width / 2, y: self.height / 2)
        imageView.center = CGPoint(x: self.width / 2, y: self.height / 2)
        layer.cornerRadius = image == nil ? height / 2 : 0
        setNeedsLayout()
    }
}
