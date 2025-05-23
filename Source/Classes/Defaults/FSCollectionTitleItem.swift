//
//  FSCollectionTitleItem.swift
//  FSCollectionKit
//
//  Created by Sheng on 2024/5/15.
//  Copyright © 2024 Vincent. All rights reserved.
//

import UIKit

/// 该类是带标题的 item 通用类，通常情况下，该类可以应付绝大多数带标题的场景。
///
/// - 该类支持一下功能：
///   * 在标题的左边设置图标
///   * 设置标题
///   * 设置副标题
///   * 设置右边副标题
///   * 右边 accessory 有默认的样式：AccessoryType
/// - ⚠️ 外部在调用 `updateLayout` 方法之前必须要设置一个有效的 `containerSize`，否则将无法计算各控件的布局。
/// - 该类仅适用于**垂直方向**滚动的 UICollectionView。
/// - 当部分与 UI 相关的属性更新后（比如 containerSize、image、title、subTitle等），需外部手动
///   调用 `updateLayout()` 方法，内部不会自动更新。
/// - 如果子类需要自定义 cellType 则 cellType 必须继承于 FSCollectionTitleCell，否则可能会出现 UI 不生效的问题。
///
/// > 该 item 的 UI 样式如下：
/// ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
/// │-<contentInset.left>-[icon]-<iconSpacing>-[title]-<titleSpacing>-[subTitle]         [detail]-<detailSpacing>-[accessory]-<contentInset.right>-│
/// └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
///
open class FSCollectionTitleItem: FSCollectionLayoutableItem {
    
    /// 右边附件类型。
    public enum AccessoryType {
        /// 无
        case none
        /// 箭头
        case detail
    }
    
    /*
     > 以下属性，凡是有所改动，都需要调用 `updateLayout()` 方法，否则布局不会更新。
     */
    
    // MARK: Properties/Public
    
    /// 是否自动计算 item 高度，默认为 true。
    ///
    /// - Important:
    ///   * 如果需要固定 item 的高度为某个数值，则需要设置该属性为 false。
    ///   * 当该属性为 false 时，在布局时会忽略 `contentInset` 的 top 和 bottom 参数。
    ///   * 当该属性为 true 时，所有控件都会自动垂直居中，当该属性为 false 时，所有控件
    ///     按照 contentInset 偏移。
    ///
    public var automaticallyAdjustsHeight = true
    
    /// icon 和 title 之间的间距
    ///
    /// - 如果 icon 不存在，则该属性无效。
    ///
    public var iconSpacing: CGFloat = 5.0
    
    /// title 和 subTitle 之间的间距
    ///
    /// - 如果 title 不存在，则该属性无效。
    ///
    public var titleSpacing: CGFloat = 5.0
    
    /// detail 和 accessory 之间的距离。
    ///
    /// - 如果 detail / accessory 不存在，则该属性无效。
    ///
    public var detailSpacing: CGFloat = 5.0
    
    /// 标题左边的图标
    public var icon: UIImage?
    
    /// 标题
    public var title: String?
    
    /// 标题字体
    public var titleFont: UIFont? = .boldSystemFont(ofSize: 16.0)
    
    /// 标题文本颜色
    public var titleColor: UIColor? = .black
    
    /// 副标题
    public var subTitle: String?
    
    /// 副标题字体
    public var subTitleFont: UIFont? = .systemFont(ofSize: 14.0)
    
    /// 副标题文本颜色
    public var subTitleColor: UIColor? = .gray
    
    /// 右边 detail 标题
    public var detail: String?
    
    /// 右边 detail 标题字体
    public var detailFont: UIFont? = .systemFont(ofSize: 14.0)
    
    /// 右边 detail 标题文本颜色
    public var detailColor: UIColor? = .black
    
    /// 右边附件类型，默认为 `.none`。
    ///
    /// - Note:
    ///   * 当 accessoryView 属性不为 nil 时，当前属性无效。
    ///
    public var accessoryType: FSCollectionTitleItem.AccessoryType = .none
    
    /// accessoryType 为 `.detail` 时显示的图标，默认为一个箭头的图标。
    /// 当 ``FSCollectionTitleItem/isRTLLanguage`` 为 true 时会自动翻转该图标。
    ///
    public var accessoryDetailIcon: UIImage? = .inner.image(named: "icon_accessory_detail")
    
    public var iconFrame: CGRect = .zero
    public var titleFrame: CGRect = .zero
    public var subTitleFrame: CGRect = .zero
    public var detailFrame: CGRect = .zero
    /// 该属性既可以表示自定义 accessoryView 的 frame，也可表示默认的
    /// accessoryView 的 frame，自定义和默认的 accessoryView 有且只有
    /// 一个会生效，因此用一个 accessoryFrame 表示即可。
    public var accessoryFrame: CGRect = .zero
    public var separatorFrame: CGRect = .zero
    
    public var titleText: NSAttributedString?
    public var subTitleText: NSAttributedString?
    public var detailText: NSAttributedString?
    
