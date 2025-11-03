//
//  FSCollectionSection.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

///
/// FSCollectionSectionConvertable 协议的默认实现类，用于快速构建。
///
/// - Note:
///   - 若想拓展业务请自行创建类实现 FSCollectionSectionConvertable 协议。
///
open class FSCollectionSection: FSCollectionSectionConvertable {
    
    open var items: [FSCollectionItemConvertable] {
        get { lock.withLock { _items } }
        set { lock.withLock { _items = newValue } }
    }
    
    open var header: FSCollectionHeaderFooterConvertable? {
        get { lock.withLock { _header } }
        set { lock.withLock { _header = newValue } }
    }
    
    open var footer: FSCollectionHeaderFooterConvertable? {
        get { lock.withLock { _footer } }
        set { lock.withLock { _footer = newValue } }
    }
    
    open var inset: UIEdgeInsets {
        get { lock.withLock { _inset } }
        set { lock.withLock { _inset = newValue } }
    }
    
    open var minimumLineSpacing: CGFloat {
        get { lock.withLock { _minimumLineSpacing } }
        set { lock.withLock { _minimumLineSpacing = newValue } }
    }
    
    open var minimumInteritemSpacing: CGFloat {
        get { lock.withLock { _minimumInteritemSpacing } }
        set { lock.withLock { _minimumInteritemSpacing = newValue } }
    }
    
    private var _items: [FSCollectionItemConvertable] = []
    private var _header: FSCollectionHeaderFooterConvertable?
    private var _footer: FSCollectionHeaderFooterConvertable?
    private var _inset: UIEdgeInsets = .zero
    private var _minimumLineSpacing: CGFloat = 0.0
    private var _minimumInteritemSpacing: CGFloat = 0.0
    
    private let lock = UnfairLock()
    
    public init(items: [FSCollectionItemConvertable] = [],
                header: FSCollectionHeaderFooterConvertable? = nil,
                footer: FSCollectionHeaderFooterConvertable? = nil,
                inset: UIEdgeInsets = .zero,
                minimumLineSpacing: CGFloat = 0.0,
                minimumInteritemSpacing: CGFloat = 0.0) {
        _items  = items
        _header = header
        _footer = footer
        _inset  = inset
        _minimumLineSpacing = minimumLineSpacing
        _minimumInteritemSpacing = minimumInteritemSpacing
    }
}
