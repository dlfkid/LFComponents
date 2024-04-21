//
//  Wrapper.swift
//  LFComponents
//
//  Created by Ravendeng on 2024/4/21.
//

import Foundation

public protocol LFCWrapperable: AnyObject { }

/// The default implementation of sf namespace protocol
public extension LFCWrapperable {
    var lfc: LFCWrapper<Self> {
        get { return LFCWrapper(self) }
        set {}
    }
    
    static var lfc: LFCWrapper<Self>.Type {
        get { return LFCWrapper<Self>.self }
        set { }
    }
}

/// The real value holder of `LFCWrapperable`
public struct LFCWrapper<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}
