//
//  LFDraggable.swift
//  ExampleDemo
//
//  Created by Ravendeng on 2024/10/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public typealias LFDragViewClosure = (UIView?, CGPoint) -> Void

public enum LFDragDirection: Int{
    case any = 0
    case horizontal
    case vertical
}

extension UIView: LFCWrapperable {
    
}

public extension LFCWrapper where T: UIView {
    /// make view draggable
    func makeDraggable() {
        self.value.lfc_addDragGesture()
    }
    
    /// set an auto half shrink interval
    /// - Parameter interval: interval
    func makeHalfShink(interval: TimeInterval) {
        self.value.lfc_makeHalfShink(interval: interval)
    }
    
    func awakeFromShrink() {
        /// call out the view from shrink status
        self.value.lfc_awakeFromShrink()
    }
    
    /// draggable direction of the view
    var draggableDirection: LFDragDirection {
        get {
            return self.value.lfc_draggableDirection
        }
        set {
            self.value.lfc_draggableDirection = newValue
        }
    }
    
    /// drag action start handler
    var onDragStart: LFDragViewClosure? {
        get {
            return self.value.lfc_dragStartHandler
        }
        set {
            self.value.lfc_dragStartHandler = newValue
        }
    }
    
    /// dragging handler
    var onDragging: LFDragViewClosure? {
        get {
            return self.value.lfc_draggingHandler
        }
        set {
            self.value.lfc_draggingHandler = newValue
        }
    }
    
    /// drag end handler
    var onDragEnd: LFDragViewClosure? {
        get {
            return self.value.lfc_dragEndHandler
        }
        set {
            self.value.lfc_dragEndHandler = newValue
        }
    }
    
    /// if the view can be dragged
    var dragEnable: Bool {
        get {
            return self.value.lfc_dragEnable
        }
        set {
            self.value.lfc_dragEnable = newValue
        }
    }
    
    /// if the view keep bounds
    var isKeepBounds: Bool {
        get {
            return self.value.lfc_isKeepBounds
        }
        set {
            self.value.lfc_isKeepBounds = newValue
        }
    }
    
    /// current shrink status of the view
    /// - Returns: DraggableEdgeType
    func shrinkEdgeType() -> DraggableEdgeType {
        return self.value.isOnEdge()
    }
}

protocol LFDraggable: UIView {
    
    var lfc_draggableDirection: LFDragDirection {get set}
    
    var lfc_dragStartHandler: LFDragViewClosure? {get set}
    
    var lfc_draggingHandler: LFDragViewClosure? {get set}
    
    var lfc_dragEndHandler: LFDragViewClosure? {get set}
    
    var lfc_dragEnable: Bool {get set}
    
    var lfc_freeRect: CGRect {get set}
    
    var lfc_isKeepBounds: Bool {get set}
}


// Extension to add a dynamic property 'name' to UIView using associated objects
private var lfc_draggableDirectionKey: UInt8 = 0
private var lfc_dragStartHandlerKey: UInt8 = 0
private var lfc_draggingHandlerKey: UInt8 = 0
private var lfc_dragEndHandlerKey: UInt8 = 0
private var lfc_dragEnableKey: UInt8 = 0
private var lfc_freeRectKey: UInt8 = 0
private var lfc_isKeepBoundsKey: UInt8 = 0
private var lfc_startPointKey: UInt8 = 0
private var lfc_animationTimeKey: UInt8 = 0
private var lfc_halfShrinkIntervalKey: UInt8 = 0
private var lfc_halfShrinkCurrentTickKey: UInt8 = 0
private var lfc_halfShrinkTimerKey: UInt8 = 0
private var lfc_halfShrinkStatusKey: UInt8 = 0
private var lfc_isDraggingKey: UInt8 = 0

extension UIView: LFDraggable {
    
