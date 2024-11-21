//
//  FSCollectionLayoutableItem.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/6/15.
//  Copyright © 2024 VincentLee. All rights reserved.
//

import UIKit

/// layoutable 通用 item 基类。
/// 该类目前仅用于**垂直方向**的 item。
/// 建议子类的 cellType 优先选择继承于 FSCollectionLayoutableCell，
/// 否则一些特性可能会不生效，比如底部分割线。
open class FSCollectionLayoutableItem: FSCollectionItem, FSCollectionItemLayoutable {
    
    /// 是否是作为静态展示（不响应交互）
    /// 该属性只是方便外部标记，并不是真的禁用了 item 的 selection 响应。
    /// 默认为 false。
    open var isStatic = false
    
    open var separatorInset = UIEdgeInsets.zero
    open var separatorHeight = UIScreen.inner.pixelOne
    open var separatorColor = UIColor.inner.color(hexed: "#e5e7e9") ?? .gray
    open var isSeparatorHidden = true
    
    /// 是否忽略 ``isSeparatorHidden`` 属性，默认为 false。
    /// 如果该属性为 true，则 ``isSeparatorHidden`` 属性不会再生效。
    ///
    /// 比如忽略 ``isSeparatorHidden`` 属性，转而使用 ``attributes.isSeparatorHidden`` 来控制
    /// separator 的隐藏状态，这样就不用外部手动控制每个 section 最后一个 cell 的 separator 的隐
    /// 藏状态了，而是交由 ``collection view layout`` 去配置 ``attributes.isSeparatorHidden``，
    /// 这样就更方便、更高效、更低出错率地管理 separator 的状态。
    open var ignoresSeparatorHidden = false
    
    /// cell 背景颜色
    open var backgroundColor: UIColor? = .white
    
    // MARK: Initialization
    
    public override init() {
        super.init()
        cellType = FSCollectionLayoutableCell.self
    }
    
    // MARK: FSCollectionItemLayoutable
    
    /// item 所在 section 的 inset，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///
    open var sectionInset: UIEdgeInsets = .zero
    
    /// item 内容四边边距，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///
    open var contentInset: UIEdgeInsets = .zero
    
    /// item 所在 UICollectionView 的 size，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///
    open var containerSize: CGSize = .zero
    
    /// 更新 item，比如 item 的 size、布局信息等。
    ///
    /// - 基类虽然已经默认计算了 `size.width`，但子类可根据自身情况重新设定 `size.width`。
    /// - 基类默认实现为:
    ///   ```
    ///   size.width = floor(containerSize.width - sectionInset.fs.horizontalValue())
    ///   ```
    ///
    open func updateLayout() {
        size.width = floor(containerSize.width - sectionInset.inner.horizontalValue())
    }
    
    // MARK: Open
    
    /// 重新绘制内容并刷新 cell
    /// 高度不变时是 rerender cell，高度变化时是 reload cell
    open func reload() {
        let before = size.height
        updateLayout()
        let after = size.height
        reload(abs(after - before) >= 0.5 ? .reload : .reRender)
    }
}

open class FSCollectionLayoutableCell: CollectionReusableCell, FSCollectionCellRenderable {
    
    // MARK: Properties/Private
    
    private weak var item: FSCollectionLayoutableItem?
    
    private let separatorView = _FSSeparatorView()
    
    private var leftConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    
    // MARK: Override
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let item = item, !item.ignoresSeparatorHidden {
            /// 如果是在 cell 未复用的情况下调用该方法，那么就不会走 `render` 方法，因此
            /// 需要在这里判断，如果存在 item 且 ``item.ignoresSeparatorHidden`` 为 false，
            /// 则使用 item 的 ``isSeparatorHidden`` 配置，忽略 ``layoutAttributes.isSeparatorHidden`` 的配置。
            separatorView.isHidden = item.isSeparatorHidden
            return
        }
        if let attributes = layoutAttributes as? CollectionViewLayoutAttributes {
            /// 该方法会比 `render` 方法更早调用，所以此处直接先设置 attributes 中的值，
            /// 如果 ``item.ignoresSeparatorHidden`` 为 false，则 `render` 方法中会覆
            /// 盖设定 separator 的隐藏状态。
            separatorView.isHidden = attributes.isSeparatorHidden
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bringSubviewToFront(separatorView)
    }
    
    open override func didInitialize() {
        super.didInitialize()
        contentView.backgroundColor = .white
        separatorView.isHidden = true
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        do {
            let constraint = NSLayoutConstraint(item: separatorView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: contentView,
                                                attribute: .left,
                                                multiplier: 1.0,
                                                constant: 0.0)
            leftConstraint = constraint
            contentView.addConstraint(constraint)
        }
        do {
            let constraint = NSLayoutConstraint(item: separatorView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: contentView,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: 0.0)
            bottomConstraint = constraint
            contentView.addConstraint(constraint)
        }
        do {
            let constraint = NSLayoutConstraint(item: separatorView,
                                                attribute: .right,
                                                relatedBy: .equal,
                                                toItem: contentView,
                                                attribute: .right,
                                                multiplier: 1.0,
                                                constant: 0.0)
            rightConstraint = constraint
            contentView.addConstraint(constraint)
        }
        do {
            let constraint = NSLayoutConstraint(item: separatorView,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1.0,
                                                constant: 1.0)
            heightConstraint = constraint
            contentView.addConstraint(constraint)
        }
    }
    
    // MARK: FSCollectionCellRenderable
    
    open func render(with item: FSCollectionItemConvertable) {
        self.item = nil
        guard let item = item as? FSCollectionLayoutableItem else { return }
        self.item = item
        contentView.backgroundColor = item.backgroundColor
        separatorView.color = item.separatorColor
        leftConstraint.constant = item.separatorInset.left
        bottomConstraint.constant = -item.separatorInset.bottom
        rightConstraint.constant  = -item.separatorInset.right
        heightConstraint.constant = item.separatorHeight
        if !item.ignoresSeparatorHidden {
            separatorView.isHidden = item.isSeparatorHidden
        }
    }
}
