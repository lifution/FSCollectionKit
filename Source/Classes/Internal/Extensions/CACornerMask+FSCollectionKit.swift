//
//  CACornerMask+FSCollectionKit.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2024/11/20.
//  Copyright © 2024 VincentLee. All rights reserved.
//

import Foundation

extension FSCollectionInternalWrapper where Base == CACornerMask {
    
    static var all: CACornerMask {
        return [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
    }
}
