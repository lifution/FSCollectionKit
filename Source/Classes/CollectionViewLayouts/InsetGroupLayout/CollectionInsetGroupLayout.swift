//
//  CollectionInsetGroupLayout.swift
//  CollectionKit
//
//  Created by Sheng on 2024/11/4.
//  Copyright © 2024 Vincent. All rights reserved.
//

import UIKit
import Foundation

open class CollectionInsetGroupLayout: FSCollectionViewFlowLayout {
    
    // MARK: Properties/Open
    
    open weak var delegate: CollectionInsetGroupLayoutDelegate?
    
    // MARK: Properties/Private
    
    private var decorations = [Int: InsetGroupDecorationAttributes]()
    private let cornerDecorationViewKind = "_kCornerDecorationViewKind"
    
    // MARK: Initialization
    
    override public init() {
        super.init()
        p_didInitialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Private
    
    private func p_didInitialize() {
        register(InsetGroupDecorationView.self, forDecorationViewOfKind: cornerDecorationViewKind)
    }
}

// MARK: - Override

extension CollectionInsetGroupLayout {
    
    open override class var layoutAttributesClass: AnyClass {
        return CollectionInsetGroupLayoutAttributes.self
    }
    
    open override func prepare() {
        super.prepare()
        var attributeses = [Int: InsetGroupDecorationAttributes]()
        defer {
            decorations = attributeses
        }
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return
        }
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            if !delegate.collectionView(collectionView, shouldShowGroupAt: section) {
                continue
            }
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            if numberOfItems <= 0 {
                continue
            }
            var x: CGFloat = 0
            var y: CGFloat = 0
            var w: CGFloat = 0
            var h: CGFloat = 0
            let containerSize = collectionView.frame.size
            var inset = sectionInset
            if let flow = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                inset = flow.collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? .zero
            }
            let first = layoutAttributesForItem(at: .init(item: 0, section: section))?.frame ?? .zero
            let last = layoutAttributesForItem(at: .init(item: numberOfItems - 1, section: section))?.frame ?? .zero
            let sectionFrame = first.union(last)
            if sectionFrame.size == .zero {
                continue
            }
            if scrollDirection == .horizontal {
                x = sectionFrame.minX
                y = inset.top
                w = sectionFrame.width
                h = containerSize.height - inset.top - inset.bottom
            } else {
                x = inset.left
                y = sectionFrame.minY
                w = containerSize.width - inset.left - inset.right
                h = sectionFrame.height
            }
            let attributes = InsetGroupDecorationAttributes(forDecorationViewOfKind: cornerDecorationViewKind,
                                                            with: .init(item: 0, section: section))
            attributes.frame = .init(x: x, y: y, width: w, height: h)
            attributes.zIndex = -1
            attributes.color = delegate.collectionView(collectionView, groupBackgroundColorAt: section) ?? .clear
            attributes.cornerRadius = delegate.collectionView(collectionView, groupCornerRadiusAt: section)
            attributes.borderWidth = delegate.collectionView(collectionView, groupBorderWidthAt: section)
            attributes.borderColor = delegate.collectionView(collectionView, groupBorderColorAt: section)
            attributeses[section] = attributes
            do {
                let cornerRadius = delegate.collectionView(collectionView, groupCornerRadiusAt: section)
                if numberOfItems == 1 {
                    if let attributes = layoutAttributesForItem(at: .init(item: 0, section: section)) as? CollectionInsetGroupLayoutAttributes {
                        attributes.cornerRadius = cornerRadius
                        attributes.maskedCorners = .inner.all
                    }
                } else {
                    if let attributes = layoutAttributesForItem(at: .init(item: 0, section: section)) as? CollectionInsetGroupLayoutAttributes {
                        attributes.cornerRadius = cornerRadius
                        if scrollDirection == .vertical {
                            attributes.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        } else {
                            attributes.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                        }
                    }
                    if let attributes = layoutAttributesForItem(at: .init(item: numberOfItems - 1, section: section)) as? CollectionInsetGroupLayoutAttributes {
                        attributes.cornerRadius = cornerRadius
                        if scrollDirection == .vertical {
                            attributes.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                        } else {
                            attributes.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                        }
                    }
                }
            }
        }
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == cornerDecorationViewKind {
            return decorations[indexPath.section]
        }
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect) ?? []
        attributes += decorations.values.filter { $0.frame.intersects(rect) }
        return attributes
    }
}

private final class InsetGroupDecorationAttributes: UICollectionViewLayoutAttributes {
    
    var color: UIColor = .white
    var cornerRadius: CGFloat = 10.0
    var borderWidth: CGFloat = 0
    var borderColor: UIColor?
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! InsetGroupDecorationAttributes
        copy.color = color
        copy.cornerRadius = cornerRadius
        copy.borderWidth = borderWidth
        copy.borderColor = borderColor
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? InsetGroupDecorationAttributes else {
            return false
        }
        if !color.isEqual(rhs.color) {
            return false
        }
        if cornerRadius != rhs.cornerRadius {
            return false
        }
        if borderWidth != rhs.borderWidth {
            return false
        }
        if let color = borderColor, let rhsColor = rhs.borderColor {
            if !color.isEqual(rhsColor) {
                return false
            }
        }
        return super.isEqual(object)
    }
}

private final class InsetGroupDecorationView: UICollectionReusableView {
    
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
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? InsetGroupDecorationAttributes else {
            return
        }
        backgroundColor = attributes.color
        layer.cornerRadius = attributes.cornerRadius
        layer.borderWidth = attributes.borderWidth
        layer.borderColor = attributes.borderColor?.cgColor
    }
    
    // MARK: Private
    
    private func p_didInitialize() {
        clipsToBounds = true
    }
}
