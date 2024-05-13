//
//  NSAttributedString+FSCollectionKit.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit
import Foundation

extension FSCollectionInternalWrapper where Base: NSAttributedString {
    
    // MARK: Static
    
    static func attributedString(string: String?,
                                 font: UIFont? = nil,
                                 color: UIColor? = nil,
                                 lineSpacing: CGFloat = 0.0,
                                 kernSpacing: CGFloat = 0.0,
                                 textAlignment: NSTextAlignment = .left) -> Base {
        let text = string ?? ""
        let font = font ?? .systemFont(ofSize: 16.0)
        let color = color ?? .black
        
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font : font,
            .kern : kernSpacing,
            .paragraphStyle : style,
            .foregroundColor : color
        ]
        
        return Base(string: text, attributes: attributes)
    }
    
    static func size(of attributedString: NSAttributedString?, limitedSize: CGSize? = .zero, limitedNumberOfLines: Int = 0) -> CGSize {
        guard let att_string = attributedString, !att_string.string.isEmpty else {
            return .zero
        }
        let numberOfLines = max(limitedNumberOfLines, 0)
        let constraints: CGSize = {
            if let size = limitedSize, size.width > 0, size.height > 0 {
                return .init(width: ceil(size.width), height: ceil(size.height))
            }
            return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        }()
        let size = att_string.boundingRect(with: constraints,
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           context: nil).size
        return .init(width: ceil(size.width), height: ceil(size.height))
    }
    
    // MARK: Instance
    
    func size(limitedWidth: CGFloat, limitedNumberOfLines: Int = 0) -> CGSize {
        let constraint = CGSize(width: limitedWidth, height: CGFloat.greatestFiniteMagnitude)
        return size(limitedSize: constraint, limitedNumberOfLines: limitedNumberOfLines)
    }
    
    func size(limitedSize: CGSize, limitedNumberOfLines: Int = 0) -> CGSize {
        return NSAttributedString.inner.size(of: base, limitedSize: limitedSize, limitedNumberOfLines: limitedNumberOfLines)
    }
}
