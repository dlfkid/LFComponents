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
    case number(_ number: Int)
    case text(_ text: String)
}

public protocol BadgesAdaptable {
    var badgeView: BadgeView {get}
    
    var isHidden: Bool {get set}
}

// MARK: - BadgesAdaptable default implementaions

extension BadgesAdaptable {
    public var isHidden: Bool {
        get {
            badgeView.isHidden
        }
        
        set {
            badgeView.isHidden = newValue
        }
    }
}

public class Badges<BaseView: BadgesAdaptable> {
    public let baseView: BaseView
    public init(baseView: BaseView) {
        self.baseView = baseView
    }
    
    public func set(_ content: BadgeStyle) {
        
    }
}

public extension NSObjectProtocol where Self: BadgesAdaptable {
    var badges: Badges<Self> {
        return Badges(baseView: self)
    }
}

public class BadgeView: UIControl {
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
    
    /// Set Font
    public var font: UIFont? {
        didSet {
            textLabel.font = font
        }
    }
    
    /// Set background image
    public var backgroundImage: UIImage? {
        didSet {
            imageView.image = backgroundImage
            if let _ = backgroundImage {
                if let constraint = heightConstraint() {
                    badgeViewHeightConstraint = constraint
                    removeConstraint(constraint)
                }
                backgroundColor = UIColor.clear
            } else {
                if heightConstraint() == nil, let constraint = badgeViewHeightConstraint {
                    addConstraint(constraint)
                }
                backgroundColor = badgeViewColor
            }
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
        addLayout(with: imageView, leading: 0, trailing: 0)
        addLayout(with: textLabel, leading: 5, trailing: -5)
    }
    
    private func addLayout(with view: UIView, leading: CGFloat, trailing: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: leading)
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: trailing)
        leadingConstraint.priority = UILayoutPriority(rawValue: 999)
        trailingConstraint.priority = UILayoutPriority(rawValue: 999)
        addConstraints([topConstraint, leadingConstraint, bottomConstraint, trailingConstraint])
    }
}
