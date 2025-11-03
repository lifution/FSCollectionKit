//
//  CollectionInsetGroupedLayoutDelegate.swift
//  FSCollectionKit
//
//  Created by Sheng on 2024/11/4.
//  Copyright © 2024 Sheng. All rights reserved.
//

import UIKit

public protocol CollectionInsetGroupedLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedCornerRadiusAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedBackgroundColorAt section: Int) -> UIColor?
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedBorderWidthAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedBorderColorAt section: Int) -> UIColor?
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedInsetsAt section: Int) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, shouldShowInsetGroupedAt section: Int) -> Bool
}

public extension CollectionInsetGroupedLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedCornerRadiusAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedBackgroundColorAt section: Int) -> UIColor? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedBorderWidthAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedBorderColorAt section: Int) -> UIColor? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedInsetsAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowInsetGroupedAt section: Int) -> Bool {
        return true
    }
}
