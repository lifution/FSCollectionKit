//
//  CollectionReusableCell.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/11/20.
//

import UIKit
import Foundation

open class CollectionReusableCell: UICollectionViewCell {
    
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
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        /// Fix: ``layoutAttributes.zIndex`` not work.
        layer.zPosition = CGFloat(layoutAttributes.zIndex)
        if let attributes = layoutAttributes as? CollectionInsetGroupLayoutAttributes {
            layer.cornerRadius = attributes.cornerRadius
            layer.maskedCorners = attributes.maskedCorners
        }
    }
    
    // MARK: Open
    
    open func didInitialize() {}
    
    // MARK: Private
    
    private func p_didInitialize() {
        defer {
            didInitialize()
        }
        clipsToBounds = true
    }
}