    var lfc_draggableDirection: LFDragDirection {
        get {
            objc_getAssociatedObject(self, &lfc_draggableDirectionKey) as? LFDragDirection ?? .any
        }
        set {
            objc_setAssociatedObject(self, &lfc_draggableDirectionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lfc_dragStartHandler: LFDragViewClosure? {
        get {
            objc_getAssociatedObject(self, &lfc_dragStartHandlerKey) as? LFDragViewClosure
        }
        set {
            objc_setAssociatedObject(self, &lfc_dragStartHandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var lfc_draggingHandler: LFDragViewClosure? {
        get {
            objc_getAssociatedObject(self, &lfc_draggingHandlerKey) as? LFDragViewClosure
        }
        set {
            objc_setAssociatedObject(self, &lfc_draggingHandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var lfc_dragEndHandler: LFDragViewClosure? {
        get {
            objc_getAssociatedObject(self, &lfc_dragEndHandlerKey) as? LFDragViewClosure
        }
        set {
            objc_setAssociatedObject(self, &lfc_dragEndHandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var lfc_dragEnable: Bool {
        get {
            objc_getAssociatedObject(self, &lfc_dragEnableKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &lfc_dragEnableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lfc_freeRect: CGRect {
        get {
            objc_getAssociatedObject(self, &lfc_freeRectKey) as? CGRect ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &lfc_freeRectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lfc_isKeepBounds: Bool {
        get {
            objc_getAssociatedObject(self, &lfc_isKeepBoundsKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &lfc_isKeepBoundsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lfc_startPoint: CGPoint {
        get {
            objc_getAssociatedObject(self, &lfc_startPointKey) as? CGPoint ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &lfc_startPointKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 动画时长
    var lfc_animationTime: TimeInterval {
        get {
            objc_getAssociatedObject(self, &lfc_animationTimeKey) as? TimeInterval ?? 0.25
        }
        set {
            objc_setAssociatedObject(self, &lfc_animationTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lfc_halfShrinkInterval: TimeInterval {
        get {
            objc_getAssociatedObject(self, &lfc_halfShrinkIntervalKey) as? TimeInterval ?? 0
        }
        set {
            objc_setAssociatedObject(self, &lfc_halfShrinkIntervalKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lfc_halfShrinkCurrentTick: TimeInterval {
        get {
            objc_getAssociatedObject(self, &lfc_halfShrinkCurrentTickKey) as? TimeInterval ?? 0
        }
        set {
            objc_setAssociatedObject(self, &lfc_halfShrinkCurrentTickKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var lfc_halfShrinkTimer: Timer? {
        get {
            objc_getAssociatedObject(self, &lfc_halfShrinkTimerKey) as? Timer
        }
        set {
            objc_setAssociatedObject(self, &lfc_halfShrinkTimerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var lfc_isDragging: Bool {
        get {
            objc_getAssociatedObject(self, &lfc_isDraggingKey) as? Bool ?? false
        } set {
            objc_setAssociatedObject(self, &lfc_isDraggingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var lfc_halfShrinkStatus: DraggableEdgeType {
        get {
            objc_getAssociatedObject(self, &lfc_halfShrinkStatusKey) as? DraggableEdgeType ?? .none
        } set {
            objc_setAssociatedObject(self, &lfc_halfShrinkStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Add draGestrue
    fileprivate func lfc_addDragGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragAction(pan:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    fileprivate func lfc_makeHalfShink(interval: TimeInterval) {
        guard interval > 0 else {
            return
        }
        lfc_halfShrinkInterval = interval
        lfc_halfShrinkCurrentTick = lfc_halfShrinkInterval
        if let timer = lfc_halfShrinkTimer {
            timer.invalidate()
            lfc_halfShrinkTimer = nil
        }
        lfc_halfShrinkTimer = Timer(timeInterval: 1, repeats: true, block: { [weak self] timer in
            // check if the view should shink if it's in the edge of the superview
            guard let self = self else {
                return
            }
            guard !self.lfc_isDragging else {
                // quit when the view is beening dragged
                return
            }
            guard self.lfc_halfShrinkStatus == .none else {
                // quit when the view is already in shrink status
                return
            }
            if lfc_freeRect == .zero {
                if let superview = self.superview {
                    self.lfc_freeRect = CGRect.init(origin: .zero, size: superview.bounds.size)
                } else {
                    self.lfc_freeRect = CGRectMake(0, 0, UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                }
            }
            guard self.lfc_halfShrinkCurrentTick <= 0 else {
                self.lfc_halfShrinkCurrentTick -= 1
                return
            }
            let edgeType = self.isOnEdge()
            var rect = self.frame
            switch edgeType {
            case .none:
                break
            case .top:
                let topOffSet = CGRectGetHeight(self.frame) / 2
                UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.y -= topOffSet
                self.frame = rect
                UIView.commitAnimations()
            case .left:
                let leftOffSet = CGRectGetWidth(self.frame) / 2
                UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x -= leftOffSet
                self.frame = rect
                UIView.commitAnimations()
                
            case .bottom:
                let bottomOffSet = CGRectGetHeight(self.frame) / 2
                UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.y += bottomOffSet
                self.frame = rect
                UIView.commitAnimations()
            case .right:
                let rightOffset = CGRectGetWidth(self.frame) / 2
                UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x += rightOffset
                self.frame = rect
                UIView.commitAnimations()
            }
            self.lfc_halfShrinkStatus = edgeType
        })
        if let timer = lfc_halfShrinkTimer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
}

public enum DraggableEdgeType {
    case none
    case top
    case left
    case bottom
    case right
    
    var moveAnimationName: String {
        switch self {
        case .none:
            return ""
        case .top:
            return "topMove"
        case .left:
            return "leftMove"
        case .bottom:
            return "bottomMove"
        case .right:
            return "rightMove"
        }
    }
}

extension UIView {
    
    fileprivate func isOnEdge() -> DraggableEdgeType {
        let freeRect = self.lfc_freeRect
        let frame = self.frame
        guard freeRect.width - CGRectGetMaxX(frame) > 1 else {
            return .right
        }
        guard CGRectGetMinX(frame) > 1 else {
            return .left
        }
        guard freeRect.height - CGRectGetMaxY(frame) > 1 else {
            return .bottom
        }
        guard CGRectGetMinY(frame) > 1 else {
            return .top
        }
        return .none
    }
    
    /// 拖动事件
    @objc func dragAction(pan: UIPanGestureRecognizer){
        if lfc_dragEnable == false {
            return
        }
        
        if lfc_freeRect == .zero {
            if let superview = self.superview {
                lfc_freeRect = CGRect.init(origin: .zero, size: superview.bounds.size)
            } else {
                lfc_freeRect = CGRectMake(0, 0, UIScreen.main.bounds.width, UIScreen.main.bounds.height)
            }
        }
        
        switch pan.state {
        case .began:
            lfc_isDragging = true
            lfc_halfShrinkStatus = .none
            lfc_dragStartHandler?(self, center)
            lfc_halfShrinkCurrentTick = lfc_halfShrinkInterval
            // 注意完成移动后，将translation重置为0十分重要。否则translation每次都会叠加
            pan.setTranslation(CGPoint.zero, in: self)
            // 保存触摸起始点位置
            lfc_startPoint = pan.translation(in: self)
        case .changed:
            
            lfc_draggingHandler?(self, center)
            // 计算位移 = 当前位置 - 起始位置
            
            let point: CGPoint = pan.translation(in: self)
            var dx: CGFloat = 0.0
            var dy: CGFloat = 0.0
            switch lfc_draggableDirection {
            case .any:
                dx = point.x - lfc_startPoint.x
                dy = point.y - lfc_startPoint.y
            case .horizontal:
                dx = point.x - lfc_startPoint.x
                dy = 0
            case .vertical:
                dx = 0
                dy = point.y - lfc_startPoint.y
            }
            
            // 计算移动后的view中心点
            let newCenter: CGPoint = CGPoint.init(x: center.x + dx, y: center.y + dy)
            // 移动view
            center = newCenter
            // 注意完成上述移动后，将translation重置为0十分重要。否则translation每次都会叠加
            pan.setTranslation(CGPoint.zero, in: self)
            
        case .ended:
            keepBounds()
            lfc_isDragging = false
            lfc_dragEndHandler?(self, center)
        default:
            break
        }
        
    }
    
    /// call out the view from shrink status
    fileprivate func lfc_awakeFromShrink() {
        var rect = self.frame
        let edgeType = lfc_halfShrinkStatus
        switch edgeType {
        case .none:
            break
        case .top:
            let topOffSet = CGRectGetHeight(self.frame) / 2
            UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.y += topOffSet
            self.frame = rect
            UIView.commitAnimations()
        case .left:
            let leftOffSet = CGRectGetWidth(self.frame) / 2
            UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.x += leftOffSet
            self.frame = rect
            UIView.commitAnimations()
            
        case .bottom:
            let bottomOffSet = CGRectGetHeight(self.frame) / 2
            UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.y -= bottomOffSet
            self.frame = rect
            UIView.commitAnimations()
        case .right:
            let rightOffset = CGRectGetWidth(self.frame) / 2
            UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.x -= rightOffset
            self.frame = rect
            UIView.commitAnimations()
        }
        lfc_halfShrinkStatus = .none
        lfc_halfShrinkCurrentTick = lfc_halfShrinkInterval
    }
    
    /// 黏贴边界效果
    private func keepBounds() {
        //中心点判断
        let centerX: CGFloat = lfc_freeRect.origin.x + (lfc_freeRect.size.width - frame.size.width)*0.5
        var rect: CGRect = self.frame
        if lfc_isKeepBounds == false {//没有黏贴边界的效果
            if frame.origin.x < lfc_freeRect.origin.x {
                UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x
                self.frame = rect
                UIView.commitAnimations()
            }else if lfc_freeRect.origin.x + lfc_freeRect.size.width < frame.origin.x + frame.size.width{
                UIView.beginAnimations(DraggableEdgeType.right.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x + lfc_freeRect.size.width - frame.size.width
                self.frame = rect
                UIView.commitAnimations()
            }

        } else if lfc_isKeepBounds == true{//自动粘边
            if frame.origin.x < centerX {
                
                UIView.beginAnimations(DraggableEdgeType.left.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x
                self.frame = rect
                UIView.commitAnimations()
            }else{
                UIView.beginAnimations(DraggableEdgeType.right.moveAnimationName, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x + lfc_freeRect.size.width - frame.size.width
                self.frame = rect
                UIView.commitAnimations()
            }
        }
        
        if frame.origin.y < lfc_freeRect.origin.y {
            UIView.beginAnimations(DraggableEdgeType.top.moveAnimationName, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.y = lfc_freeRect.origin.y
            self.frame = rect
            UIView.commitAnimations()
        }else if lfc_freeRect.origin.y + lfc_freeRect.size.height <  frame.origin.y + frame.size.height {
            UIView.beginAnimations(DraggableEdgeType.bottom.moveAnimationName, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.y = lfc_freeRect.origin.y + lfc_freeRect.size.height - frame.size.height
            self.frame = rect
            UIView.commitAnimations()
        }
    }
}
