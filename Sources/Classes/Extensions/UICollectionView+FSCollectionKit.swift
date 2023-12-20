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
public extension UICollectionView {
    
    var collectionManager: FSCollectionManager? {
        get {
            return objc_getAssociatedObject(self, &_key) as? FSCollectionManager
        }
        set {
            newValue?.bind(to: self)
            objc_setAssociatedObject(self, &_key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
