//
//  FSCollectionSection.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// FSCollectionSectionConvertable 协议的默认实现类，用于快速构建。
/// - Note: 若想拓展业务请自行创建类实现 FSCollectionSectionConvertable 协议。
open class FSCollectionSection: FSCollectionSectionConvertable {
    
    open var items: [FSCollectionItemConvertable] = []
    open var header: FSCollectionHeaderFooterConvertable?
    open var footer: FSCollectionHeaderFooterConvertable?
    open var inset: UIEdgeInsets
    open var minimumLineSpacing: CGFloat
    open var minimumInteritemSpacing: CGFloat
    
    public init(items: [FSCollectionItemConvertable] = [],
                header: FSCollectionHeaderFooterConvertable? = nil,
                footer: FSCollectionHeaderFooterConvertable? = nil,
                inset: UIEdgeInsets = .zero,
                minimumLineSpacing: CGFloat = 0.0,
                minimumInteritemSpacing: CGFloat = 0.0) {
        self.items  = items
        self.header = header
        self.footer = footer
        self.inset  = inset
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
}
