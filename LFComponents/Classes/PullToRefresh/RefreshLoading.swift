//
//  RefreshViewController.swift
//  ExampleDevDemo
//
//  Created by Ravendeng on 2023/1/5.
//

import Foundation
import UIKit

extension UIScrollView: LFCWrapperable {}

// MARK: - File Constants
fileprivate struct LFCRefreshConstants {
    static let kRefreshAssociatedHeaderKey = UnsafeRawPointer(bitPattern: "k_RefreshAssociatedHeaderKey".hashValue)!
    static let kRefreshAssociatedFooterKey = UnsafeRawPointer(bitPattern: "k_RefreshAssociatedFooterKey".hashValue)!
    static let kHeadAssociatedStatusViewKey = UnsafeRawPointer(bitPattern: "k_HeadAssociatedStatusViewKey".hashValue)!
    static let kFootAssociatedStatusViewKey = UnsafeRawPointer(bitPattern: "k_FootAssociatedStatusViewKey".hashValue)!
    static let kDefaultAnimationDuration = 0.25
}

// MARK: - public protocol & enum

/// 加载View的状态
public enum LFCRefreshLoadingViewStatus {
    /// 正常状态
    case normal
    /// 拖拽到可以释放刷新的状态
    case canRefresh
    /// 刷新中的状态
    case refreshing
}

public protocol LFCRefreshLoadingable {
    var isLoading: Bool { get }
    
    /// 触发刷新动作时 会调用此方法
    func startLoading()
    
    /// 停止刷新动作时 会调用此方法
    func stopLoading()
    
    /// loadingView处于某状态时更新UI
    /// - Parameter status: 状态
    func updateLoadingInterface(for status: LFCRefreshLoadingViewStatus)
    
    /// 不同刷新动作对应的文案
    var actionTextMap:[LFCRefreshLoadingViewStatus: String]? {get set}
}

public protocol LFCRefreshStatable {
    /// 消息状态展示闭包, 调用方返回字符串, 由信息View决定如何展示这个字符串
    typealias LFCRefreshStateClosure = (UIView) -> String
    
    /// 开始展示的回调闭包, 由组件调用
    var stateShowHandler: LFCRefreshStateClosure? {get set}
    
    /// 结束展示的回调闭包, 由组件调用
    var stateDismissHandler: LFCRefreshStateClosure? {get set}
    
    /// 开始展示状态, 由组件调用
    func startShowingState(_ preEdgeInset: UIEdgeInsets)
    
    /// 终止展示状态, 由组件调用
    func stopShowingState(_ preEdgeInset: UIEdgeInsets)
}

public extension LFCRefreshLoadingable where Self : UIView {
    var isLoading: Bool { return false }
    func startLoading() { }
    func stopLoading() { }
}

/// 自定义view必须包含此继承链   例如 ：class: RefreshBaseView 、 class： UIControl, RefreshLoadingable
public typealias LFCRefreshBaseView = UIView & LFCRefreshLoadingable

public typealias LFCRefreshStateView = UIView & LFCRefreshStatable

/// header 刷新类型
public enum LFCRefreshType {
    case circle
    case system
    case dots
}

extension LFCRefreshType {
    private static let bundleName = "LFComponents.bundle"
    var imageBundleName: String {
        switch self {
        case .circle:
            return String("\(LFCRefreshType.bundleName)/loading_ring")
        case .system:
            return String("\(LFCRefreshType.bundleName)/loading_system")
        case .dots:
            return String("\(LFCRefreshType.bundleName)/loading_dots")
        }
    }
}

/// 刷新主题颜色
public enum LFCRefreshTintStyle {
    case black
    case blue
    case white
}

extension LFCRefreshTintStyle {
    var colorName: String {
        switch self {
        case .black:
            return "black"
        case .blue:
            return "blue"
        case .white:
            return "white"
        }
    }
    
    var mainColor: UIColor {
        switch self {
        case .black:
            return UIColor.lfc.hex("#333333")
        case .blue:
            return UIColor.lfc.hex("#3355FF")
        case .white:
            return UIColor.white
        }
    }
    
