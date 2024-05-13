//
//  CoreGraphics+FSCollectionKit.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

func _FSFlat<T: FloatingPoint>(_ x: T) -> T {
    guard
        x != T.leastNormalMagnitude,
        x != T.leastNonzeroMagnitude,
        x != T.greatestFiniteMagnitude
    else {
        return x
    }
    let scale: T = T(Int(UIScreen.inner.scale))
    let flattedValue = ceil(x * scale) / scale
    return flattedValue
}

extension FSCollectionInternalWrapper where Base == CGRect {
    
    var flattedValue: CGRect {
        return .init(origin: base.origin.inner.flattedValue,
                     size: base.size.inner.flattedValue)
    }
}

extension FSCollectionInternalWrapper where Base == CGSize {
    
    var flattedValue: CGSize {
        return .init(width: base.width.inner.flattedValue,
                     height: base.height.inner.flattedValue)
    }
}

extension FSCollectionInternalWrapper where Base == CGPoint {
    
    var flattedValue: CGPoint {
        return .init(x: base.x.inner.flattedValue,
                     y: base.y.inner.flattedValue)
    }
    
    func offset(_ offset: CGPoint) -> CGPoint {
        return .init(x: base.x + offset.x, y: base.y + offset.y)
    }
}

extension FSCollectionInternalWrapper where Base == CGFloat {
    
    var flattedValue: CGFloat {
        return _FSFlat(base)
    }
}

extension FSCollectionInternalWrapper where Base == UIEdgeInsets {
    
    func horizontalValue() -> CGFloat {
        return (base.left + base.right)
    }
    
    func verticalValue() -> CGFloat {
        return (base.top + base.bottom)
    }
}
