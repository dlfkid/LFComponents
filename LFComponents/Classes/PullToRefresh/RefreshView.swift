//
//  UIViewBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import UIKit

enum RefreshViewType {
    case refresh
    case loadMore
}

fileprivate extension RefreshViewType {
    var isRefresh: Bool  { return self == .refresh }
    var isLoadMore: Bool { return self == .loadMore }
}

class RefreshView: UIView {
    // MARK: - RefreshState
    
    private enum RefreshState {
        case normal
        case loading
        
        var isNormal: Bool  { return self == .normal }
        var isLoading: Bool { return self == .loading }
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let kDefaultRefreshContentOffset: CGFloat = 112.0
        
        static let kDefaultLoadMoreContentOffset: CGFloat = 32.0
        
        /// 监听的 keyPath
        static let kKPContentOffset: String = "contentOffset"
        static let kKPContentSize: String = "contentSize"
        
        /// keyPath 对应的Context
        static let kContextContentOffset = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)
        static let kContextContentSize = UnsafeMutableRawPointer.allocate(byteCount: 1, alignment: 1)
    }
    
    // MARK: - Property
    
    /// refresh type
    var type: RefreshViewType = .refresh
    
    /// call back target.selector
    weak var target: AnyObject?
    var selector: Selector?
    
    /// 刷新触发回调的最小偏移  默认 112.0
    var minContentOffsetForRefresh: CGFloat = Constants.kDefaultRefreshContentOffset
    
    /// 加载触发回调的最小偏移  默认 32.0
    var minContentOffsetForLoadMore: CGFloat = Constants.kDefaultLoadMoreContentOffset
    
    /// 刷新view
    var loadingView: RefreshBaseView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let view = loadingView else { return }
            addSubview(view)
        }
    }
    
    private var state: RefreshState = .normal
    private var preEdgeInsets: UIEdgeInsets = .zero
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
    
    // MARK: - Deinit
    #if DEBUG
    deinit {
        debugPrint("\(String.init(describing: self.classForCoder)) deinit")
    }
    #endif
    
    // MARK: - Public
    
    /// 开始加载
    func startLoading() {
        guard state.isNormal else { return }
        state = .loading
        loadingView?.startLoading()
    }
    
    /// 停止加载
    func stopLoading() {
        guard state.isLoading else { return }
        loadingView?.stopLoading()
        guard let scrollView = superview as? UIScrollView else {
            state = .normal
            return
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            scrollView.contentInset = self.preEdgeInsets
        } completion: { [weak self] (_) in
            self?.state = .normal
        }
    }
    
    /// 手动触发加载中
    func beginLoading() {
        guard state.isNormal else { return }
        guard let scrollView = superview as? UIScrollView else { return }
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let sself = self else { return }
            scrollView.adjustContentOffsetToTriggerRefresh(y: sself.minContentOffsetForRefresh)
        }
    }
    
    // MARK: - Layout
    
    private func configUI() {
        autoresizingMask = .flexibleWidth
    }

    // MARK: - Override
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObserves()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addObserves()
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let ccontext = context else { return }
        if ccontext == Constants.kContextContentOffset {
            contentOffsetDidChanged()
        } else if (ccontext == Constants.kContextContentSize) {
            contentSizeChanged()
        }
    }
}


// MARK: - Observe
fileprivate extension RefreshView {
    private func addObserves() {
        guard let scrollView = superview as? UIScrollView else { return }
        scrollView.addObserver(self,
                               forKeyPath: Constants.kKPContentOffset,
                               options: [.new, .old],
                               context: Constants.kContextContentOffset)
        guard type.isLoadMore else { return }
        scrollView.addObserver(self,
                               forKeyPath: Constants.kKPContentSize,
                               options: [.new, .old],
                               context: Constants.kContextContentSize)
    }
    
    private func removeObserves() {
        guard let scrollView = superview as? UIScrollView else { return }
        scrollView.removeObserver(self,
                                  forKeyPath: Constants.kKPContentOffset,
                                  context: Constants.kContextContentOffset)
        guard type.isLoadMore else { return }
        scrollView.removeObserver(self,
                                  forKeyPath: Constants.kKPContentSize,
                                  context: Constants.kContextContentSize)
    }
        
    private func contentOffsetDidChanged() {
        guard !isHidden,
            state.isNormal,
            let scrollView = superview as? UIScrollView,
            !scrollView.isDragging else { return }
        
        preEdgeInsets = scrollView.contentInset
        
        if type.isRefresh {
            var minLoadingOffset = -(minContentOffsetForRefresh + preEdgeInsets.top)
            minLoadingOffset -= scrollView.adjustTop
            if scrollView.contentOffset.y < minLoadingOffset {
                startLoading()
                var inset = preEdgeInsets
                inset.top = -minLoadingOffset - scrollView.adjustTop
                UIView.animate(withDuration: 0.2) {
                    scrollView.contentInset = inset
                }
                guard let sel = selector else { return }
                let _ = target?.perform(sel)
            }
        } else {
            let contentSizeAddInset = scrollView.contentSize.height + preEdgeInsets.bottom
            let adjustTop = contentSizeAddInset <= scrollView.height ? scrollView.adjustTop : 0.0
            let minLoadingOffset = max(contentSizeAddInset, scrollView.height) + minContentOffsetForLoadMore - scrollView.height - adjustTop
            if scrollView.contentOffset.y > minLoadingOffset {
                startLoading()
                var inset = preEdgeInsets
                if contentSizeAddInset < scrollView.height {
                    inset.bottom = 60.0 + scrollView.height - scrollView.contentSize.height - adjustTop
                } else {
                    inset.bottom = 60.0 + preEdgeInsets.bottom
                }
                UIView.animate(withDuration: 0.2) {
                    scrollView.contentInset = inset
                }
                guard let sel = selector else { return }
                let _ = target?.perform(sel)
            }
        }
    }
    
    private func contentSizeChanged() {
        guard type.isLoadMore, let scrollView = superview as? UIScrollView else { return }
        let inset = state.isLoading ? preEdgeInsets : scrollView.contentInset
        top = max(scrollView.contentSize.height + inset.bottom,
                  scrollView.height - scrollView.adjustTop)
    }
}

// MARK: - AdjustedContentInset
fileprivate extension UIScrollView {
    /// 获取 UIScrollView 的调整顶部范围
    var adjustTop: CGFloat {
        if #available(iOS 11.0, *) {
            // iOS11把安全区域放到adjustedContentInset内
            return adjustedContentInset.top
        }
        return 0.0
    }
}

