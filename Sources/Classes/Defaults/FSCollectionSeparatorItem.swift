//
//  FSCollectionSeparatorItem.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// 分割线 item，无交互，用于模拟为分割线，默认高度为 10。
open class FSCollectionSeparatorItem: FSCollectionItem {
    
    public override init() {
        super.init()
        size = .init(width: 10.0, height: 10.0)
        cellType = FSCollectionSeparatorCell.self
        shouldSelect = false
        shouldDeselect = false
        shouldHighlight = false
    }
}

private class FSCollectionSeparatorCell: UICollectionViewCell {
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Private
    
    /// Invoked after initialization.
    private func p_didInitialize() {
        let separator = _FSSeparatorView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[separator]|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: ["separator" : separator]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator]|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: ["separator" : separator]))
    }
}
