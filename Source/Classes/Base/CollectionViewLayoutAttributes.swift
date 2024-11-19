//
//  CollectionViewLayoutAttributes.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/11/20.
//

import UIKit
import Foundation

open class CollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    open var isSeparatorHidden: Bool = false
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CollectionViewLayoutAttributes
        copy.isSeparatorHidden = isSeparatorHidden
        return copy
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? CollectionViewLayoutAttributes else {
            return false
        }
        if isSeparatorHidden != rhs.isSeparatorHidden {
            return false
        }
        return super.isEqual(object)
    }
}
