//
//  FSCollectionItem.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

///
/// ``FSCollectionItemConvertable`` 协议的默认实现类，用于快速构建。
///
/// - Note:
///   - 若想拓展业务请自行创建类实现 ``FSCollectionItemConvertable`` 协议。
///
open class FSCollectionItem: FSCollectionItemConvertable {
    ///
    /// 当 flowLayout 为 vertical 模式时，如果 ``FSCollectionItem/size/width`` 使用了 ``FSCollectionItem/AutomaticWidth``，
    /// 则默认为 item 的宽度自动适应最大的宽度，也即: `collectionView.bounds.width - (sectionInset.left + sectionInset.right)`。
    ///
    /// - Note: 当 flowLayout 为 horizontal 模式时，设置 item.width 为 AutomaticWidth 则会无效。
    ///
    public static let AutomaticWidth: CGFloat = -1.0
    ///
    /// 当 flowLayout 为 horizontal 模式时，如果 ``FSCollectionItem/size/height`` 使用了 ``FSCollectionItem/AutomaticHeight``，
    /// 则默认为 item 的宽度自动适应最大的高度，也即: `collectionView.bounds.height - (sectionInset.top + sectionInset.bottom)`。
    ///
    /// - Note: 当 flowLayout 为 vertical 模式时，设置 item.height 为 AutomaticHeight 则会无效。
    ///
    public static let AutomaticHeight: CGFloat = -1.0
    
    open var size: CGSize {
        get { lock.withLock { _size } }
        set { lock.withLock { _size = newValue } }
    }
    
    open var data: Any? {
        get { lock.withLock { _data } }
        set { lock.withLock { _data = newValue } }
    }
    
    open var cellType: UICollectionViewCell.Type {
        get { lock.withLock { _cellType } }
        set { lock.withLock { _cellType = newValue } }
    }
    
    open var needsUpdate: Bool {
        get { lock.withLock { _needsUpdate } }
        set { lock.withLock { _needsUpdate = newValue } }
    }
    
    open var shouldSelect: Bool {
        get { lock.withLock { _shouldSelect } }
        set { lock.withLock { _shouldSelect = newValue } }
    }
    
    open var shouldDeselect: Bool {
        get { lock.withLock { _shouldDeselect } }
        set { lock.withLock { _shouldDeselect = newValue } }
    }
    
    open var shouldHighlight: Bool {
        get { lock.withLock { _shouldHighlight } }
        set { lock.withLock { _shouldHighlight = newValue } }
    }
    
    open var reuseIdentifier: String {
        get { lock.withLock { _reuseIdentifier } }
        set { lock.withLock { _reuseIdentifier = newValue } }
    }
    
    open var onDidSelect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)? {
        get { lock.withLock { _onDidSelect } }
        set { lock.withLock { _onDidSelect = newValue } }
    }
    
    open var onDidDeselect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)? {
        get { lock.withLock { _onDidDeselect } }
        set { lock.withLock { _onDidDeselect = newValue } }
    }
    
    open var onWillDisplay: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)? {
        get { lock.withLock { _onWillDisplay } }
        set { lock.withLock { _onWillDisplay = newValue } }
    }
    
    open var onDidEndDisplaying: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)? {
        get { lock.withLock { _onDidEndDisplaying } }
        set { lock.withLock { _onDidEndDisplaying = newValue } }
    }
    
    private var _size: CGSize = .zero
    private var _data: Any?
    private var _cellType: UICollectionViewCell.Type = CollectionReusableCell.self
    private var _needsUpdate: Bool = true
    private var _shouldSelect: Bool = true
    private var _shouldDeselect: Bool = true
    private var _shouldHighlight: Bool = true
    private var _reuseIdentifier: String
    private var _onDidSelect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    private var _onDidDeselect: ((_ collectionView: UICollectionView, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    private var _onWillDisplay: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    private var _onDidEndDisplaying: ((_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath, _ item: FSCollectionItemConvertable) -> Void)?
    
    private let lock = UnfairLock()
    
    public init() {
        _reuseIdentifier = "\(type(of: self))"
    }
}
