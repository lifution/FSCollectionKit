//
//  UIScreen+FSCollectionKit.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Foundation

extension FSCollectionInternalWrapper where Base: UIScreen {
    
    static var scale: CGFloat {
        return _UIScreenConsts.scale
    }
    
    static var pixelOne: CGFloat {
        return _UIScreenConsts.pixelOne
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var portraitWidth: CGFloat {
        return _UIScreenConsts.portraitWidth
    }
    
    static var portraitHeight: CGFloat {
        return _UIScreenConsts.portraitHeight
    }
}

private struct _UIScreenConsts {
    
    static let scale: CGFloat = {
        return UIScreen.main.scale
    }()
    
    static let pixelOne: CGFloat = {
        return  1.0 / UIScreen.main.scale
    }()
    
    static let portraitWidth: CGFloat = {
        let bounds = UIScreen.main.bounds
        return min(bounds.width, bounds.height)
    }()
    
    static let portraitHeight: CGFloat = {
        let bounds = UIScreen.main.bounds
        return max(bounds.width, bounds.height)
    }()
}