    var sideColor: UIColor {
        switch self {
        case .black:
            return UIColor.lfc.hex("#E5E5E5")
        case .blue:
            return UIColor.lfc.hex("#E5E5E5")
        case .white:
            return UIColor.lfc.hex("#E5E5E5")
        }
    }
}

/// 刷新图标大小
public enum LFCRefreshIconSize {
    case small
    case medium
    case large
    case custom(size: CGSize, font: UIFont)
}

extension LFCRefreshIconSize {
    var size: CGSize {
        switch self {
        case .small:
            return CGSize(width: 16, height: 16)
        case .medium:
            return CGSize(width: 20, height: 20)
        case .large:
            return CGSize(width: 28, height: 28)
        case .custom(let size, _):
            return size
        }
    }
    
    var font: UIFont {
        switch self {
        case .small:
            return UIFont.systemFont(ofSize: 12)
        case .medium:
            return UIFont.systemFont(ofSize: 14)
        case .large:
            return UIFont.systemFont(ofSize: 16)
        case .custom(_, let font):
            return font
        }
    }
}


// MARK: - stop loading

public extension LFCWrapper where T: UIScrollView {
    
    /// 停止 header 刷新
    func stopHeaderRefreshing() {
        if let refreshView = (value.refreshHeader as? UIRefreshControl) {
            refreshView.endRefreshing()
        } else if let refreshView = (value.refreshHeader as? LFCRefreshView) {
            refreshView.stopLoading()
        }
    }
    
    /// 停止 footer 刷新
    func stopFooterRefreshing() {
        (value.refreshFooter as? LFCRefreshView)?.stopLoading()
    }
    
    /// 停止 footer刷新并且展示没有更多View
    func stopFooterRefreshingAndNoMoreData() {
        if let refreshView = (value.refreshFooter as? LFCRefreshView) {
            refreshView.noMoreData()
        }
    }
    
    /// 停止控件的刷新状态 header footer 都会停止
    func stopRefreshing() {
        stopHeaderRefreshing()
        stopFooterRefreshing()
    }
}


// MARK: - Refresh Header

public extension LFCWrapper where T: UIScrollView {
    // MARK: - Public
    
    /// 手动触发头部刷新
    func begingHeaderRefreshing() {
        UIView.animate(withDuration: 0.25) {
            value.contentOffset.y = 0
        } completion: { ret in
            if let refreshView = (value.refreshHeader as? LFCRefreshView) {
                refreshView.beginLoading()
            }
        }
    }
    

    @discardableResult
    /// 添加头部刷新控件
    /// - Parameters:
    ///   - type: 类型, 默认有圆圈, 点和菊花
    ///   - style: 刷新UI样式, 三种颜色
    ///   - size: 大小, 三种默认大小
    ///   - actionTextMap: 刷新操作处于不同状态的文案
    ///   - target: 触发刷新时接收消息的对象
    ///   - selector: 触发刷新时发送的消息
    /// - Returns: 刷新View
    func addRefreshHeader(type: LFCRefreshType = .circle, style: LFCRefreshTintStyle = .black, size: LFCRefreshIconSize = .medium, actionTextMap:[LFCRefreshLoadingViewStatus: String]? = nil, target: AnyObject, selector: Selector) -> UIView? {
                
        guard value.isEnable(target: target, to: selector) else { return nil }
        guard let refreshView = headerLoadingView(type: type, style: style, size: size, actionTextMap: actionTextMap) else { return nil }
        return addLoadingViewForHeader(loadingView: refreshView, target: target, selector: selector)
    }
    
