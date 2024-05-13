//
//  InternalNamespace.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

struct FSCollectionInternalWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol FSCollectionInternalCompatible: AnyObject {}
extension FSCollectionInternalCompatible {
    static var inner: FSCollectionInternalWrapper<Self>.Type {
        get { return FSCollectionInternalWrapper<Self>.self }
        set {}
    }
    var inner: FSCollectionInternalWrapper<Self> {
        get { return FSCollectionInternalWrapper(self) }
        set {}
    }
}

protocol FSCollectionInternalCompatibleValue {}
extension FSCollectionInternalCompatibleValue {
    static var inner: FSCollectionInternalWrapper<Self>.Type {
        get { return FSCollectionInternalWrapper<Self>.self }
        set {}
    }
    var inner: FSCollectionInternalWrapper<Self> {
        get { return FSCollectionInternalWrapper(self) }
        set {}
    }
}

extension UIColor: FSCollectionInternalCompatible {}
extension UIScreen: FSCollectionInternalCompatible {}
extension UIImage: FSCollectionInternalCompatible {}
extension NSAttributedString: FSCollectionInternalCompatible {}

extension CGRect: FSCollectionInternalCompatibleValue {}
extension CGSize: FSCollectionInternalCompatibleValue {}
extension CGPoint: FSCollectionInternalCompatibleValue {}
extension CGFloat: FSCollectionInternalCompatibleValue {}
extension UIEdgeInsets: FSCollectionInternalCompatibleValue {}
