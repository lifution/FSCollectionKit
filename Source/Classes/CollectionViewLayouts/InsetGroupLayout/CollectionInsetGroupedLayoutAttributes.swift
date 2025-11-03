//
//  CollectionInsetGroupedLayoutAttributes.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/11/20.
//

import UIKit
import Foundation

open class CollectionInsetGroupedLayoutAttributes: CollectionViewLayoutAttributes {
    
    open var cornerRadius = 0.0
    open var maskedCorners = CACornerMask.inner.all
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CollectionInsetGroupedLayoutAttributes
        copy.cornerRadius = cornerRadius
        copy.maskedCorners = maskedCorners
        return copy
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard
            let rhs = object as? CollectionInsetGroupedLayoutAttributes,
            cornerRadius == rhs.cornerRadius,
            maskedCorners == rhs.maskedCorners
        else {
            return false
        }
        return super.isEqual(object)
    }
}
