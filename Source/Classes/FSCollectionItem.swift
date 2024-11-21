//
//  FSCollectionItem.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// FSCollectionItemConvertable 协议的默认实现类，用于快速构建。
/// - Note: 若想拓展业务请自行创建类实现 FSCollectionItemConvertable 协议。
open class FSCollectionItem: FSCollectionItemConvertable {
    
    /// 当 flowLayout 为 vertical 模式时，如果 item.width 使用了 AutomaticWidth，
    /// 则默认为 item 的宽度自动适应最大的宽度，也即: `collectionView.bounds.width - (sectionInset.left + sectionInset.right)`。
    ///
    /// - Note: 当 flowLayout 为 horizontal 模式时，设置 item.width 为 AutomaticWidth 则会无效。
    ///
    public static let AutomaticWidth: CGFloat = -1.0
    
    /// 当 flowLayout 为 horizontal 模式时，如果 item.height 使用了 AutomaticHeight，
    /// 则默认为 item 的宽度自动适应最大的高度，也即: `collectionView.bounds.height - (sectionInset.top + sectionInset.bottom)`。
    ///
    /// - Note: 当 flowLayout 为 vertical 模式时，设置 item.height 为 AutomaticHeight 则会无效。
    ///
    public static let AutomaticHeight: CGFloat = -1.0
    
    open var size: CGSize
    open var data: Any?
    open var cellType: UICollectionViewCell.Type
    open var needsUpdate: Bool
    open var shouldSelect: Bool
    open var shouldDeselect: Bool
    open var shouldHighlight: Bool
    open var reuseIdentifier: String
    open var onDidSelect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    open var onDidDeselect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    open var onWillDisplay: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    open var onDidEndDisplaying: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    
    public init() {
        size = .zero
        cellType = CollectionReusableCell.self
        needsUpdate = true
        shouldSelect = true
        shouldDeselect = true
        shouldHighlight = true
        reuseIdentifier = "\(type(of: self))"
    }
}
