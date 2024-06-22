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
///   * 支持外部自定义 accessory 控件。
/// - ⚠️ 外部在调用 `updateLayout` 方法之前必须要设置一个有效的 `containerSize`，否则将无法计算各控件的布局。
/// - 当外部自定义了 accessory 控件之后，自带的 accessoryType 自动无效。
/// - 该类仅适用于**垂直方向**滚动的 UICollectionView。
/// - 当部分与 UI 相关的属性更新后（比如 containerSize、image、title、subTitle等），需外部手动
///   调用 `updateLayout()` 方法，内部不会自动更新。
/// - 如果子类需要自定义 cellType 则 cellType 必须继承于 FSCollectionTitleCell，否则可能会出现 UI 不生效的问题。
///
/// > 该 item 的 UI 样式如下：
/// ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
/// │-<contentInset.left>-[icon]-<iconSpacing>-[title]-<titleSpacing>-[subTitle]          [detail]-<titleSpacing>-[accessory]-<contentInset.right>-│
/// └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
///
open class FSCollectionTitleItem: FSCollectionItem, FSCollectionItemLayoutable {
    
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
    
    // MARK: Properties/FSCollectionItemLayoutable
    
    /// item 所在 section 的 inset，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///
    open var sectionInset: UIEdgeInsets = .zero
    
