//
//  FSCollectionHeaderFooterConvertable.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public protocol FSCollectionHeaderFooterConvertable {
    
    /// header/footer 的类型。
    var viewType: (UICollectionReusableView.Type) { get set }
    
    /// header/footer 绑定的数据。
    var data: Any? { get set }
    
    /// header/footer 的 size。
    ///
    /// - Note:
    /// 该属性只在 UICollectionViewFlowLayout 时才起作用，而需要特别说明的是：
    /// 在 vertical 模式下，size.height 表示的是 header/footer 的高度，header/footer 的宽度默认为 collectionView 的宽度。
    /// 在 horizontal 模式下，size.width 表示的是 header/footer 的宽度，header/footer 的高度默认为 collectionView 的高度。
    ///
    var size: CGSize { get set }
    
    /// 辅助标识是否需要刷新 view。
    /// 有一些 view 可能只有在数据源更新后才需要在更新 UI，可以使用该属性控制。
    var needsUpdate: Bool { get set }
    
    /// header/footer 重用标识符
    var reuseIdentifier: String { get set }
    
    /// 将要显示时的回调，可以在这里做一些 cell 的更新。
    ///
    /// - Important: 该 closure 的存在是为了在 header/footerView 不实现 FSCollectionHeaderFooterViewRenderable 协议时也能
    ///              让 header/footer 操作 header/footerView 的更新，如果 header/footerView 实现了 FSCollectionHeaderFooterViewRenderable 协议，
    ///              那么在 UICollectionViewDelegate 的 willDisplay 方法中会先进行 FSCollectionHeaderFooterViewRenderable 协议方法的调用，然后才是回调该 closure，
    ///              **使用者需注意不要在两个地方都更新一次 header/footerView**。
    var onWillDisplay: ((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)? { get set }
    
    /// 当一个 header/footer 消失在显示范围内后会回调该 closure。
    /// 该 closure 的功能对应 UICollectionViewDelegate 中的 `collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:)` 方法。
    var onDidEndDisplaying: ((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)? { get set }
}

/// Optional
public extension FSCollectionHeaderFooterConvertable {
    
    var viewType: (UICollectionReusableView.Type) {
        get { return UICollectionReusableView.self }
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
    
    var reuseIdentifier: String {
        get { return "\(type(of: self))"}
        set {}
    }
    
    var onWillDisplay: ((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)? {
        get { return nil }
        set {}
    }
    
    var onDidEndDisplaying: ((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)? {
        get { return nil }
        set {}
    }
}
