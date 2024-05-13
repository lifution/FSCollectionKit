//
//  UICollectionView+FSCollectionKit.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Foundation
import ObjectiveC

private var _key = 0
public extension FSCollectionKitWrapper where Base: UICollectionView {
    
    var manager: FSCollectionManager? {
        get {
            return objc_getAssociatedObject(base, &_key) as? FSCollectionManager
        }
        set {
            newValue?.bind(to: base)
            objc_setAssociatedObject(base, &_key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
