//
//  CollectionInsetGroupedLayout.swift
//  CollectionKit
//
//  Created by Sheng on 2024/11/4.
//  Copyright © 2024 Vincent. All rights reserved.
//

import UIKit
import Foundation

open class CollectionInsetGroupedLayout: FSCollectionViewFlowLayout {
    
    // MARK: =
    
    open weak var delegate: CollectionInsetGroupedLayoutDelegate?
    
    // MARK: =
    
    private var decorations = [Int: InsetGroupedDecorationAttributesAttributes]()
    private let cornerDecorationViewKind = "_kCornerDecorationViewKind"
    
    private var contentSize = CGSize.zero
    
    // MARK: =
    
    override public init() {
        super.init()
        p_didInitialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: =
    
    private func p_didInitialize() {
        register(InsetGroupedDecorationAttributesView.self, forDecorationViewOfKind: cornerDecorationViewKind)
    }
}

// MARK: =

extension CollectionInsetGroupedLayout {
    
    open override var collectionViewContentSize: CGSize {
        contentSize
    }
    
    open override class var layoutAttributesClass: AnyClass {
        return CollectionInsetGroupedLayoutAttributes.self
    }
    
    open override func prepare() {
        super.prepare()
        var attributesMap = [Int: InsetGroupedDecorationAttributesAttributes]()
        var contentSize = CGSize.zero
        defer {
            decorations = attributesMap
            self.contentSize = contentSize
        }
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return
        }
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            if !delegate.collectionView(collectionView, shouldShowInsetGroupedAt: section) {
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
            
            let groupedInsets = delegate.collectionView(collectionView, insetGroupedInsetsAt: section)
            
            if scrollDirection == .horizontal {
                x = sectionFrame.minX + groupedInsets.left
                y = inset.top + groupedInsets.top
                w = sectionFrame.width - (groupedInsets.left + groupedInsets.right)
                h = containerSize.height - inset.top - inset.bottom - (groupedInsets.top + groupedInsets.bottom)
            } else {
                x = inset.left + groupedInsets.left
                y = sectionFrame.minY + groupedInsets.top
                w = containerSize.width - inset.left - inset.right - (groupedInsets.left + groupedInsets.right)
                h = sectionFrame.height - (groupedInsets.top + groupedInsets.bottom)
            }
            
            let attributes = InsetGroupedDecorationAttributesAttributes(
                forDecorationViewOfKind: cornerDecorationViewKind,
                with: .init(item: 0, section: section)
            )
            attributes.frame = .init(x: x, y: y, width: w, height: h)
            attributes.zIndex = -1
            attributes.color = delegate.collectionView(collectionView, insetGroupedBackgroundColorAt: section) ?? .clear
            attributes.cornerRadius = delegate.collectionView(collectionView, insetGroupedCornerRadiusAt: section)
            attributes.borderWidth = delegate.collectionView(collectionView, insetGroupedBorderWidthAt: section)
            attributes.borderColor = delegate.collectionView(collectionView, insetGroupedBorderColorAt: section)
            attributesMap[section] = attributes
            do {
                let cornerRadius = delegate.collectionView(collectionView, insetGroupedCornerRadiusAt: section)
                if numberOfItems == 1 {
                    if let attributes = layoutAttributesForItem(at: .init(item: 0, section: section)) as? CollectionInsetGroupedLayoutAttributes {
                        attributes.cornerRadius = cornerRadius
                        attributes.maskedCorners = .inner.all
                    }
                } else {
                    if let attributes = layoutAttributesForItem(at: .init(item: 0, section: section)) as? CollectionInsetGroupedLayoutAttributes {
                        attributes.cornerRadius = cornerRadius
                        if scrollDirection == .vertical {
                            attributes.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        } else {
                            attributes.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                        }
                    }
                    if let attributes = layoutAttributesForItem(at: .init(item: numberOfItems - 1, section: section)) as? CollectionInsetGroupedLayoutAttributes {
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

private final class InsetGroupedDecorationAttributesAttributes: UICollectionViewLayoutAttributes {
    
    var color: UIColor = .white
    var cornerRadius: CGFloat = 10.0
    var borderWidth: CGFloat = 0
    var borderColor: UIColor?
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! InsetGroupedDecorationAttributesAttributes
        copy.color = color
        copy.cornerRadius = cornerRadius
        copy.borderWidth = borderWidth
        copy.borderColor = borderColor
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? InsetGroupedDecorationAttributesAttributes else {
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

private final class InsetGroupedDecorationAttributesView: UICollectionReusableView {
    
    // MARK: =
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: =
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? InsetGroupedDecorationAttributesAttributes else {
            return
        }
        backgroundColor = attributes.color
        layer.cornerRadius = attributes.cornerRadius
        layer.borderWidth = attributes.borderWidth
        layer.borderColor = attributes.borderColor?.cgColor
    }
    
    // MARK: =
    
    private func p_didInitialize() {
        clipsToBounds = true
    }
}
