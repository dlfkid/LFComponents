//
//  UIViewBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation
import UIKit

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

class RefreshLoadingDotsView: RefreshLoadingDefaultView {
    override func configUI() {
        super.configUI()
    }
    
    override func validateTimer() {
    }
}


class RefreshLoadingDefaultView: RefreshBaseView {
    // MARK: - Property
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private let containerView = UIView(frame: .zero)
    
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
    private var loadingImageView: UIImageView = UIImageView()
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
    
    private func layoutContent() {
        loadingImageView.sizeToFit()
        titleLabel.sizeToFit()
        let height = max(loadingImageView.height, titleLabel.height)
        let width = (loadingImageView.width + titleLabel.width + 8)
        containerView.frame = CGRectMake(0, 0, width, height)
        containerView.center = center
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
    
    private func invalidateTimer() {
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

class RefreshLoadingMoreDotsView: RefreshLoadingMoreDeafultView {
    override func configUI() {
        super.configUI()
    }
    
    override func validateTimer() {
    }
}

class RefreshLoadingMoreDeafultView: RefreshBaseView {
    
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
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    /// 刷新中的图片
    private var loadingImageView: UIImageView = UIImageView()
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
    
    private func updateViewsFrame() {
        loadingImageView.sizeToFit()
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
    
    private func invalidateTimer() {
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

