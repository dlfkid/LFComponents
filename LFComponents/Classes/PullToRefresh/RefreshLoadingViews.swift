//
//  UIViewBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation
import UIKit

enum RefreshLoadingDotState {
    case dot1On
    case dot2On
    case dot3On
}

protocol RefreshDotAnimatable {
    var state: RefreshLoadingDotState {get set}
}

extension RefreshDotAnimatable {
    func nextDotState(state: RefreshLoadingDotState) -> RefreshLoadingDotState {
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

class RefreshLoadingCircleView: RefreshLoadingDefaultView {
    override func configUI() {
        super.configUI()
    }
}

class RefreshLoadingSystemView: RefreshLoadingDefaultView {
    override func configUI() {
        super.configUI()
    }
}

class RefreshLoadingDotsView: RefreshLoadingDefaultView, RefreshDotAnimatable {
    
    internal var state: RefreshLoadingDotState = .dot1On {
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
    
    override func layoutContent() {
        super.layoutContent()
        dot3.centerY = titleLabel.centerY
        dot3.right = titleLabel.left - 16
        dot2.centerY = titleLabel.centerY
        dot2.right = titleLabel.left - 16 - 5 - 8
        dot1.centerY = titleLabel.centerY
        dot1.right = titleLabel.left - 16 - 5 - 8 - 5 - 8
    }
    
    override func validateTimer() {
        animationTimer = Timer(timeInterval: 0.25, target: self, selector: #selector(dotsRefreshAnimation), userInfo: nil, repeats: true)
        RunLoop.current.add(animationTimer!, forMode: .commonModes)
        animationTimer?.fire()
    }
    
    override func invalidateTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

extension RefreshLoadingDotsView {
    @objc private func dotsRefreshAnimation() {
        state = nextDotState(state: self.state)
    }
}


class RefreshLoadingDefaultView: RefreshBaseView {
    var refreshSize: RefreshIconSize = .medium
    
    var refreshTintStyle: RefreshTintStyle = .black
    
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
    
    var loadingTitle: String?
    
    var notloadingTitle: String? {
        didSet {
            titleLabel.text = notloadingTitle
            layoutContent()
        }
    }

    /// 刷新中的图片
    fileprivate var loadingImageView: UIImageView = UIImageView()
    /// 刷新定时器
    fileprivate var displayLink: CADisplayLink?
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
        titleLabel.text = loadingTitle
        layoutContent()
    }
    
    func stopLoading() {
        isLoading = false
        invalidateTimer()
        loadingImageView.transform = .identity
        titleLabel.text = notloadingTitle
        layoutContent()
    }
    
    // MARK: - Layout
    
    fileprivate func configUI() {
        autoresizingMask = .flexibleWidth
        addSubview(containerView)
        containerView.addSubview(loadingImageView)
        containerView.addSubview(titleLabel)
        titleLabel.text = notloadingTitle
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutContent()
    }
    
    fileprivate func layoutContent() {
        let iconSize = refreshSize.size
        loadingImageView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        let style = refreshTintStyle
        titleLabel.textColor = style.mainColor
        titleLabel.font = refreshSize.font
        titleLabel.sizeToFit()
        let height = max(loadingImageView.height, titleLabel.height)
        let width = (loadingImageView.width + titleLabel.width + 8)
        containerView.frame = CGRectMake(0, 0, width, height)
        containerView.center = center
        containerView.centerY = centerY - 20
        loadingImageView.centerY = containerView.centerY
        titleLabel.centerY = loadingImageView.centerY
        loadingImageView.left = 0
        titleLabel.left = loadingImageView.width + 10
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard nil == newSuperview else { return }
        invalidateTimer()
    }
    
    // MARK: - Private - Timer
    
    fileprivate func invalidateTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    fileprivate func validateTimer() {
        invalidateTimer()
        displayLink = CADisplayLink.init(target: self, selector: #selector(loadingSel))
        displayLink?.add(to: .main, forMode: RunLoopMode.commonModes)
    }
    
    @objc private func loadingSel() {
        angle += 0.3
        loadingImageView.transform = .makeRotation(angle: angle)
    }
}

class RefreshLoadingMoreCircleView: RefreshLoadingMoreDeafultView {
    override func configUI() {
        super.configUI()
        let name = "loading_ring_black"
        guard let image = UIImage(named: "LFComponents.bundle/\(name)", in: Bundle(for: RefreshLoadingMoreCircleView.self), compatibleWith: nil) else {
            return
        }
        loadingImage = image
    }
}

class RefreshLoadingMoreSystemView: RefreshLoadingMoreDeafultView {
    override func configUI() {
        super.configUI()
        let name = "loading_system_black"
        guard let image = UIImage(named: "LFComponents.bundle/\(name)", in: Bundle(for: RefreshLoadingMoreCircleView.self), compatibleWith: nil) else {
            return
        }
        loadingImage = image
    }
}

class RefreshLoadingMoreDotsView: RefreshLoadingMoreDeafultView, RefreshDotAnimatable {
    
    internal var state: RefreshLoadingDotState = .dot1On {
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
    
    override func updateViewsFrame() {
        super.updateViewsFrame()
        dot3.centerY = titleLabel.centerY
        dot3.right = titleLabel.left - 16
        dot2.centerY = titleLabel.centerY
        dot2.right = titleLabel.left - 16 - 5 - 8
        dot1.centerY = titleLabel.centerY
        dot1.right = titleLabel.left - 16 - 5 - 8 - 5 - 8
    }
    
    override func validateTimer() {
        animationTimer = Timer(timeInterval: 0.25, target: self, selector: #selector(dotsRefreshAnimation), userInfo: nil, repeats: true)
        RunLoop.current.add(animationTimer!, forMode: .commonModes)
        animationTimer?.fire()
    }
    
    override func invalidateTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

extension RefreshLoadingMoreDotsView {
    @objc private func dotsRefreshAnimation() {
        state = nextDotState(state: self.state)
    }
}

class RefreshLoadingMoreDeafultView: RefreshBaseView {
    
    var refreshSize: RefreshIconSize = .medium
    
    var refreshTintStyle: RefreshTintStyle = .black
    
    var loadingTitle: String?
    
    var notloadingTitle: String? {
        didSet {
            titleLabel.text = notloadingTitle
            updateViewsFrame()
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
    fileprivate var displayLink: CADisplayLink?
    /// 角度
    private var angle: CGFloat = 0.0
    
    let containerView = UIView(frame: .zero)
    
    func startLoading() {
        isLoading = true
        titleLabel.text = loadingTitle
        validateTimer()
        updateViewsFrame()
    }
    
    func stopLoading() {
        isLoading = false
        titleLabel.text = notloadingTitle
        loadingImageView.transform = .identity
        invalidateTimer()
        updateViewsFrame()
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
        autoresizingMask = .flexibleWidth
        addSubview(containerView)
        containerView.addSubview(loadingImageView)
        containerView.addSubview(titleLabel)
        titleLabel.text = notloadingTitle
    }
    
    fileprivate func updateViewsFrame() {
        let iconSize = refreshSize.size
        loadingImageView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        let style = refreshTintStyle
        titleLabel.textColor = style.mainColor
        titleLabel.font = refreshSize.font
        titleLabel.sizeToFit()
        let height = max(loadingImageView.height, titleLabel.height)
        let width = (loadingImageView.width + titleLabel.width + 8)
        containerView.frame = CGRectMake(0, 0, width, height)
        containerView.centerX = centerX
        containerView.centerY = 30
        loadingImageView.centerY = containerView.centerY
        titleLabel.centerY = loadingImageView.centerY
        loadingImageView.left = 0
        titleLabel.left = loadingImageView.width + 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViewsFrame()
    }
    
    // MARK: - Private - Timer
    
    fileprivate func invalidateTimer() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    fileprivate func validateTimer() {
        invalidateTimer()
        displayLink = CADisplayLink.init(target: self, selector: #selector(loadingSel))
        displayLink?.add(to: .main, forMode: RunLoopMode.commonModes)
    }
    
    @objc private func loadingSel() {
        angle += 0.3
        loadingImageView.transform = .makeRotation(angle: angle)
    }
}

//MARK: - CGAffineTransform
fileprivate extension CGAffineTransform {
    static func makeRotation(angle: CGFloat) -> CGAffineTransform {
        return __CGAffineTransformMake(cos(angle), sin(angle), -sin(angle), cos(angle), 0, 0)
    }
    
    static func makeTranslation(tx: CGFloat, ty: CGFloat) -> CGAffineTransform {
        return __CGAffineTransformMake(1, 0, 0, 1, tx, ty)
    }
    
    static func makeScale(sx: CGFloat, sy: CGFloat) -> CGAffineTransform {
        return __CGAffineTransformMake(sx, 0, 0, sy, 0, 0)
    }
}