    /// 默认添加头部刷新信息控件
    /// - Parameters:
    ///   - interval: 展示时长
    ///   - showClosure: 展示闭包
    ///   - dismissClosure: 消失闭包
    func addBaseHeaderStater(interval: TimeInterval = 0.5, showClosure: LFCRefreshStatable.LFCRefreshStateClosure?, dismissClosure: LFCRefreshStatable.LFCRefreshStateClosure?, autoTrack: Bool = false) {
        let baseHeader = LFCBaseHeadStateView()
        baseHeader.stateShowHandler = { view in
            self.value.refreshHeader?.isHidden = true
            if let showClosure = showClosure {
                return showClosure(view)
            }
            return ""
        }
        baseHeader.stateDismissHandler = { view in
            self.value.refreshHeader?.isHidden = false
            if let showClosure = showClosure {
                return showClosure(view)
            }
            return ""
        }
        addHeaderStater(baseHeader, autoTrack: autoTrack)
    }
    
    /// 添加刷新信息展示控件
    /// - Parameter stateView: 信息View
    func addHeaderStater(_ stateView: LFCRefreshStateView = LFCBaseHeadStateView(), interval: TimeInterval = 0.5, contentHeight: CGFloat = 68, autoTrack: Bool = false) {
        let container = LFCRefreshStateContainerView(frame: .zero, stateView: stateView, type: .refresh, contentHeight: contentHeight, interval: interval)
        container.autoTrackWhenLoadMore = autoTrack
        attachHeadStatusView(container)
    }
    
    /// 添加一个自定义的头部刷新控件
    /// - Parameter loadingView: 必须 遵守 RefreshBaseView
    /// - Parameter target: target
    /// - Parameter selector: selector
    @discardableResult
    func addLoadingViewForHeader(loadingView: LFCRefreshBaseView, target: AnyObject, selector: Selector) -> UIView? {
        guard value.isEnable(target: target, to: selector) else { return nil }
        let loadingHeight = loadingView.height
        let refreshViewFrame = CGRect(x: 0.0, y: -loadingHeight, width: value.width, height: loadingHeight)
        let refreshView = LFCRefreshView(frame: refreshViewFrame)
        refreshView.target = target
        refreshView.selector = selector
        refreshView.type = .refresh
        refreshView.loadingView = loadingView
        refreshView.stateChangeHandler = { state, preEdgeInset in
            switch state {
            case .normal:
                break
            case .loading:
                // 如果在没有更多数据状态, 要先退出
                if let refreshFooter = self.value.refreshFooter as? LFCRefreshView {
                    refreshFooter.exitNoMoreData()
                }
                self.value.headStatusView?.startShowingState(preEdgeInset)
            case .noMoreData:
                break
            }
        }
        attachRefreshHeader(refreshView)
        return refreshView
    }
    
    /// 默认添加头部刷新信息控件
    /// - Parameters:
    ///   - interval: 展示时长
    ///   - showClosure: 展示闭包
    ///   - dismissClosure: 消失闭包
    func addBaseFooterStater(interval: TimeInterval = CGFloat.greatestFiniteMagnitude, showClosure: LFCRefreshStatable.LFCRefreshStateClosure?, dismissClosure: LFCRefreshStatable.LFCRefreshStateClosure?, autoTrack: Bool = false) {
        let baseFooter = LFCBaseFootStateView()
        baseFooter.stateShowHandler = { view in
            self.value.refreshFooter?.isHidden = true
            if let showClosure = showClosure {
                return showClosure(view)
            }
            return ""
        }
        baseFooter.stateDismissHandler = { view in
            self.value.refreshFooter?.isHidden = false
            if let showClosure = showClosure {
                return showClosure(view)
            }
            return ""
        }
        addFooterStater(baseFooter, autoTrack: autoTrack)
    }
    
    /// 添加加载更多信息展示控件
    /// - Parameter stateView: 信息展示View
    func addFooterStater(_ stateView: LFCRefreshStateView = LFCBaseFootStateView(), interval: TimeInterval = CGFloat.greatestFiniteMagnitude, contentHeight: CGFloat = 68.0, autoTrack: Bool = false) {
        let container = LFCRefreshStateContainerView(frame: .zero, stateView: stateView, type: .loadMore, contentHeight: contentHeight, interval: interval)
        container.autoTrackWhenLoadMore = autoTrack
        attachFootStatusView(container)
    }
    
    // MARK: - private property & func
    
