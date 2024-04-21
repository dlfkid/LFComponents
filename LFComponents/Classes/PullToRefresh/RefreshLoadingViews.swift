//
//  RefreshViewController.swift
//  ExampleDevDemo
//
//  Created by Ravendeng on 2023/1/5.
//

import Foundation
import UIKit

enum LFCRefreshLoadingDotState {
    case dot1On
    case dot2On
    case dot3On
}

protocol LFCRefreshDotAnimatable {
    var state: LFCRefreshLoadingDotState {get set}
}

extension LFCRefreshDotAnimatable {
    func nextDotState(state: LFCRefreshLoadingDotState) -> LFCRefreshLoadingDotState {
        switch state {
        case .dot1On:
            return .dot2On
        case .dot2On:
            return .dot3On
        case .dot3On:
            return .dot1On
        }
    }
}

class LFCRefreshLoadingCircleView: LFCRefreshLoadingDefaultView {
}

class LFCRefreshLoadingSystemView: LFCRefreshLoadingDefaultView {
    /// 每次触发动画旋转的幅度， 默认为1/30
    override var rotationAnglePerTriggered: CGFloat {
        return 34/800
    }
}

class LFCRefreshLoadingDotsView: LFCRefreshLoadingDefaultView, LFCRefreshDotAnimatable {
    
    override var animationTriggeredRate: CGFloat {
        return 0.28
    }
    
    internal var state: LFCRefreshLoadingDotState = .dot1On {
        didSet {
            let style = refreshTintStyle
            switch state {
            case .dot1On:
                dot1.backgroundColor = style.mainColor
                dot2.backgroundColor = style.sideColor
                dot3.backgroundColor = style.sideColor
            case .dot2On:
                dot1.backgroundColor = style.sideColor
                dot2.backgroundColor = style.mainColor
                dot3.backgroundColor = style.sideColor
            case .dot3On:
                dot1.backgroundColor = style.sideColor
                dot2.backgroundColor = style.sideColor
                dot3.backgroundColor = style.mainColor
            }
        }
    }
    
    private let dot1 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    
    private let dot2 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    
    private let dot3 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    
    private var animationTimer: Timer? = nil
    
    override func configUI() {
        super.configUI()
        dot1.layer.cornerRadius = 2.5
        containerView.addSubview(dot1)
        dot2.layer.cornerRadius = 2.5
        containerView.addSubview(dot2)
        dot3.layer.cornerRadius = 2.5
        containerView.addSubview(dot3)
        state = .dot1On
    }
    
    override func updateLoadingStyle() {
        super.updateLoadingStyle()
        dot3.centerY = titleLabel.centerY
        dot3.right = titleLabel.left - 16
        dot2.centerY = titleLabel.centerY
        dot2.right = titleLabel.left - 16 - 5 - 8
        dot1.centerY = titleLabel.centerY
        dot1.right = titleLabel.left - 16 - 5 - 8 - 5 - 8
    }
    
