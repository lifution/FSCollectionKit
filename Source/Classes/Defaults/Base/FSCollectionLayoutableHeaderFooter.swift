//
//  FSCollectionLayoutableHeaderFooter.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/7/6.
//  Copyright © 2024 VincentLee. All rights reserved.
//

import UIKit

/// layoutable 通用 header/footer 基类。
/// 该类用于垂直方向下的 header/footer。
/// 该类的子类的 view 必须继承于 FSCollectionLayoutableHeaderFooterView。
open class FSCollectionLayoutableHeaderFooter: FSCollectionHeaderFooter, FSCollectionContentLayoutable {
    
    // MARK: Properties/Open
    
    open var separatorInset = UIEdgeInsets.zero
    open var separatorHeight = UIScreen.inner.pixelOne
    open var separatorColor = UIColor.inner.color(hexed: "#CFCFCF") ?? .gray
    open var isSeparatorHidden = true
    
    // MARK: Initialization
    
    public override init() {
        super.init()
        viewType = FSCollectionLayoutableHeaderFooterView.self
    }
    
    // MARK: FSCollectionContentLayoutable
    
    /// header/footer 内容四边边距，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///
    open var contentInset: UIEdgeInsets = .zero
    
    /// header/footer 所在 UICollectionView 的 size，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///
    open var containerSize: CGSize = .zero
    
    /// 更新 header/footer 的 size、布局信息等。
    ///
    /// - 基类虽然已经默认计算了 `size.width`，但子类可根据自身情况重新设定 `size.width`。
    /// - 基类默认实现为:
    ///   ```
    ///   size.width = containerSize.width
    ///   ```
    ///
    open func updateLayout() {
        size.width = containerSize.width
    }
}

open class FSCollectionLayoutableHeaderFooterView: UICollectionReusableView, FSCollectionHeaderFooterViewRenderable {
    
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
        bringSubviewToFront(separatorView)
    }
    
    // MARK: Open
    
    open func didInitialize() {}
    
    // MARK: Private
    
    private func p_didInitialize() {
        defer {
            didInitialize()
        }
        backgroundColor = .white
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorView)
        do {
            let constraint = NSLayoutConstraint(item: separatorView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1.0,
                                                constant: 0.0)
            leftConstraint = constraint
            addConstraint(constraint)
        }
        do {
            let constraint = NSLayoutConstraint(item: separatorView,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: 0.0)
            bottomConstraint = constraint
            addConstraint(constraint)
        }
        do {
            let constraint = NSLayoutConstraint(item: separatorView,
                                                attribute: .right,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .right,
                                                multiplier: 1.0,
                                                constant: 0.0)
            rightConstraint = constraint
            addConstraint(constraint)
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
            addConstraint(constraint)
        }
    }
    
    // MARK: FSCollectionHeaderFooterViewRenderable
    
    open func render(with headerFooter: FSCollectionHeaderFooterConvertable) {
        guard let headerFooter = headerFooter as? FSCollectionLayoutableHeaderFooter else { return }
        separatorView.color = headerFooter.separatorColor
        separatorView.isHidden = headerFooter.isSeparatorHidden
        if !headerFooter.isSeparatorHidden {
            leftConstraint.constant   = headerFooter.separatorInset.left
            bottomConstraint.constant = -headerFooter.separatorInset.bottom
            rightConstraint.constant  = -headerFooter.separatorInset.right
            heightConstraint.constant = headerFooter.separatorHeight
        }
    }
}
