//
//  FSCollectionHeaderFooterViewRenderable.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

public protocol FSCollectionHeaderFooterViewRenderable {
    func render(with headerFooter: FSCollectionHeaderFooterConvertable)
    func willDisplay()
    func didEndDisplaying()
}

public extension FSCollectionHeaderFooterViewRenderable {
    func render(with headerFooter: FSCollectionHeaderFooterConvertable) {}
    func willDisplay() {}
    func didEndDisplaying() {}
}