    override func validateTimer() {
        animationTimer = Timer(timeInterval: animationTriggeredRate, target: self, selector: #selector(dotsRefreshAnimation), userInfo: nil, repeats: true)
        RunLoop.current.add(animationTimer!, forMode: RunLoop.Mode.common)
        animationTimer?.fire()
    }
    
    override func invalidateTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

extension LFCRefreshLoadingDotsView {
    @objc private func dotsRefreshAnimation() {
        state = nextDotState(state: self.state)
    }
}


class LFCRefreshLoadingDefaultView: LFCRefreshBaseView {
    var actionTextMap: [LFCRefreshLoadingViewStatus : String]?
    
    func updateLoadingInterface(for status: LFCRefreshLoadingViewStatus) {
        guard let text = actionTextMap?[status] as? String else {
            switch status {
            case .normal:
                titleLabel.text = "Pull to refresh"
            case .canRefresh:
                titleLabel.text = "Relase to begin refresh"
            case .refreshing:
                titleLabel.text = "Refreshing ..."
            }
            return
        }
        titleLabel.text = text
    }
    
    /// 每次触发动画旋转的幅度， 默认为1/30
    var rotationAnglePerTriggered: CGFloat {
        return 1/15
    }
    
    /// 动画触发周期
    var animationTriggeredRate: CGFloat {
        return 1/60
    }
    
    var refreshSize: LFCRefreshIconSize = .medium {
        didSet {
            updateLoadingStyle()
        }
    }
    
    var refreshTintStyle: LFCRefreshTintStyle = .black {
        didSet {
            updateLoadingStyle()
        }
    }
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate let containerView = UIView(frame: .zero)
    
    var isLoading: Bool = false
    
    /// 设置刷新中image
    var loadingImage: UIImage? {
        get {
            loadingImageView.image
        }
        set {
            loadingImageView.image = newValue
        }
    }

    /// 刷新中的图片
    fileprivate var loadingImageView: UIImageView = UIImageView()
    /// 刷新定时器
    fileprivate var timer: Timer?
    /// 角度
    private var angle: CGFloat = 0.0

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    func startLoading() {
        isLoading = true
        validateTimer()
        updateLoadingStyle()
    }
    
    func stopLoading() {
        isLoading = false
        invalidateTimer()
        loadingImageView.transform = .identity
        updateLoadingStyle()
    }
    
    // MARK: - Layout
    
    fileprivate func configUI() {
        autoresizingMask = .flexibleWidth
        addSubview(containerView)
        containerView.addSubview(loadingImageView)
        containerView.addSubview(titleLabel)
        updateLoadingInterface(for: .normal)
        establishConstraints()
    }
    
    /// 布置约束
    private func establishConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Center containerView in the middle of its superview
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Pin loadingImageView to the left, top, and bottom of containerView
            loadingImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            loadingImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loadingImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Set titleLabel to the right of loadingImageView and center it vertically to loadingImageView
            titleLabel.leftAnchor.constraint(equalTo: loadingImageView.rightAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: loadingImageView.centerYAnchor),
            
            // Pin titleLabel to the right of containerView
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            // Ensure the containerView accommodates the size of loadingImageView and titleLabel
            containerView.rightAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor)
        ])
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLoadingStyle()
    }
    
    fileprivate func updateLoadingStyle() {
        let iconSize = refreshSize.size
        loadingImageView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        let style = refreshTintStyle
        titleLabel.textColor = style.mainColor
        titleLabel.font = refreshSize.font
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard nil == newSuperview else { return }
        invalidateTimer()
    }
    
    // MARK: - Private - Timer
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func validateTimer() {
        invalidateTimer()
        timer = Timer(timeInterval: animationTriggeredRate, target: self, selector: #selector(loadingSel), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    @objc private func loadingSel() {
        angle += rotationAnglePerTriggered
        loadingImageView.transform = CGAffineTransform(rotationAngle: angle * CGFloat(Double.pi))
    }
}

class LFCRefreshLoadingMoreCircleView: LFCRefreshLoadingMoreDeafultView {
    
    /// 每次触发动画旋转的幅度， 默认为1/30
    override var rotationAnglePerTriggered: CGFloat {
        return 1/15
    }
    
}

class LFCRefreshLoadingMoreSystemView: LFCRefreshLoadingMoreDeafultView {
    
    /// 每次触发动画旋转的幅度， 默认为1/30
    override var rotationAnglePerTriggered: CGFloat {
        return 34/800
    }
}

class LFCRefreshLoadingMoreDotsView: LFCRefreshLoadingMoreDeafultView, LFCRefreshDotAnimatable {
    
    override var animationTriggeredRate: CGFloat {
        return 0.28
    }
    
    internal var state: LFCRefreshLoadingDotState = .dot1On {
        didSet {
            let style = refreshTintStyle
            switch state {
            case .dot1On:
                dot1.backgroundColor = style.mainColor
                dot2.backgroundColor = style.sideColor
                dot3.backgroundColor = style.sideColor
            case .dot2On:
                dot1.backgroundColor = style.sideColor
                dot2.backgroundColor = style.mainColor
                dot3.backgroundColor = style.sideColor
            case .dot3On:
                dot1.backgroundColor = style.sideColor
                dot2.backgroundColor = style.sideColor
                dot3.backgroundColor = style.mainColor
            }
        }
    }
    
    private let dot1 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    
    private let dot2 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    
    private let dot3 = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
    
    private var animationTimer: Timer? = nil
    
    override func configUI() {
        super.configUI()
        dot1.layer.cornerRadius = 2.5
        containerView.addSubview(dot1)
        dot2.layer.cornerRadius = 2.5
        containerView.addSubview(dot2)
        dot3.layer.cornerRadius = 2.5
        containerView.addSubview(dot3)
        state = .dot1On
    }
    
