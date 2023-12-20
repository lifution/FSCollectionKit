//
//  FSCollectionSeparatorFooter.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

///
/// - Note:
///   FSCollection 组件还未添加 header/footer 的 reload 机制，因此本类的一些属性修
///   改后，headerView/footerView 不会立马刷新 UI，只有当 headerView/footerView 的
///   `render(with headerFooter:)` 方法被调用后才会更新 UI。
///
open class FSCollectionSeparatorFooter: FSCollectionHeaderFooter {
    
    // MARK: Properties/Public
    
    /// separator 的偏移量。
    ///
    /// - 当 collectionView 的滚动方向为 vertical 时，该属性的 left & right 生效，top & bottom 不生效。
    /// - 当 collectionView 的滚动方向为 horizontal 时，该属性的 top & bottom 生效，left & right 不生效。
    ///
    open var inset: UIEdgeInsets = .zero
    
    /// colltionView 的滚动方向，用于辅助 inset。
    open var direction: UICollectionView.ScrollDirection = .vertical
    
    /// separator 颜色。
    open var color: UIColor? = UIColor.inner.color(hexed: "#100d22")
    
    // MARK: Initialization
    
    public override init() {
        super.init()
        size = .init(width: 10.0, height: 10.0)
        viewType = FSCollectionSeparatorFooterView.self
    }
}

private class FSCollectionSeparatorFooterView: UICollectionReusableView, FSCollectionHeaderFooterViewRenderable {
    
    private var footer: FSCollectionSeparatorFooter?
    
    private let separator = _FSSeparatorView()
    
    private var inset: UIEdgeInsets = .zero
    private var direction: UICollectionView.ScrollDirection = .vertical
    private var viewSize = CGSize.zero
    private var needsUpdate = false
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        defer {
            p_updateIfNeeded()
        }
        if viewSize != bounds.size {
            viewSize = bounds.size
            needsUpdate = true
        }
    }
    
    // MARK: Private
    
    /// Invoked after initialization.
    private func p_didInitialize() {
        defer {
            p_setNeedsUpdate()
        }
        addSubview(separator)
    }
    
    private func p_setNeedsUpdate() {
        needsUpdate = true
        setNeedsLayout()
    }
    
    private func p_updateIfNeeded() {
        if needsUpdate {
            p_update()
        }
    }
    
    private func p_update() {
        needsUpdate = false
        do {
            let bounds = CGRect(origin: .zero, size: viewSize)
            let x: CGFloat = {
                if direction == .vertical {
                    return inset.left
                }
                return 0.0
            }()
            let y: CGFloat = {
                if direction == .horizontal {
                    return inset.top
                }
                return 0.0
            }()
            let w: CGFloat = {
                if direction == .vertical {
                    return (bounds.width - x - inset.right)
                }
                return bounds.width
            }()
            let h: CGFloat = {
                if direction == .vertical {
                    return bounds.height
                }
                return (bounds.height - y - inset.bottom)
            }()
            separator.frame = .init(x: x, y: y, width: w, height: h)
        }
    }
    
    // MARK: FSCollectionHeaderFooterViewRenderable
    
    func render(with headerFooter: FSCollectionHeaderFooterConvertable) {
        guard let footer = headerFooter as? FSCollectionSeparatorFooter else {
            return
        }
        self.footer = footer
        separator.color = footer.color
        if inset != footer.inset {
            inset = footer.inset
            p_setNeedsUpdate()
        }
        if direction != footer.direction {
            direction = footer.direction
            p_setNeedsUpdate()
        }
    }
}
