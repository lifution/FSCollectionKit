//
//  FSCollectionHeaderFooter.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// FSCollectionHeaderFooterConvertable 协议的默认实现类，用于快速构建。
/// - Note: 若想拓展业务请自行创建类实现 FSCollectionHeaderFooterConvertable 协议。
open class FSCollectionHeaderFooter: FSCollectionHeaderFooterConvertable {
    
    open var data: Any?
    open var size: CGSize
    open var viewType: UICollectionReusableView.Type
    open var needsUpdate: Bool
    open var reuseIdentifier: String
    open var onWillDisplay: ((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)?
    open var onDidEndDisplaying: ((_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ indexPath: IndexPath) -> Void)?
    
    public init() {
        size = .zero
        viewType = UICollectionReusableView.self
        needsUpdate = true
        reuseIdentifier = "\(type(of: self))"
    }
}