    override func updateLoadingStyle() {
        super.updateLoadingStyle()
        dot3.centerY = titleLabel.centerY
        dot3.right = titleLabel.left - 16
        dot2.centerY = titleLabel.centerY
        dot2.right = titleLabel.left - 16 - 5 - 8
        dot1.centerY = titleLabel.centerY
        dot1.right = titleLabel.left - 16 - 5 - 8 - 5 - 8
    }
    
    override func validateTimer() {
        animationTimer = Timer(timeInterval: animationTriggeredRate, target: self, selector: #selector(dotsRefreshAnimation), userInfo: nil, repeats: true)
        RunLoop.current.add(animationTimer!, forMode: RunLoop.Mode.common)
        animationTimer?.fire()
    }
    
    override func invalidateTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

extension LFCRefreshLoadingMoreDotsView {
    @objc private func dotsRefreshAnimation() {
        state = nextDotState(state: self.state)
    }
}

class LFCRefreshLoadingMoreDeafultView: LFCRefreshBaseView {
    
    var actionTextMap: [LFCRefreshLoadingViewStatus : String]?
    
    func updateLoadingInterface(for status: LFCRefreshLoadingViewStatus) {
        guard let text = actionTextMap?[status] as? String else {
            switch status {
            case .normal:
                titleLabel.text = "Drag to load more"
            case .canRefresh:
                titleLabel.text = "Release to begin loading"
            case .refreshing:
                titleLabel.text = "Loading ..."
            }
            return
        }
        titleLabel.text = text
    }
    
    /// 每次触发动画旋转的幅度， 默认为1/30
    var rotationAnglePerTriggered: CGFloat {
        return 1/15
    }
    
    /// 动画触发周期
    var animationTriggeredRate: CGFloat {
        return 1/60
    }
    
    var refreshSize: LFCRefreshIconSize = .medium {
        didSet {
            layoutSubviews()
        }
    }
    
    var refreshTintStyle: LFCRefreshTintStyle = .black {
        didSet {
            layoutSubviews()
        }
    }
    
    var loadingTitle: String?
    
    var notloadingTitle: String? {
        didSet {
            titleLabel.text = notloadingTitle
            updateLoadingStyle()
        }
    }
    
    /// 设置刷新中image
    var loadingImage: UIImage? {
        get {
            loadingImageView.image
        }
        set {
            loadingImageView.image = newValue
        }
    }
    
    // MARK: - Property
    var isLoading: Bool = false
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    /// 刷新中的图片
    fileprivate var loadingImageView: UIImageView = UIImageView()
    /// 刷新定时器
    fileprivate var timer: Timer?
    /// 角度
    private var angle: CGFloat = 0.0
    
    let containerView = UIView(frame: .zero)
    
    func startLoading() {
        isLoading = true
        titleLabel.text = loadingTitle
        validateTimer()
        updateLoadingStyle()
    }
    
    func stopLoading() {
        isLoading = false
        titleLabel.text = notloadingTitle
        loadingImageView.transform = .identity
        invalidateTimer()
        updateLoadingStyle()
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }

    // MARK: - Layout
    
    fileprivate func configUI() {
        addSubview(containerView)
        containerView.addSubview(loadingImageView)
        containerView.addSubview(titleLabel)
        titleLabel.text = notloadingTitle
        updateLoadingInterface(for: .normal)
        establishConstraints()
    }
    
    /// 布置约束
    private func establishConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Center containerView in the middle of its superview
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Pin loadingImageView to the left, top, and bottom of containerView
            loadingImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            loadingImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loadingImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Set titleLabel to the right of loadingImageView and center it vertically to loadingImageView
            titleLabel.leftAnchor.constraint(equalTo: loadingImageView.rightAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: loadingImageView.centerYAnchor),
            
            // Pin titleLabel to the right of containerView
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            // Ensure the containerView accommodates the size of loadingImageView and titleLabel
            containerView.rightAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor)
        ])
    }

    
    fileprivate func updateLoadingStyle() {
        let iconSize = refreshSize.size
        loadingImageView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        let style = refreshTintStyle
        titleLabel.textColor = style.mainColor
        titleLabel.font = refreshSize.font
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLoadingStyle()
    }
    
    // MARK: - Private - Timer
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func validateTimer() {
        invalidateTimer()
        timer = Timer(timeInterval: animationTriggeredRate, target: self, selector: #selector(loadingSel), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    @objc private func loadingSel() {
        angle += rotationAnglePerTriggered
        loadingImageView.transform = CGAffineTransform(rotationAngle: angle * CGFloat(Double.pi))
    }
}

