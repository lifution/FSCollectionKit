//
//  PublicNamespace.swift
//  FSCollectionKit
//
//  Created by Sheng on 2024/1/16.
//  Copyright © 2024 Sheng. All rights reserved.
//

import UIKit

public struct FSCollectionKitWrapper<Base> {
    let base: Base
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

public protocol FSCollectionKitCompatible: AnyObject {}
extension FSCollectionKitCompatible {
    public static var fsck: FSCollectionKitWrapper<Self>.Type {
        get { return FSCollectionKitWrapper<Self>.self }
        set {}
    }
    public var fsck: FSCollectionKitWrapper<Self> {
        get { return FSCollectionKitWrapper(self) }
        set {}
    }
}

extension UICollectionView: FSCollectionKitCompatible {}
