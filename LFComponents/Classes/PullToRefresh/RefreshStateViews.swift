//
//  LFCRefreshStateViews.swift
//  Example
//
//  Created by Ravendeng on 2024/4/3.
//

import Foundation

public class LFCRefreshStateContainerView: LFCRefreshStateView {
    public var stateDismissHandler: LFCRefreshStateClosure?
    
    public var stateShowHandler: LFCRefreshStateClosure?
    
    /// 上拉加载后是否自动滚动到底部
    public var autoTrackWhenLoadMore: Bool = false
    
    private let stateView: LFCRefreshStateView
    
    private var type: LFCRefreshViewType
    
    private let contentHeight: CGFloat
    
    private var preEdgeInset: UIEdgeInsets = .zero
    
    private let interval: TimeInterval
    
    private var scrollView: UIScrollView? {
        guard let scrollView = superview as? UIScrollView else {
            return nil
        }
        return scrollView
    }
    
    init(frame: CGRect, stateView: LFCRefreshStateView, type: LFCRefreshViewType, contentHeight: CGFloat, interval: TimeInterval) {
        self.stateView = stateView
        self.type = type
        self.contentHeight = contentHeight
        self.interval = interval
        super.init(frame: frame)
        addSubview(stateView)
        stateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stateView.leftAnchor.constraint(equalTo: leftAnchor),
            stateView.topAnchor.constraint(equalTo: topAnchor),
            stateView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            stateView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        ])
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startShowingState(_ preEdgeInset: UIEdgeInsets) {
        self.preEdgeInset = preEdgeInset
        internalStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.stopShowingState(preEdgeInset)
        }
    }
    
    /// 是否要展示在contentSize底部
    private var shouldDisplayExtend: Bool {
        guard let scrollView = superview as? UIScrollView else {
            return false
        }
        // contentSize大于scrollView减自身展示高度的高度
        return scrollView.contentSize.height > scrollView.height - contentHeight
    }
    
    private func internalStart() {
        guard let scrollView = scrollView else {
            return
        }
        var topPosition: CGFloat = 0
        switch type {
        case .refresh:
            frame = scrollView.bounds
            height = contentHeight
            topPosition = -contentHeight
        case .loadMore:
            frame = scrollView.bounds
            height = contentHeight
            if shouldDisplayExtend {
                topPosition = scrollView.contentSize.height
            } else {
                topPosition = scrollView.height
            }
        }
        top = topPosition
        isHidden = false
        self.stateView.startShowingState(preEdgeInset)
        switch self.type {
            case .refresh:
                scrollView.setContentOffset(CGPoint(x: 0, y: -self.contentHeight), animated: false)
            case .loadMore:
                if self.shouldDisplayExtend {
                    if self.autoTrackWhenLoadMore {
                        let position = scrollView.contentSize.height - scrollView.height + self.contentHeight
                        scrollView.setContentOffset(CGPoint(x: 0, y: position), animated: true)
                    }
                }
        }
    }
    
    public func stopShowingState(_ preEdgeInset: UIEdgeInsets) {
        UIView.animate(withDuration: 0.25) {
            self.scrollView?.contentInset = preEdgeInset
        } completion: { _ in
            self.isHidden = true
            self.stateView.stopShowingState(preEdgeInset)
        }
    }
}

/// 顶部默认信息栏
public class LFCBaseHeadStateView: LFCRefreshStateView {
    
    public var stateDismissHandler: LFCRefreshStateClosure?
    
    
    public var stateShowHandler: LFCRefreshStateClosure?
    
    public func startShowingState(_ preEdgeInset: UIEdgeInsets) {
        titlelLabel.text = "Refresh complete"
        if let handler = stateShowHandler {
            let text = handler(self)
            titlelLabel.text = text
        }
    }
    
    public func stopShowingState(_ preEdgeInset: UIEdgeInsets) {
        if let handler = stateDismissHandler {
            let text = handler(self)
            titlelLabel.text = text
        }
    }
    
    private lazy var titlelLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lfc.hex(0x333333)
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titlelLabel)
        backgroundColor = .clear
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titlelLabel.sizeToFit()
        titlelLabel.center = center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

/// 底部默认信息栏
public class LFCBaseFootStateView: LFCRefreshStateView {
    
    public var stateDismissHandler: LFCRefreshStateClosure?
    
    
    public var stateShowHandler: LFCRefreshStateClosure?
    
    public func startShowingState(_ preEdgeInset: UIEdgeInsets) {
        titlelLabel.text = "No more data"
        if let handler = stateShowHandler {
            let text = handler(self)
            titlelLabel.text = text
        }
    }
    
    public func stopShowingState(_ preEdgeInset: UIEdgeInsets) {
        if let handler = stateDismissHandler {
            let text = handler(self)
            titlelLabel.text = text
        }
    }
    
    private lazy var titlelLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lfc.hex(0x999999)
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titlelLabel)
        backgroundColor = .clear
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titlelLabel.sizeToFit()
        titlelLabel.center = center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