    public var isIconHidden = true
    public var isTitleHidden = true
    public var isSubTitleHidden = true
    public var isDetailHidden = true
    public var isAccessoryHidden = true
    public var isAccessoryDetailHidden = true
    
    /// 是否适配 RTL，默认为 false。
    /// 需在调用 ``updateLayout`` 方法之前设置，否则无效。
    /// 子类则需要在调用 ``super.updateLayout()`` 之前设置。
    public var isRTLLanguage = false
    
    // MARK: Initialization
    
    public override init() {
        super.init()
        size = .init(width: 0.0, height: 44.0)
        cellType = FSCollectionTitleCell.self
    }
    
    // MARK: Override
    
    /// 更新布局。
    ///
    /// - 当修改了与 UI 相关的属性后，必须调用该方法，否则改动不会生效。
    ///
    open override func updateLayout() {
        super.updateLayout()
        
        size.width = containerSize.width - sectionInset.inner.horizontalValue()
        let layoutWidth = size.width - contentInset.inner.horizontalValue()
        
        guard layoutWidth > 0 else {
            iconFrame = .zero
            titleFrame = .zero
            subTitleFrame = .zero
            detailFrame = .zero
            accessoryFrame = .zero
            separatorFrame = .zero
            titleText = nil
            subTitleText = nil
            detailText = nil
            isIconHidden = true
            isTitleHidden = true
            isSubTitleHidden = true
            isDetailHidden = true
            isAccessoryHidden = true
            isAccessoryDetailHidden = true
            return
        }
        
        isIconHidden = icon == nil
        isTitleHidden = (title?.isEmpty ?? true) || (titleColor == nil)
        isSubTitleHidden = (subTitle?.isEmpty ?? true) || (subTitleColor == nil)
        isDetailHidden = (detail?.isEmpty ?? true) || (detailColor == nil)
        isAccessoryHidden = accessoryType == .none
        isAccessoryDetailHidden = accessoryType != .detail
        
        // icon
        do {
            iconFrame = .zero
            let x = contentInset.left
            let size: CGSize
            if isIconHidden {
                size = .zero
            } else {
                size = icon?.size ?? .zero
            }
            iconFrame.size = size
            iconFrame.origin.x = x
        }
        // accessory
        do {
            accessoryFrame = .zero
            let size: CGSize
            if isAccessoryHidden {
                size = .zero
            } else {
                if !isAccessoryDetailHidden {
                    size = accessoryDetailIcon?.size ?? .zero
                } else {
                    size = .zero
                }
            }
            accessoryFrame.size = size
            accessoryFrame.origin.x = self.size.width - contentInset.right - size.width
        }
        // title
        do {
            titleText = nil
            titleFrame = .zero
            let x: CGFloat = {
                if isIconHidden {
                    return contentInset.left
                }
                return iconFrame.maxX + iconSpacing
            }()
            let size: CGSize
            if let text = title, !text.isEmpty {
                let maxLayoutWidth = layoutWidth - contentInset.right - x - {
                    var spacing: CGFloat = 0.0
                    if !isAccessoryHidden {
                        // accessory
                        spacing += accessoryFrame.width
                    }
                    if !isDetailHidden {
                        if !isAccessoryHidden {
                            spacing += detailSpacing
                        }
                        // 预留给 detail 的空间
                        let attr_text = NSAttributedString.inner.attributedString(string: detail ?? "", font: detailFont)
                        let size = attr_text.inner.size(limitedWidth: 1000.0)
                        spacing += min(size.width, 50.0)
                        spacing += 8.0 // detail left spacing
                    }
                    if !isSubTitleHidden {
                        // 预留给 subTitle 的空间
                        let attr_text = NSAttributedString.inner.attributedString(string: subTitle ?? "", font: subTitleFont)
                        let size = attr_text.inner.size(limitedWidth: 1000.0)
                        spacing += min(size.width, 50.0)
                        spacing += titleSpacing
                    }
                    return spacing
                }()
                let attr_text = NSAttributedString.inner.attributedString(string: text, font: titleFont, color: titleColor)
                titleText = attr_text
                size = attr_text.inner.size(limitedWidth: maxLayoutWidth)
            } else {
                size = .zero
            }
            titleFrame.size = size
            titleFrame.origin.x = x
        }
        // subTitle
        do {
            subTitleText = nil
            subTitleFrame = .zero
            let x: CGFloat = {
                if !isTitleHidden {
                    return titleFrame.maxX + titleSpacing
                }
                if !isIconHidden {
                    return iconFrame.maxX + iconSpacing
                }
                return contentInset.left
            }()
            let size: CGSize
            if let text = subTitle, !text.isEmpty {
                let maxLayoutWidth = layoutWidth - contentInset.right - x - {
                    var spacing: CGFloat = 0.0
                    if !isAccessoryHidden {
                        // accessory
                        spacing += accessoryFrame.width
                    }
                    if !isDetailHidden {
                        if !isAccessoryHidden {
                            spacing += detailSpacing
                        }
                        // 预留给 detail 的空间
                        let attr_text = NSAttributedString.inner.attributedString(string: detail ?? "", font: detailFont)
                        let size = attr_text.inner.size(limitedWidth: 1000.0)
                        spacing += min(size.width, 50.0)
                        spacing += 8.0 // detail left spacing
                    }
                    return spacing
                }()
                let attr_text = NSAttributedString.inner.attributedString(string: text, font: subTitleFont, color: subTitleColor)
                subTitleText = attr_text
                size = attr_text.inner.size(limitedWidth: maxLayoutWidth)
            } else {
                size = .zero
            }
            subTitleFrame.size = size
            subTitleFrame.origin.x = x
        }
        // detail
        do {
            detailText = nil
            detailFrame = .zero
            let x: CGFloat
            let size: CGSize
            if !isDetailHidden, let text = detail {
                let spacing = isAccessoryHidden ? 0.0 : detailSpacing
                let maxLayoutWidth = accessoryFrame.minX - spacing - {
                    var spacing: CGFloat = 0.0
                    if !isSubTitleHidden {
                        spacing += subTitleFrame.maxX
                        spacing += 8.0
                    } else if !isTitleHidden {
                        spacing += titleFrame.maxX
                        spacing += 8.0
                    } else if !isIconHidden {
                        spacing += iconFrame.maxX
                        spacing += 8.0
                    } else {
                        spacing += contentInset.left
                    }
                    return spacing
                }()
                let attr_text = NSAttributedString.inner.attributedString(string: text,
                                                                          font: detailFont,
                                                                          color: detailColor,
                                                                          textAlignment: .right)
                detailText = attr_text
                size = attr_text.inner.size(limitedWidth: maxLayoutWidth)
                x = accessoryFrame.minX - spacing - size.width
            } else {
                x = accessoryFrame.minX
                size = .zero
            }
            detailFrame.size = size
            detailFrame.origin.x = x
        }
        do {
            // 计算高度
            if automaticallyAdjustsHeight {
                let contentHeight = [
                    iconFrame.height,
                    titleFrame.height,
                    subTitleFrame.height,
                    detailFrame.height,
                    accessoryFrame.height
                ].max() ?? 0.0
                size.height = contentHeight + contentInset.inner.verticalValue()
            }
            iconFrame.origin.y = _FSFloorFlat((size.height - iconFrame.height) / 2)
            titleFrame.origin.y = _FSFloorFlat((size.height - titleFrame.height) / 2)
            subTitleFrame.origin.y = _FSFloorFlat((size.height - subTitleFrame.height) / 2)
            detailFrame.origin.y = _FSFloorFlat((size.height - detailFrame.height) / 2)
            accessoryFrame.origin.y = _FSFloorFlat((size.height - accessoryFrame.height) / 2)
        }
        do {
            let x = separatorInset.left
            let w = size.width - separatorInset.right - x
            let h = max(0, separatorHeight)
            let y = size.height - h
            separatorFrame = .init(x: x, y: y, width: w, height: h)
        }
        if isRTLLanguage {
            iconFrame = iconFrame.inner.mirrorsForRTLLanguage(with: size.width)
            titleFrame = titleFrame.inner.mirrorsForRTLLanguage(with: size.width)
            subTitleFrame = subTitleFrame.inner.mirrorsForRTLLanguage(with: size.width)
            detailFrame = detailFrame.inner.mirrorsForRTLLanguage(with: size.width)
            accessoryFrame = accessoryFrame.inner.mirrorsForRTLLanguage(with: size.width)
            separatorFrame = separatorFrame.inner.mirrorsForRTLLanguage(with: size.width)
            accessoryDetailIcon = accessoryDetailIcon?.imageFlippedForRightToLeftLayoutDirection()
        }
    }
}