    /// item 内容四边边距，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///   * 当 `automaticallyAdjustsHeight` 为 false 时，则会忽略该属性的 top 和 bottom 参数。
    ///
    open var contentInset: UIEdgeInsets = .init(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    
    /// item 所在 UICollectionView 的 size，由外部赋值，默认为 `.zero`。
    ///
    /// - Note:
    ///   * 设置该属性不会自动调用 `updateLayout()` 方法，更新时机由外部控制。
    ///
    open var containerSize: CGSize = .zero
    
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
    public var accessoryDetailIcon: UIImage? = .inner.image(named: "icon_accessory_detail")
    
    /// 自定义右边附件视图，当 FSCollectionTitleItem.AccessoryType 无法满足需求时，
    /// 可使用该属性自定义视图。
    ///
    /// - Note:
    ///   * 当该属性不为 nil 时，accessoryType 无效。
    ///   * 当外部需要实现该属性时，则**必须**设置属性 `accessoryViewSize`，否则该自定义的
    ///     视图的 frame 会默认为 `.zero`。
    ///
    public var accessoryView: UIView?
    
    /// 自定义的 accessoryView 的 size，默认为 `.zero`。
    ///
    /// - 如果外部定义了 accessoryView，则必须调整 accessoryViewSize 为
    ///   自定义 accessoryView 的 size，否则 accessoryView 的 size 默认为 `.zero`。
    /// - FSCollectionTitleItem 的所有控件都是默认垂直居中的，因此外部只需要
    ///   为自定义 accessoryView 设置 size 即可。
    /// - 如果更复杂的 accessoryView 需求，则不建议继续使用 FSCollectionTitleItem，
    ///   建议另外创建自定义的 FSCollectionItem。
    ///
    public var accessoryViewSize: CGSize = .zero
    
    /// 是否隐藏底部分割线，默认为 true。
    public var isSeparatorHidden = true
    
    /// 底部分割线颜色
    public var separatorColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
    
    /// 底部分割线缩进
    public var separatorInset: UIEdgeInsets = .zero
    
    public var separatorHeight: CGFloat = 1 / UIScreen.main.scale
    
    // MARK: Properties/Fileprivate
    
    fileprivate private(set) var iconFrame: CGRect = .zero
    fileprivate private(set) var titleFrame: CGRect = .zero
    fileprivate private(set) var subTitleFrame: CGRect = .zero
    fileprivate private(set) var detailFrame: CGRect = .zero
    /// 该属性既可以表示自定义 accessoryView 的 frame，也可表示默认的
    /// accessoryView 的 frame，自定义和默认的 accessoryView 有且只有
    /// 一个会生效，因此用一个 accessoryFrame 表示即可。
    fileprivate private(set) var accessoryFrame: CGRect = .zero
    fileprivate private(set) var separatorFrame: CGRect = .zero
    
    fileprivate private(set) var titleText: NSAttributedString?
    fileprivate private(set) var subTitleText: NSAttributedString?
    fileprivate private(set) var detailText: NSAttributedString?
    
    fileprivate private(set) var r_accessoryDetailIcon: UIImage?
    
    fileprivate private(set) var isIconHidden = true
    fileprivate private(set) var isTitleHidden = true
    fileprivate private(set) var isSubTitleHidden = true
    fileprivate private(set) var isDetailHidden = true
    fileprivate private(set) var isAccessoryHidden = true
    fileprivate private(set) var isAccessoryDetailHidden = true
    
    // MARK: Initialization
    
    public override init() {
        super.init()
        size = .init(width: 0.0, height: 44.0)
        cellType = FSCollectionTitleCell.self
    }
    
    // MARK: Properties/FSCollectionItemLayoutable
    
    /// 更新布局。
    ///
    /// - 当修改了与 UI 相关的属性后，必须调用该方法，否则改动不会生效。
    ///
    open func updateLayout() {
        
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
            r_accessoryDetailIcon = nil
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
        isAccessoryHidden = accessoryView == nil && accessoryType == .none
        
        do {
            r_accessoryDetailIcon = nil
            isAccessoryDetailHidden = {
                if let _ = accessoryView {
                    return true
                }
                if accessoryType == .detail {
                    r_accessoryDetailIcon = accessoryDetailIcon
                    return false
                }
                return true
            }()
        }
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
                if let _ = accessoryView {
                    size = accessoryViewSize
                } else {
                    if !isAccessoryDetailHidden {
                        size = r_accessoryDetailIcon?.size ?? .zero
                    } else {
                        size = .zero
                    }
                }
            }
            accessoryFrame.size = size
            accessoryFrame.origin.x = self.size.width - contentInset.right - size.width
        }
        // detail
        do {
            detailText = nil
            detailFrame = .zero
            let x: CGFloat
            let size: CGSize
            if !isDetailHidden, let text = detail {
                let spacing = isAccessoryHidden ? 0.0 : detailSpacing
                let maxLayoutWidth = accessoryFrame.minX - spacing - layoutWidth / 2
                let attr_text = NSAttributedString.inner.attributedString(string: text, font: detailFont, color: detailColor)
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
                let maxLayoutWidth = detailFrame.minX - x - {
                    var spacing: CGFloat = 0.0
                    if !isDetailHidden {
                        spacing += 5.0
                    } else if !isAccessoryHidden {
                        // accessory left spacing
                        spacing += 5.0
                    }
                    if !isSubTitleHidden {
                        // 预留给 subTitle 的空间
                        let attr_text = NSAttributedString.inner.attributedString(string: subTitle ?? "", font: subTitleFont)
                        let size = attr_text.inner.size(limitedWidth: 1000.0)
                        spacing += min(size.width, 50.0) + titleSpacing
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
                let maxLayoutWidth = detailFrame.minX - x - {
                    var spacing: CGFloat = 0.0
                    if !isDetailHidden {
                        spacing += 5.0
                    } else if !isAccessoryHidden {
                        // accessory left spacing
                        spacing += 5.0
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
    }
    
    // MARK: Open
    
    /// 渲染自定义的 accessory view，如果没有自定义，则不会回调该方法。
    open func renderAccessoryView() {
        
    }
}


open class FSCollectionTitleCell: UICollectionViewCell, FSCollectionCellRenderable {
    
    // MARK: Properties/Private
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private let accessoryDetailView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        return view
    }()
    
    private let separatorView = _FSSeparatorView()
    
    private weak var accessoryView: UIView?
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Override
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bringSubviewToFront(separatorView)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        iconView.isHidden = true
        accessoryDetailView.isHidden = true
        accessoryView?.removeFromSuperview()
        accessoryView = nil
    }
    
    // MARK: Private
    
    /// Invoked after initialization.
    private func p_didInitialize() {
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(accessoryDetailView)
        contentView.addSubview(separatorView)
    }
    
    // MARK: FSCollectionCellRenderable
    
    open func render(with item: any FSCollectionItemConvertable) {
        guard let item = item as? FSCollectionTitleItem else { return }
        
        iconView.frame = item.iconFrame
        titleLabel.frame = item.titleFrame
        subTitleLabel.frame = item.subTitleFrame
        detailLabel.frame = item.detailFrame
        accessoryDetailView.frame = item.accessoryFrame
        separatorView.frame = item.separatorFrame
        
        iconView.isHidden = item.isIconHidden
        titleLabel.isHidden = item.isTitleHidden
        subTitleLabel.isHidden = item.isSubTitleHidden
        detailLabel.isHidden = item.isDetailHidden
        accessoryDetailView.isHidden = item.isAccessoryDetailHidden
        separatorView.isHidden = item.isSeparatorHidden
        
        iconView.image = item.icon
        titleLabel.attributedText = item.titleText
        subTitleLabel.attributedText = item.subTitleText
        detailLabel.attributedText = item.detailText
        accessoryDetailView.image = item.r_accessoryDetailIcon
        separatorView.color = item.separatorColor
        
        if let view = item.accessoryView {
            view.frame = item.accessoryFrame
            addSubview(view)
            accessoryView = view
            item.renderAccessoryView()
        }
    }
}
