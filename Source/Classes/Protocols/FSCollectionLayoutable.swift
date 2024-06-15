//
//  FSCollectionLayoutable.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/6/15.
//

import Foundation

public protocol FSCollectionContentLayoutable: AnyObject {
    /// 内容边距
    var contentInset: UIEdgeInsets { get set }
    /// 容器 size。
    var containerSize: CGSize { get set }
    /// 更新布局。
    func updateLayout()
}

public protocol FSCollectionItemLayoutable: FSCollectionContentLayoutable {
    /// 所在 section 的 inset
    var sectionInset: UIEdgeInsets { get set }
}