open class FSCollectionTitleCell: FSCollectionLayoutableCell {
    
    // MARK: Properties/Public
    
    public let iconView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    public let subTitleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    public let detailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    public let accessoryDetailView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        return view
    }()
    
    // MARK: Override
    
    open override func didInitialize() {
        super.didInitialize()
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(accessoryDetailView)
    }
    
    open override func render(with item: FSCollectionItemConvertable) {
        super.render(with: item)
        guard let item = item as? FSCollectionTitleItem else { return }
        
        iconView.frame = item.iconFrame
        titleLabel.frame = item.titleFrame
        subTitleLabel.frame = item.subTitleFrame
        detailLabel.frame = item.detailFrame
        accessoryDetailView.frame = item.accessoryFrame
        
        iconView.isHidden = item.isIconHidden
        titleLabel.isHidden = item.isTitleHidden
        subTitleLabel.isHidden = item.isSubTitleHidden
        detailLabel.isHidden = item.isDetailHidden
        accessoryDetailView.isHidden = item.isAccessoryDetailHidden
        
        iconView.image = item.icon
        titleLabel.attributedText = item.titleText
        subTitleLabel.attributedText = item.subTitleText
        detailLabel.attributedText = item.detailText
        accessoryDetailView.image = item.accessoryDetailIcon
    }
}
