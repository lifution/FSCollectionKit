//
//  FSCollectionLayoutableItem.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/6/15.
//  Copyright © 2024 VincentLee. All rights reserved.
//

import UIKit

/// layoutable 通用 item 基类。
/// 该类用于垂直方向下的 item。
/// 该类的子类的 cell 必须继承于 FSCollectionLayoutableCell。
open class FSCollectionLayoutableItem: FSCollectionItem, FSCollectionItemLayoutable {
    
    // MARK: Properties/Internal
    
    /// 是否是作为静态展示（不响应交互）
    /// 该属性只是方便外部标记，并不是真的禁用了 item 的 selection 响应。
    /// 默认为 false。
    open var isStatic = false
    
    open var separatorInset = UIEdgeInsets.zero
    open var separatorHeight = UIScreen.inner.pixelOne
    open var separatorColor = UIColor.inner.color(hexed: "#CFCFCF") ?? .gray
    open var isSeparatorHidden = false
    
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
}

open class FSCollectionLayoutableCell: UICollectionViewCell, FSCollectionCellRenderable {
    
    // MARK: Properties/Private
    
    private let separatorView = _FSSeparatorView()
    
    private var leftConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Override
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bringSubviewToFront(separatorView)
    }
    
    // MARK: Open
    
    open func didInitialize() {}
    
    // MARK: Private
    
    private func p_didInitialize() {
        defer {
            didInitialize()
        }
        backgroundColor = .white
        contentView.backgroundColor = .white
        separatorView.color = .inner.color(hexed: "#CFCFCF")
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
        guard let item = item as? FSCollectionLayoutableItem else { return }
        separatorView.color = item.separatorColor
        separatorView.isHidden = item.isSeparatorHidden
        if !item.isSeparatorHidden {
            leftConstraint.constant   = item.separatorInset.left
            bottomConstraint.constant = -item.separatorInset.bottom
            rightConstraint.constant  = -item.separatorInset.right
            heightConstraint.constant = item.separatorHeight
        }
    }
}
