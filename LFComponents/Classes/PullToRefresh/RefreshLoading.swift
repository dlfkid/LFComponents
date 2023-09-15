//
//  UIViewBadgesExtension.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/7/29.
//

import Foundation
import UIKit

// MARK: - File Constants
fileprivate struct Constants {
    static let kRefreshAssociatedHeaderKey = UnsafeRawPointer(bitPattern: "k_RefreshAssociatedHeaderKey".hashValue)!
    static let kRefreshAssociatedFooterKey = UnsafeRawPointer(bitPattern: "k_RefreshAssociatedFooterKey".hashValue)!
    static let kLoadingViewHeight: CGFloat = 700.0
    static let kDefaultAnimationDuration = 0.25
    static let kDefaultLoadingContentOffset: CGFloat = 112.0
}

// MARK: - public protocol & enum

public protocol RefreshLoadingable {
    var isLoading: Bool { get }
    
    /// 触发刷新动作时 会调用此方法
    func startLoading()
    
    /// 停止刷新动作时 会调用此方法
    func stopLoading()
}

public extension RefreshLoadingable where Self : UIView {
    var isLoading: Bool { return false }
    func startLoading() { }
    func stopLoading() { }
}

/// 自定义view必须包含此继承链   例如 ：class: RefreshBaseView 、 class： UIControl, RefreshLoadingable
public typealias RefreshBaseView = UIView & RefreshLoadingable

/// header 刷新类型
public enum RefreshType {
    case circle
    case system
    case dots
}

extension RefreshType {
    private static let bundleName = "LFComponents.bundle"
    var imageBundleName: String {
        switch self {
        case .circle:
            return String("\(RefreshType.bundleName)/loading_ring")
        case .system:
            return String("\(RefreshType.bundleName)/loading_system")
        case .dots:
            return String("\(RefreshType.bundleName)/loading_dots")
        }
    }
}

/// 刷新主题颜色
public enum RefreshTintStyle {
    case black
    case blue
    case white
}

extension RefreshTintStyle {
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
            return UIColor.hexColor("#333333")
        case .blue:
            return UIColor.hexColor("#3355FF")
        case .white:
            return UIColor.white
        }
    }
    
    var sideColor: UIColor {
        switch self {
        case .black:
            return UIColor.hexColor("#E5E5E5")
        case .blue:
            return UIColor.hexColor("#E5E5E5")
        case .white:
            return UIColor.hexColor("#E5E5E5")
        }
    }
}

/// 刷新图标大小
public enum RefreshIconSize {
    case small
    case medium
    case large
    case custom(size: CGSize, font: UIFont)
}

extension RefreshIconSize {
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
public extension UIScrollView {
    /// 停止控件的刷新状态 header footer 都会停止
    func stopRefreshing() {
        stopHeaderRefreshing()
        stopFooterRefreshing()
    }
}

// MARK: - Refresh Header
public extension UIScrollView {
    // MARK: - Public
    
    /// 手动触发头部刷新
    func begingHeaderRefreshing() {
        if let refreshView = (refreshHeader as? RefreshView) {
            refreshView.beginLoading()
        }
    }
    
    /// 添加一个头部刷新控件
    /// - Parameter type: RefreshHeaderType
    /// - Parameter target: target.perform(sel: selector)
    /// - Parameter selector: selector
    @discardableResult
    func addRefreshHeader(type: RefreshType = .circle, style: RefreshTintStyle = .black, size: RefreshIconSize = .medium, text: String = "下拉刷新", refreshingText: String = "下拉刷新", target: AnyObject, selector: Selector) -> UIView? {
                
        guard isEnable(target: target, to: selector) else { return nil }
        guard let refreshView = headerLoadingView(type: type, style: style, size: size, text: text, refreshingText: refreshingText) else { return nil }
        return addRefreshHeader(loadingView: refreshView, target: target, selector: selector)
    }
    
    /// 添加一个自定义的头部刷新控件
    /// - Parameter loadingView: 必须 遵守 RefreshBaseView
    /// - Parameter target: target
    /// - Parameter selector: selector
    @discardableResult
    func addRefreshHeader(loadingView: RefreshBaseView, target: AnyObject, selector: Selector) -> UIView? {
        
        guard isEnable(target: target, to: selector) else { return nil }
        
        let loadingHeight = loadingView.height
        let refreshViewFrame = CGRect(x: 0.0, y: -loadingHeight, width: width, height: loadingHeight)
        let refreshView = RefreshView(frame: refreshViewFrame)
        refreshView.target = target
        refreshView.selector = selector
        refreshView.type = .refresh
        refreshView.loadingView = loadingView
        addRefreshHeader(refreshView)
        return refreshView
    }
    
    // MARK: - private property & func
    
