//
//  FSCollectionCellRenderable.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public protocol FSCollectionCellRenderable {
    func render(with item: FSCollectionItemConvertable)
    func willDisplay()
    func didEndDisplaying()
}

public extension FSCollectionCellRenderable {
    func render(with item: FSCollectionItemConvertable) {}
    func willDisplay() {}
    func didEndDisplaying() {}
}
