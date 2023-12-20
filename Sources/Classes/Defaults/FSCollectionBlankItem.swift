//
//  FSCollectionBlankItem.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

/// 空白 item，背景透明，无交互，用于占位。
open class FSCollectionBlankItem: FSCollectionItem {

    public override init() {
        super.init()
        cellType = FSCollectionBlankCell.self
        shouldSelect = false
        shouldDeselect = false
        shouldHighlight = false
    }
}

private class FSCollectionBlankCell: UICollectionViewCell {
    
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