    /// 获取关联的头部刷新控件
    private var refreshHeader: UIView? {
        get {
           objc_getAssociatedObject(self, Constants.kRefreshAssociatedHeaderKey) as? UIView
        }
        set {
           objc_setAssociatedObject(self, Constants.kRefreshAssociatedHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 停止 header 刷新
    private func stopHeaderRefreshing() {
        if let refreshView = (refreshHeader as? UIRefreshControl) {
            refreshView.endRefreshing()
        } else if let refreshView = (refreshHeader as? RefreshView) {
            refreshView.stopLoading()
        }
    }
    
    /// 获取刷新的基础 header view
    private func headerLoadingView(type: RefreshType, style: RefreshTintStyle, size: RefreshIconSize, text: String, refreshingText: String) -> RefreshBaseView? {
        let height = Constants.kLoadingViewHeight
        let refreshViewFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        var refreshView: RefreshLoadingDefaultView = RefreshLoadingCircleView(frame: refreshViewFrame)
        switch type {
        case .circle:
            break
        case .dots:
            refreshView = RefreshLoadingDotsView(frame: refreshViewFrame)
        case .system:
            refreshView = RefreshLoadingSystemView(frame: refreshViewFrame)
        }
        let imageName = String("\(type.imageBundleName)_\(style.colorName)")
        let bundle = Bundle(for: RefreshLoadingCircleView.self)
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) ?? UIImage()
        refreshView.loadingImage = image.resizeImage(toSize: size.size)
        refreshView.loadingTitle = refreshingText
        refreshView.notloadingTitle = text
        refreshView.refreshSize = size
        refreshView.refreshTintStyle = style
        return refreshView
    }
    
    /// 添加刷新控件
    private func addRefreshHeader(_ refreshView: UIView) {
        refreshHeader?.removeFromSuperview()
        addSubview(refreshView)
        refreshHeader = refreshView
    }
}

// MARK: - Refresh Footer
public extension UIScrollView {
    // MARK: - Public
    
    /// 设置底部刷新控件隐藏状态
    var isRefreshFooterHidden: Bool {
        get {
            refreshFooter?.isHidden ?? true
        }
        set {
            refreshFooter?.isHidden = newValue
        }
    }
    
    /// 添加一个底部刷新控件
    /// - Parameter type: 默认 文字  菊花图
    /// - Parameter target: target
    /// - Parameter selector: selector
    @discardableResult
    func addRefreshFooter(type: RefreshType = .circle, style: RefreshTintStyle = .black, size: RefreshIconSize = .medium, text: String = "上拉加载更多", refreshingText: String = "正在加载更多", target: AnyObject, selector: Selector) -> UIView? {

        guard isEnable(target: target, to: selector) else { return nil }
        
        guard let loadingView = footerLoadingView(type: type, style: style, size: size, text: text, refreshingText: refreshingText) else { return nil }
        return addRefreshFooter(loadingView: loadingView, target: target, selector: selector)
    }
    
    /// 添加一个自定义的底部刷新控件
    /// - Parameter loadingView: loadingView description
    /// - Parameter target: target description
    /// - Parameter selector: selector description
    private func addRefreshFooter(loadingView: RefreshBaseView, target: AnyObject, selector: Selector) -> UIView? {
        
        guard isEnable(target: target, to: selector) else { return nil }
        
        let refreshViewY: CGFloat = max(contentSize.height, height)
        let refreshFrame = CGRect(x: 0.0, y: refreshViewY, width: width, height: loadingView.height)
        let refreshView = RefreshView(frame: refreshFrame)
        refreshView.target = target
        refreshView.selector = selector
        refreshView.type = .loadMore
        refreshView.loadingView = loadingView
        addRefreshFooter(refreshView)
        return refreshView
    }
    
    // MARK: - Private Property & Func
    
    /// 获取当前UIScrollView添加的底部刷新控件
    private var refreshFooter: UIView? {
        get {
            objc_getAssociatedObject(self, Constants.kRefreshAssociatedFooterKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, Constants.kRefreshAssociatedFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 获取刷新的基础 footer view
    private func footerLoadingView(type: RefreshType, style: RefreshTintStyle = .black, size: RefreshIconSize, text: String, refreshingText: String) -> RefreshBaseView? {
        let loadingHeight = Constants.kLoadingViewHeight
        let loadingFrame = CGRect(x: 0.0, y: 0.0, width: width, height: loadingHeight)
        var refreshView: RefreshLoadingMoreDeafultView = RefreshLoadingMoreCircleView(frame: loadingFrame)
        switch type {
        case .circle:
            refreshView = RefreshLoadingMoreCircleView(frame: loadingFrame)
        case .dots:
            refreshView = RefreshLoadingMoreDotsView(frame: loadingFrame)
        case .system:
            refreshView = RefreshLoadingMoreSystemView(frame: loadingFrame)
        }
        let imageName = String("\(type.imageBundleName)_\(style.colorName)")
        let bundle = Bundle(for: RefreshLoadingCircleView.self)
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) ?? UIImage()
        refreshView.loadingImage = image.resizeImage(toSize: size.size)
        refreshView.loadingTitle = refreshingText
        refreshView.notloadingTitle = text
        refreshView.refreshTintStyle = style
        refreshView.refreshSize = size
        return refreshView
    }
    
    /// 停止 footer 刷新
    private func stopFooterRefreshing() {
        (refreshFooter as? RefreshView)?.stopLoading()
    }
    
    /// 添加 footer 刷新控件
    private func addRefreshFooter(_ refreshView: UIView) {
        refreshFooter?.removeFromSuperview()
        addSubview(refreshView)
        refreshFooter = refreshView
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
}

extension UIScrollView {
    internal func adjustContentOffsetToTriggerRefresh(y: CGFloat = 60.0) {
        UIView.animate(withDuration: Constants.kDefaultAnimationDuration) { [weak self] in
            guard let sself = self else { return }
            sself.setContentOffset(.init(x: sself.contentOffset.x, y: -y - sself.contentInset.top - 1.0), animated: false)
        }
    }
}

extension UIColor {
    fileprivate static func hexColor(_ withHexString: String) -> UIColor {
        var cString:String = withHexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }

            if ((cString.count) != 6) {
                return UIColor.gray
            }

            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
    }
}
