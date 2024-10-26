//
//  LFDragView.swift
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
        self.value.addDragGesture()
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
    
    /// click action handler of the draggableView
    var didClickHandler: LFDragViewClosure? {
        get {
            return self.value.lfc_didClickHandler
        }
        set {
            self.value.lfc_didClickHandler = newValue
        }
    }
    
    /// drag action start handler
    var dragStartHandler: LFDragViewClosure? {
        get {
            return self.value.lfc_dragStartHandler
        }
        set {
            self.value.lfc_dragStartHandler = newValue
        }
    }
    
    /// dragging handler
    var draggingHandler: LFDragViewClosure? {
        get {
            return self.value.lfc_draggingHandler
        }
        set {
            self.value.lfc_draggingHandler = newValue
        }
    }
    
    /// drag end handler
    var dragEndHandler: LFDragViewClosure? {
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
    
    /// the free rect of the view
    var freeRect: CGRect {
        get {
            return self.value.lfc_freeRect
        }
        set {
            self.value.lfc_freeRect = newValue
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
}

protocol LFDraggable: UIView {
    
    var lfc_draggableDirection: LFDragDirection {get set}
    
    var lfc_didClickHandler: LFDragViewClosure? {get set}
    
    var lfc_dragStartHandler: LFDragViewClosure? {get set}
    
    var lfc_draggingHandler: LFDragViewClosure? {get set}
    
    var lfc_dragEndHandler: LFDragViewClosure? {get set}
    
    var lfc_dragEnable: Bool {get set}
    
    var lfc_freeRect: CGRect {get set}
    
    var lfc_isKeepBounds: Bool {get set}
}


// Extension to add a dynamic property 'name' to UIView using associated objects
private var lfc_draggableDirectionKey: UInt8 = 0
private var lfc_didClickHandlerKey: UInt8 = 0
private var lfc_dragStartHandlerKey: UInt8 = 0
private var lfc_draggingHandlerKey: UInt8 = 0
private var lfc_dragEndHandlerKey: UInt8 = 0
private var lfc_dragEnableKey: UInt8 = 0
private var lfc_freeRectKey: UInt8 = 0
private var lfc_isKeepBoundsKey: UInt8 = 0
private var lfc_startPointKey: UInt8 = 0
private var lfc_animationTimeKey: UInt8 = 0
private let leftMove: String = "leftMove"
private let rightMove: String = "rightMove"

extension UIView: LFDraggable {
    
    var lfc_draggableDirection: LFDragDirection {
        get {
            objc_getAssociatedObject(self, &lfc_draggableDirectionKey) as? LFDragDirection ?? .any
        }
        set {
            objc_setAssociatedObject(self, &lfc_draggableDirectionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lfc_didClickHandler: LFDragViewClosure? {
        get {
            objc_getAssociatedObject(self, &lfc_didClickHandlerKey) as? LFDragViewClosure
        }
        set {
            objc_setAssociatedObject(self, &lfc_didClickHandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
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
    
    /// Add draGestrue
    fileprivate func addDragGesture() {
        self.clipsToBounds = true
        
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(clickDragView(tap:)))
        self.addGestureRecognizer(singleTap)
        
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragAction(pan:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGestureRecognizer)
    }
}

extension UIView {
    
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
            
            lfc_dragStartHandler?(self, center)
            
            // 注意完成移动后，将translation重置为0十分重要。否则translation每次都会叠加
            pan.setTranslation(CGPoint.zero, in: self)
            // 保存触摸起始点位置
            lfc_startPoint = pan.translation(in: self)
        case .changed:
            
            lfc_draggingHandler?(self, center)
            // 计算位移 = 当前位置 - 起始位置
            
            // 禁止拖动到父类之外区域
//            if (frame.origin.x < 0 || frame.origin.x > lfc_freeRect.size.width - frame.size.width || frame.origin.y < 0 || frame.origin.y > lfc_freeRect.size.height - frame.size.height){
//                var newframe: CGRect = self.frame
//                if frame.origin.x < 0 {
//                    newframe.origin.x = 0
//                }else if frame.origin.x > lfc_freeRect.size.width - frame.size.width {
//                    newframe.origin.x = lfc_freeRect.size.width - frame.size.width
//                }
//                if frame.origin.y < 0 {
//                    newframe.origin.y = 0
//                }else if frame.origin.y > lfc_freeRect.size.height - frame.size.height{
//                    newframe.origin.y = lfc_freeRect.size.height - frame.size.height
//                }
//                
//                UIView.animate(withDuration: lfc_animationTime) {
//                    self.frame = newframe
//                }
//                return
//            }
            
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
            lfc_dragEndHandler?(self, center)
        default:
            break
        }
        
    }
    
    @objc func clickDragView(tap: UITapGestureRecognizer) {
        lfc_didClickHandler?(self, tap.location(in: self))
    }
    
    /// 黏贴边界效果
    private func keepBounds() {
        //中心点判断
        let centerX: CGFloat = lfc_freeRect.origin.x + (lfc_freeRect.size.width - frame.size.width)*0.5
        var rect: CGRect = self.frame
        if lfc_isKeepBounds == false {//没有黏贴边界的效果
            if frame.origin.x < lfc_freeRect.origin.x {
                UIView.beginAnimations(leftMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x
                self.frame = rect
                UIView.commitAnimations()
            }else if lfc_freeRect.origin.x + lfc_freeRect.size.width < frame.origin.x + frame.size.width{
                UIView.beginAnimations(rightMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x + lfc_freeRect.size.width - frame.size.width
                self.frame = rect
                UIView.commitAnimations()
            }

        } else if lfc_isKeepBounds == true{//自动粘边
            if frame.origin.x < centerX {
                
                UIView.beginAnimations(leftMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x
                self.frame = rect
                UIView.commitAnimations()
            }else{
                
                UIView.beginAnimations(rightMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(lfc_animationTime)
                rect.origin.x = lfc_freeRect.origin.x + lfc_freeRect.size.width - frame.size.width
                self.frame = rect
                UIView.commitAnimations()
            }
        }
        
        if frame.origin.y < lfc_freeRect.origin.y {
            UIView.beginAnimations("topMove", context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.y = lfc_freeRect.origin.y
            self.frame = rect
            UIView.commitAnimations()
        }else if lfc_freeRect.origin.y + lfc_freeRect.size.height <  frame.origin.y + frame.size.height {
            UIView.beginAnimations("bottomMove", context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(lfc_animationTime)
            rect.origin.y = lfc_freeRect.origin.y + lfc_freeRect.size.height - frame.size.height
            self.frame = rect
            UIView.commitAnimations()
        }
    }
}
