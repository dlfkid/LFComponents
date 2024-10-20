//
//  LFDragView.swift
//  ExampleDemo
//
//  Created by Ravendeng on 2024/10/19.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

extension LFCWrapper where T: LFDraggable {
    /// 允许控件拖动
    public func makeDraggable() {
        self.value.addDragGesture()
    }
}

public enum LFDragDirection: Int{
    case any = 0
    case horizontal
    case vertical
}

public protocol LFDraggable: UIView {
    
    typealias LFDragViewClosure = (UIView, CGPoint) -> Void
    
    var draggableDirection: LFDragDirection {get}
    
    var didClickHandler: LFDragViewClosure? {get}
    
    var dragStartHandler: LFDragViewClosure? {get}
    
    var draggingHandler: LFDragViewClosure? {get}
    
    var dragEndHandler: LFDragViewClosure? {get}
    
    var dragEnable: Bool {get}
    
    var freeRect: CGRect {get}
    
    var isKeepBounds: Bool {get}
    
    /// 添加拖动手势
    func addDragGesture()
}

public class SFDragView: UIView, LFDraggable {
    
    public var draggableDirection: LFDragDirection = .any
    
    public var draggingHandler: LFDragViewClosure?
    
    public var didClickHandler: LFDragViewClosure?
    
    public var dragStartHandler: LFDragViewClosure?
    
    public var dragEndHandler: LFDragViewClosure?
    
    public var dragEnable: Bool = true
    
    public var freeRect: CGRect = CGRect.zero
    
    public var isKeepBounds: Bool = true
    
    private var startPoint: CGPoint = .zero
    
    private var leftMove: String = "leftMove"
    
    private var rightMove: String = "rightMove"
    
    /// 动画时长
    private var animationTime: TimeInterval = 0.5
    
    public func addDragGesture() {
        lfc_addDragGesture()
    }
    
    /// Add draGestrue
    fileprivate func lfc_addDragGesture() {
        self.clipsToBounds = true
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(clickDragView))
        self.addGestureRecognizer(singleTap)
        
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragAction(pan:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    /// 拖动事件
    @objc func dragAction(pan: UIPanGestureRecognizer){
        if dragEnable == false {
            return
        }
        
        switch pan.state {
        case .began:
            
            dragStartHandler?(self, center)
            
            // 注意完成移动后，将translation重置为0十分重要。否则translation每次都会叠加
            pan.setTranslation(CGPoint.zero, in: self)
            // 保存触摸起始点位置
            startPoint = pan.translation(in: self)
        case .changed:
            
            draggingHandler?(self, center)
            // 计算位移 = 当前位置 - 起始位置
            
            // 禁止拖动到父类之外区域
            if (frame.origin.x < 0 || frame.origin.x > freeRect.size.width - frame.size.width || frame.origin.y < 0 || frame.origin.y > freeRect.size.height - frame.size.height){
                var newframe: CGRect = self.frame
                if frame.origin.x < 0 {
                    newframe.origin.x = 0
                }else if frame.origin.x > freeRect.size.width - frame.size.width {
                    newframe.origin.x = freeRect.size.width - frame.size.width
                }
                if frame.origin.y < 0 {
                    newframe.origin.y = 0
                }else if frame.origin.y > freeRect.size.height - frame.size.height{
                    newframe.origin.y = freeRect.size.height - frame.size.height
                }
                
                UIView.animate(withDuration: animationTime) {
                    self.frame = newframe
                }
                return
            }
            
            let point: CGPoint = pan.translation(in: self)
            var dx: CGFloat = 0.0
            var dy: CGFloat = 0.0
            switch draggableDirection {
            case .any:
                dx = point.x - startPoint.x
                dy = point.y - startPoint.y
            case .horizontal:
                dx = point.x - startPoint.x
                dy = 0
            case .vertical:
                dx = 0
                dy = point.y - startPoint.y
            }
            
            // 计算移动后的view中心点
            let newCenter: CGPoint = CGPoint.init(x: center.x + dx, y: center.y + dy)
            // 移动view
            center = newCenter
            // 注意完成上述移动后，将translation重置为0十分重要。否则translation每次都会叠加
            pan.setTranslation(CGPoint.zero, in: self)
            
        case .ended:
            keepBounds()
            dragEndHandler?(self, center)
        default:
            break
        }
        
    }
    
    @objc func clickDragView() {
        
    }
    
    /// 黏贴边界效果
    private func keepBounds() {
        //中心点判断
        let centerX: CGFloat = freeRect.origin.x + (freeRect.size.width - frame.size.width)*0.5
        var rect: CGRect = self.frame
        if isKeepBounds == false {//没有黏贴边界的效果
            if frame.origin.x < freeRect.origin.x {
                UIView.beginAnimations(leftMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(animationTime)
                rect.origin.x = freeRect.origin.x
                self.frame = rect
                UIView.commitAnimations()
            }else if freeRect.origin.x + freeRect.size.width < frame.origin.x + frame.size.width{
                
                UIView.beginAnimations(rightMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(animationTime)
                rect.origin.x = freeRect.origin.x + freeRect.size.width - frame.size.width
                self.frame = rect
                UIView.commitAnimations()
            }

        } else if isKeepBounds == true{//自动粘边
            if frame.origin.x < centerX {
                
                UIView.beginAnimations(leftMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(animationTime)
                rect.origin.x = freeRect.origin.x
                self.frame = rect
                UIView.commitAnimations()
            }else{
                
                UIView.beginAnimations(rightMove, context: nil)
                UIView.setAnimationCurve(.easeInOut)
                UIView.setAnimationDuration(animationTime)
                rect.origin.x = freeRect.origin.x + freeRect.size.width - frame.size.width
                self.frame = rect
                UIView.commitAnimations()
            }
        }
        
        if frame.origin.y < freeRect.origin.y {
            UIView.beginAnimations("topMove", context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(animationTime)
            rect.origin.y = freeRect.origin.y
            self.frame = rect
            UIView.commitAnimations()
        }else if freeRect.origin.y + freeRect.size.height <  frame.origin.y + frame.size.height {
            UIView.beginAnimations("bottomMove", context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDuration(animationTime)
            rect.origin.y = freeRect.origin.y + freeRect.size.height - frame.size.height
            self.frame = rect
            UIView.commitAnimations()
        }
    }
}