    /// 获取刷新的基础 header view
    private func headerLoadingView(type: LFCRefreshType, style: LFCRefreshTintStyle, size: LFCRefreshIconSize, actionTextMap:[LFCRefreshLoadingViewStatus: String]?) -> LFCRefreshBaseView? {
        let height = 68.0
        let refreshViewFrame = CGRect(x: 0.0, y: 0.0, width: value.width, height: height)
        var refreshView: LFCRefreshLoadingDefaultView = LFCRefreshLoadingCircleView(frame: refreshViewFrame)
        switch type {
        case .circle:
            break
        case .dots:
            refreshView = LFCRefreshLoadingDotsView(frame: refreshViewFrame)
        case .system:
            refreshView = LFCRefreshLoadingSystemView(frame: refreshViewFrame)
        }
        let imageName = String("\(type.imageBundleName)_\(style.colorName)")
        let bundle = Bundle(for: LFCRefreshLoadingCircleView.self)
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) ?? UIImage()
        refreshView.loadingImage = image.lfc.resized(newSize: size.size)
        refreshView.refreshSize = size
        refreshView.refreshTintStyle = style
        refreshView.actionTextMap = actionTextMap
        return refreshView
    }
    
    /// 添加刷新控件
    private func attachRefreshHeader(_ refreshView: UIView) {
        value.refreshHeader?.removeFromSuperview()
        value.addSubview(refreshView)
        value.refreshHeader = refreshView
    }
    
    /// 添加顶部信息控件
    /// - Parameter headStatusView: 信息控件
    private func attachHeadStatusView(_ headStatusView: LFCRefreshStateView) {
        value.headStatusView?.removeFromSuperview()
        value.addSubview(headStatusView)
        value.headStatusView = headStatusView
    }
}


// MARK: - Refresh Footer

public extension LFCWrapper where T: UIScrollView {
    // MARK: - Public
    
    /// 添加头部刷新控件
    /// - Parameters:
    ///   - type: 类型, 默认有圆圈, 点和菊花
    ///   - style: 刷新UI样式, 三种颜色
    ///   - size: 大小, 三种默认大小
    ///   - actionTextMap: 刷新操作处于不同状态的文案
    ///   - target: 触发刷新时接收消息的对象
    ///   - selector: 触发刷新时发送的消息
    /// - Returns: 刷新View
    @discardableResult
    func addRefreshFooter(type: LFCRefreshType = .circle, style: LFCRefreshTintStyle = .black, size: LFCRefreshIconSize = .medium, actionTextMap:[LFCRefreshLoadingViewStatus: String]? = nil, target: AnyObject, selector: Selector) -> UIView? {

        guard value.isEnable(target: target, to: selector) else { return nil }
        
        guard let loadingView = footerLoadingView(type: type, style: style, size: size, actionTextMap: actionTextMap) else { return nil }
        return addLoadingViewForFooter(loadingView: loadingView, target: target, selector: selector)
    }
    
    /// 添加一个自定义的底部刷新控件
    /// - Parameter loadingView: loadingView description
    /// - Parameter target: target description
    /// - Parameter selector: selector description
    private func addLoadingViewForFooter(loadingView: LFCRefreshBaseView, target: AnyObject, selector: Selector) -> UIView? {
        
        guard value.isEnable(target: target, to: selector) else { return nil }
        
        let refreshViewY: CGFloat = max(value.contentSize.height, value.height)
        let refreshFrame = CGRect(x: 0.0, y: refreshViewY, width: value.width, height: loadingView.height)
        let refreshView = LFCRefreshView(frame: refreshFrame)
        refreshView.target = target
        refreshView.selector = selector
        refreshView.type = .loadMore
        refreshView.loadingView = loadingView
        refreshView.stateChangeHandler = { state, preEdgeInset in
            switch state {
            case .normal:
                self.value.footStatusView?.stopShowingState(preEdgeInset)
            case .loading:
                break
            case .noMoreData:
                self.value.footStatusView?.startShowingState(preEdgeInset)
            }
        }
        attachRefreshFooter(refreshView)
        return refreshView
    }
    
