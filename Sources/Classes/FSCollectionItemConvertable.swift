//
//  FSCollectionItemConvertable.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import ObjectiveC

public enum FSCollectionItemReloadType {
    
    /// 让 collectionView 调用 `reloadItems(at:)` 方法更新对应的 item。
    case reload
    
    /// 不调用 collectionView 的任何刷新方法，直接对 cell 进行重新渲染。
    ///
    /// - Note:
    /// 使用这个方式则必须保证 cell 遵循 FSCollectionCellRenderable 协议，否则刷新失败。
    /// 另外，如果 cell 不存在于 collectionView.visibleCells 数组中，同样会刷新失败。
    ///
    case reRender
    
    /// 让 collectionView 调用 `reloadData` 方法刷新整个 collectionView。
    case reloadCollection
}

public protocol FSCollectionItemConvertable: AnyObject {
    
    /// cell 的类型。
    var cellType: (UICollectionViewCell.Type) { get set }
    
    /// cell 绑定的数据。
    var data: Any? { get set }
    
    /// item 的 size。
    var size: CGSize { get set }
    
    /// 辅助标识是否需要刷新 cell。
    /// 有一些 cell 可能只有在数据源更新后才需要在更新 UI，可以使用该属性控制。
    var needsUpdate: Bool { get set }
    
    var shouldSelect: Bool { get set }
    
    var shouldDeselect: Bool { get set }
    
    var shouldHighlight: Bool { get set }
    
    /// cell 重用标识符。
    var reuseIdentifier: String { get set }
    
    /// 被选中后的回调。
    var onDidSelect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)? { get set }
    
    /// 被取消选中后的回调。
    var onDidDeselect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)? { get set }
    
    /// 该 closure 的功能对应 UICollectionViewDelegate 中的 `collectionView(_ collectionView:, willDisplay cell:, forItemAt indexPath:)` 方法。
    ///
    /// - Important:
    /// 最好不要使用该 closure 来更新 cell，因为 UICollectionView 调用了 cellForItemAt 之后可能不会立即调用 willDisplayCell 方法，
    /// 因此如果在该 closure 中更新 cell 的话，可能会出现更新不及时的情况。
    ///
    var onWillDisplay: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? { get set }
    
    /// 该 closure 的功能对应 UICollectionViewDelegate 中的 `collectionView(_:didEndDisplaying:forItemAt:)` 方法。
    var onDidEndDisplaying: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? { get set }
}

/// optional
public extension FSCollectionItemConvertable {
    
    var cellType: (UICollectionViewCell.Type) {
        get { return UICollectionViewCell.self }
        set {}
    }
    
    var data: Any? {
        get { return nil }
        set {}
    }
    
    var size: CGSize {
        get { return .zero }
        set {}
    }
    
    var needsUpdate: Bool {
        get { return true }
        set {}
    }
    
    var shouldSelect: Bool {
        get { return true }
        set {}
    }
    
    var shouldDeselect: Bool {
        get { return true }
        set {}
    }
    
    var shouldHighlight: Bool {
        get { return true }
        set {}
    }
    
    var reuseIdentifier: String {
        get { return "\(type(of: self))" }
        set {}
    }
    
    var onDidSelect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)? {
        get { return nil }
        set {}
    }
    
    var onDidDeselect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)? {
        get { return nil }
        set {}
    }
    
    var onWillDisplay: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? {
        get { return nil }
        set {}
    }
    
    var onDidEndDisplaying: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? {
        get { return nil }
        set {}
    }
}

extension FSCollectionItemConvertable {
    
    /// 刷新当前 item 对应的 cell
    public func reload(_ type: FSCollectionItemReloadType) {
        reloadHandler?(type)
    }
}

// MARK: - FSCollectionItemConvertable/AssociatedObject

private var _key = 0
typealias FSCollectionItemConvertableReloadHandler = (FSCollectionItemReloadType) -> Void
extension FSCollectionItemConvertable {
    /// 该属性是用于辅助 item 的更新请求的，当 item 调用 `reload(_:)` 方法时，会调用该属性。
    /// 该属性会在 FSCollectionManager 实现。
    var reloadHandler: FSCollectionItemConvertableReloadHandler? {
        get {
            return objc_getAssociatedObject(self, &_key) as? FSCollectionItemConvertableReloadHandler
        }
        set {
            objc_setAssociatedObject(self, &_key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
