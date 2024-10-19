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

public protocol LFDraggable: UIView {
    
    /// 添加拖动手势
    func addDragGesture()
}

public extension LFDraggable {

}

extension UIView {
    func lfc_addDragGesture() {
        self.clipsToBounds = true
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(clickDragView))
        self.addGestureRecognizer(singleTap)
        
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragAction(pan:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func dragAction(pan: UIPanGestureRecognizer) {
        
    }
    
    @objc func clickDragView() {
        
    }
}


public class SFDragView: UIView {
    
}