    // MARK: - Private Property & Func
    
    /// 获取刷新的基础 footer view
    private func footerLoadingView(type: LFCRefreshType, style: LFCRefreshTintStyle = .black, size: LFCRefreshIconSize, actionTextMap:[LFCRefreshLoadingViewStatus: String]?) -> LFCRefreshBaseView? {
        let loadingHeight = 68.0
        let loadingFrame = CGRect(x: 0.0, y: 0.0, width: value.width, height: loadingHeight)
        var refreshView: LFCRefreshLoadingMoreDeafultView = LFCRefreshLoadingMoreCircleView(frame: loadingFrame)
        switch type {
        case .circle:
            refreshView = LFCRefreshLoadingMoreCircleView(frame: loadingFrame)
        case .dots:
            refreshView = LFCRefreshLoadingMoreDotsView(frame: loadingFrame)
        case .system:
            refreshView = LFCRefreshLoadingMoreSystemView(frame: loadingFrame)
        }
        let imageName = String("\(type.imageBundleName)_\(style.colorName)")
        let bundle = Bundle(for: LFCRefreshLoadingCircleView.self)
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) ?? UIImage()
        refreshView.loadingImage = image.lfc.resized(newSize: size.size)
        refreshView.refreshTintStyle = style
        refreshView.refreshSize = size
        refreshView.actionTextMap = actionTextMap
        return refreshView
    }
    
    /// 添加 footer 刷新控件
    private func attachRefreshFooter(_ refreshView: UIView) {
        value.refreshFooter?.removeFromSuperview()
        value.addSubview(refreshView)
        value.refreshFooter = refreshView
    }
    
    /// 添加底部信息控件
    /// - Parameter footStatusView: 底部信息控件
    private func attachFootStatusView(_ footStatusView: LFCRefreshStateView) {
        value.footStatusView?.removeFromSuperview()
        value.addSubview(footStatusView)
        value.footStatusView = footStatusView
    }
}

// MARK: - Help
fileprivate extension UIScrollView {
    func isEnable(target: AnyObject, to selector: Selector) -> Bool {
        guard !target.responds(to: selector) else { return true }
        #if DEBUG
        assert(false, "Assert  Target(\(target) can not respondsToSelector Selector(\(selector))")
        #endif
        return false
    }
    
    /// 获取关联的头部刷新控件
    var refreshHeader: UIView? {
        get {
           objc_getAssociatedObject(self, LFCRefreshConstants.kRefreshAssociatedHeaderKey) as? UIView
        }
        set {
           objc_setAssociatedObject(self, LFCRefreshConstants.kRefreshAssociatedHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 顶部信息栏
    var headStatusView: LFCRefreshStateView? {
        get {
            objc_getAssociatedObject(self, LFCRefreshConstants.kHeadAssociatedStatusViewKey) as? LFCRefreshStateView
        }
        set {
            objc_setAssociatedObject(self, LFCRefreshConstants.kHeadAssociatedStatusViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 获取当前UIScrollView添加的底部刷新控件
    var refreshFooter: UIView? {
        get {
            objc_getAssociatedObject(self, LFCRefreshConstants.kRefreshAssociatedFooterKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, LFCRefreshConstants.kRefreshAssociatedFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 底部信息栏
    var footStatusView: LFCRefreshStateView? {
        get {
            objc_getAssociatedObject(self, LFCRefreshConstants.kFootAssociatedStatusViewKey) as? LFCRefreshStateView
        }
        set {
            objc_setAssociatedObject(self, LFCRefreshConstants.kFootAssociatedStatusViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension UIScrollView {
    internal func adjustContentOffsetToTriggerRefresh(y: CGFloat = 60.0) {
        UIView.animate(withDuration: LFCRefreshConstants.kDefaultAnimationDuration) { [weak self] in
            guard let sself = self else { return }
            sself.setContentOffset(.init(x: sself.contentOffset.x, y: -y - sself.contentInset.top - 1.0), animated: false)
        }
    }
}
