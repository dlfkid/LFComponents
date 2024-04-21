//
//  RefreshViewController.swift
//  ExampleDevDemo
//
//  Created by Ravendeng on 2023/1/5.
//

import UIKit

enum LFCRefreshViewType {
    case refresh
    case loadMore
}

fileprivate extension LFCRefreshViewType {
    var isRefresh: Bool  { return self == .refresh }
    var isLoadMore: Bool { return self == .loadMore }
}

// MARK: - RefreshState

public enum RefreshState {
    case normal
    case loading
    case noMoreData
    
    var isNormal: Bool  { return self == .normal }
    var isLoading: Bool { return self == .loading }
}

typealias RefreshStatusClosure = (RefreshState, UIEdgeInsets) -> Void

class LFCRefreshView: UIView {
    
    // MARK: - Constants
    
    private struct Constants {
        static let kDefaultRefreshContentOffset: CGFloat = 68.0
        
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
    var type: LFCRefreshViewType = .refresh
    
    /// call back target.selector
    weak var target: AnyObject?
    var selector: Selector?
    
    /// 刷新触发回调的最小偏移  默认 112.0
    var minContentOffsetForRefresh: CGFloat = Constants.kDefaultRefreshContentOffset
    
    /// 加载触发回调的最小偏移  默认 32.0
    var minContentOffsetForLoadMore: CGFloat = Constants.kDefaultLoadMoreContentOffset
    
    /// 刷新view
    var loadingView: LFCRefreshBaseView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let view = loadingView else { return }
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: centerXAnchor),
                view.centerYAnchor.constraint(equalTo: centerYAnchor),
                view.heightAnchor.constraint(equalTo: heightAnchor),
                view.widthAnchor.constraint(equalTo: widthAnchor),
            ])
        }
    }
    
    public var stateChangeHandler: RefreshStatusClosure?
    
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
        loadingView?.updateLoadingInterface(for: .refreshing)
    }
    
    /// 停止加载
    func stopLoading() {
        guard state.isLoading else { return }
        loadingView?.stopLoading()
        loadingView?.updateLoadingInterface(for: .normal)
        guard let scrollView = superview as? UIScrollView else {
            if let handler = stateChangeHandler {
                handler(state, preEdgeInsets)
            }
            state = .normal
            return
        }
        if let handler = self.stateChangeHandler, type.isRefresh {
            handler(self.state, preEdgeInsets)
            self.state = .normal
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.2, animations: {
                let contentOffset = scrollView.contentOffset
                scrollView.contentInset = self.preEdgeInsets
                if self.type == .loadMore, scrollView.height - (self.loadingView?.height ?? 0) < scrollView.contentSize.height {
                    scrollView.setContentOffset(contentOffset, animated: false)
                }
            })
        }
        self.state = .normal
    }
    
    // 没有更多数据
    func noMoreData() {
        guard state.isLoading else { return }
        loadingView?.stopLoading()
        guard superview is UIScrollView else {
            if let handler = stateChangeHandler {
                handler(state, preEdgeInsets)
            }
            state = .noMoreData
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.state = .noMoreData
            if let handler = self.stateChangeHandler {
                handler(self.state, self.preEdgeInsets)
            }
        }
    }
    
    /// 退出没有更多数据状态
    func exitNoMoreData() {
        if type == .loadMore, state == .noMoreData {
            self.state = .normal
            guard let scrollView = superview as? UIScrollView else { return }
            if let handler = self.stateChangeHandler {
                handler(self.state, scrollView.contentInset)
            }
        }
    }
    
    /// 手动触发加载中
    func beginLoading() {
        guard state.isNormal else { return }
        guard let scrollView = superview as? UIScrollView else { return }
        scrollView.adjustContentOffsetToTriggerRefresh(y: self.minContentOffsetForRefresh)
    }
    
    // MARK: - Layout
    
    private func configUI() {
        autoresizingMask = .flexibleWidth
        loadingView?.updateLoadingInterface(for: .normal)
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
fileprivate extension LFCRefreshView {
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
    
    /// 根据拖动距离更新refreshView的UI
    private func updateLoadingViewInterface() {
        guard let scrollView = superview as? UIScrollView else { return }
        if type.isRefresh {
            var minLoadingOffset = -(minContentOffsetForRefresh + preEdgeInsets.top)
            minLoadingOffset -= scrollView.adjustTop
            if scrollView.contentOffset.y < minLoadingOffset {
                loadingView?.updateLoadingInterface(for: .canRefresh)
            } else {
                loadingView?.updateLoadingInterface(for: .normal)
            }
        } else {
            let loadingViewHeight = loadingView?.height ?? 0
            let contentSizeAddInset = scrollView.contentSize.height + preEdgeInsets.bottom
            let adjustTop = contentSizeAddInset <= scrollView.height ? scrollView.adjustTop : 0.0
            let minLoadingOffset = max(contentSizeAddInset, scrollView.height) + minContentOffsetForLoadMore - scrollView.height - adjustTop + loadingViewHeight
            if scrollView.contentOffset.y > minLoadingOffset {
                loadingView?.updateLoadingInterface(for: .canRefresh)
            } else {
                loadingView?.updateLoadingInterface(for: .normal)
            }
        }
    }
        
    private func contentOffsetDidChanged() {
        guard !isHidden,
            state.isNormal,
            let scrollView = superview as? UIScrollView else { return }
        
        if type == .loadMore, state == .noMoreData {
            return
        }
        
        guard !scrollView.isDragging else {
            // 未释放前只更新文案
            updateLoadingViewInterface()
            return
        }
        
        if scrollView.contentOffset.y == 0 {
            preEdgeInsets = scrollView.contentInset
        }
        
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    let _ = self.target?.perform(sel)
                }
            }
        } else {
            let loadingViewHeight = loadingView?.height ?? 0
            let contentSizeAddInset = scrollView.contentSize.height + preEdgeInsets.bottom
            let adjustTop = contentSizeAddInset <= scrollView.height ? scrollView.adjustTop : 0.0
            let minLoadingOffset = max(contentSizeAddInset, scrollView.height) + minContentOffsetForLoadMore - scrollView.height - adjustTop + loadingViewHeight
            if scrollView.contentOffset.y > minLoadingOffset {
                startLoading()
                var inset = preEdgeInsets
                let refreshViewOffset = loadingViewHeight
                if contentSizeAddInset < scrollView.height {
                    inset.bottom = refreshViewOffset + scrollView.height - scrollView.contentSize.height - adjustTop
                } else {
                    inset.bottom = refreshViewOffset + preEdgeInsets.bottom
                }
                UIView.animate(withDuration: 0.2) {
                    scrollView.contentInset = inset
                }
                guard let sel = selector else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    let _ = self.target?.perform(sel)
                }
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

