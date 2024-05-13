//
//  UIImage+FSCollectionKit.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

extension FSCollectionInternalWrapper where Base: UIImage {
    
    /// 读取 `.../FSCollectionKit.bundle` / `.../FSCollectionKit.bundle/Assets.car` 下的图片资源。
    static func image(named name: String?) -> UIImage? {
        guard let name = name, !name.isEmpty else {
            return nil
        }
        if let path = Bundle(for: FSCollectionKitInternalBundle.self).path(forResource: "FSCollectionKit", ofType: "bundle") {
            if let bundle = Bundle(path: path) {
                return UIImage(named: name, in: bundle, compatibleWith: nil)
            }
        }
        return nil
    }
}

private class FSCollectionKitInternalBundle {}
