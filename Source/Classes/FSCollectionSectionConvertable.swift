//
//  FSCollectionSectionConvertable.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import ObjectiveC

/// section 的更新方式。
public enum FSCollectionSectionReloadType {
    
    /// 让 collectionView 调用 `reloadSections(at:)` 方法更新对应的 section。
    case reload
    
    /// 不调用 collectionView 的任何刷新方法，直接对 section 中的 cell 进行重新渲染。
    ///
    /// - Note:
    /// 使用这个方式则必须保证 cell 遵循 FSCollectionCellRenderable 协议，
    /// 另外，只有当 cell 在 UI 上是可视的才会生效，即 cell 存在于 collectionView.visibleCells 数组中。
    ///
    case reRender
    
    /// 让 collectionView 调用 `reloadData` 方法刷新整个 collectionView。
    case reloadCollection
}

public protocol FSCollectionSectionConvertable: AnyObject {
    
    var items: [FSCollectionItemConvertable] { get set }
    var header: FSCollectionHeaderFooterConvertable? { get set }
    var footer: FSCollectionHeaderFooterConvertable? { get set }
    
    /**
     1、以下三个属性默认是为` UICollectionViewDelegateFlowLayout` 而备的。
     2、自定义布局有需要也可使用以下属性。
     */
    var inset: UIEdgeInsets { get set }
    var minimumLineSpacing: CGFloat { get set }
    var minimumInteritemSpacing: CGFloat { get set }
}

/// optional
public extension FSCollectionSectionConvertable {
    
    var items: [FSCollectionItemConvertable] {
        get { return [] }
        set {}
    }
    
    var header: FSCollectionHeaderFooterConvertable? {
        get { return nil }
        set {}
    }
    
    var footer: FSCollectionHeaderFooterConvertable? {
        get { return nil }
        set {}
    }
    
    var inset: UIEdgeInsets {
        get { return .zero }
        set {}
    }
    
    var minimumLineSpacing: CGFloat {
        get { return 0.0 }
        set {}
    }
    
    var minimumInteritemSpacing: CGFloat {
        get { return 0.0 }
        set {}
    }
}

extension FSCollectionSectionConvertable {
    
    /// 刷新当前 section 对应的 collectionView.section
    public func reload(_ type: FSCollectionSectionReloadType) {
        reloadHandler?(type)
    }
}

// MARK: - FSCollectionSectionConvertable/AssociatedObject

private var _key = 0
typealias FSCollectionSectionConvertableReloadHandler = (FSCollectionSectionReloadType) -> Void
extension FSCollectionSectionConvertable {
    /// 该属性是用于辅助 section 的更新请求的，当 section 调用 `reload(_:)` 方法时，会调用该属性。
    /// 该属性会在 FSCollectionManager 实现。
    var reloadHandler: FSCollectionSectionConvertableReloadHandler? {
        get {
            return objc_getAssociatedObject(self, &_key) as? FSCollectionSectionConvertableReloadHandler
        }
        set {
            objc_setAssociatedObject(self, &_key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
