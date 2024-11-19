//
//  FSCollectionViewLayout.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/11/8.
//  Copyright © 2024 Vincent. All rights reserved.
//

import UIKit
import Foundation

open class FSCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: Properties/Open
    
    open var isTapEnabled = false
    open var onDidTapHandler: ((_ tap: UITapGestureRecognizer) -> Void)?
    
    // MARK: Properties/Private
    
    private let tap = UITapGestureRecognizer()
    private let tapDelegator = _TapGestureDelegator()
    
    // MARK: Initialization
    
    override public init() {
        super.init()
        p_didInitialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Override
    
    open override func prepare() {
        super.prepare()
        if let view = collectionView, view !== tap.view {
            view.addGestureRecognizer(tap)
        }
        do {
            /// Fix:
            /// UICollectionView 调用 `insertItems` 刷新 UI 时，
            /// collectionView.contentSize 和 layout.collectionViewContentSize 会不同步。
            collectionView?.contentSize = collectionViewContentSize
        }
    }
    
    // MARK: Private
    
    private func p_didInitialize() {
        tapDelegator.layout = self
        tap.delegate = tapDelegator
        tap.addTarget(self, action: #selector(p_tapAction))
    }
    
    @objc
    private func p_tapAction() {
        onDidTapHandler?(tap)
    }
    
    fileprivate func p_gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard isTapEnabled, let view = collectionView else {
            return false
        }
        if let attributes = layoutAttributesForElements(in: view.bounds) {
            let point = gestureRecognizer.location(in: view)
            if let _ = attributes.first(where: { $0.frame.contains(point) }) {
                return false
            }
        }
        return true
    }
}

private final class _TapGestureDelegator: NSObject, UIGestureRecognizerDelegate {
    weak var layout: FSCollectionViewFlowLayout?
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return layout?.p_gestureRecognizerShouldBegin(gestureRecognizer) ?? true
    }
}
