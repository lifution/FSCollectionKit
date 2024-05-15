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
///   * 右边 accessory 有默认的样式：AccessoryType
///   * 支持外部自定义 accessory 控件。
/// - 当外部自定义了 accessory 控件之后，自带的 accessoryType 自动无效。
/// - 该类仅适用于**垂直方向**滚动的 UICollectionView。
/// - 当部分与 UI 相关的属性更新后（比如 containerSize、image、title、subTitle等），
///   需外部手动调用 `updateLayout()` 方法，内部不会自动更新。
/// - 该类内部已默认适配了 dark mode 更新。
/// - 不建议更改 `cellType` (即使是子类也不建议更改该属性)，该类对应的 view 做了比较多的适配，
///   比如 reload 监听等操作，如果更改了 `cellType` 则可能会导致部分功能异常。
///
/// > 该 item 的 UI 样式如下：
/// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
/// │-<contentInset.left>-[icon]-<iconSpacing>-[title]-<titleSpacing>-[subTitle]             [accessory]-<contentInset.right>-│
/// └─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
///
open class FSCollectionTitleItem: FSCollectionItem {
    
    /// 右边附件类型。
    public enum AccessoryType {
        /// 无
        case none
        /// 箭头
        case detail
    }
    
    // MARK: Properties/Public/UI
    
    /*
     > 以下属性，凡是有所改动，都需要调用 `updateLayout()` 方法，否则不会生效。
     */
    
    /// item 所在容器的宽度。
    ///
    /// - 该 宽度 即 collection view 的 size。
    /// - 该属性有默认的初始值：当前设备的屏幕 size。
    /// - 如果 item 所在的 collection view 的宽度与初始值不一致，则外部必须调整该属性，否则 UI 会与预期不符。
    ///
    public var containerSize: CGSize = UIScreen.main.bounds.size
    
    /// 所在 section 的 inset。
    public var sectionInset: UIEdgeInsets = .zero
    
    /// 内容内边距。
    ///
    /// - 当 `automaticallyAdjustsHeight` 为 false 时，则会忽略该属性的 top 和 bottom 参数。
    ///
    public var contentInset: UIEdgeInsets = .init(top: 12.0, left: 16.0, bottom: 12.0, right: 16.0)
    
    /// 是否自动计算 item 高度，默认为 true。
    ///
    /// - Important:
    ///   * 如果需要固定 item 的高度为某个数值，则需要设置该属性为 false。
    ///   * 当该属性为 false 时，在布局时会忽略 `contentInset` 的 top 和 bottom 参数。
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
    /// 该属性既可以表示自定义 accessoryView 的 frame，也可表示默认的
    /// accessoryView 的 frame，自定义和默认的 accessoryView 有且只有
    /// 一个会生效，因此用一个 accessoryFrame 表示即可。
    fileprivate private(set) var accessoryFrame: CGRect = .zero
    fileprivate private(set) var separatorFrame: CGRect = .zero
    
    fileprivate private(set) var titleText: NSAttributedString?
    fileprivate private(set) var subTitleText: NSAttributedString?
    
    fileprivate private(set) var r_accessoryDetailIcon: UIImage?
    
    fileprivate private(set) var isIconHidden = true
    fileprivate private(set) var isTitleHidden = true
    fileprivate private(set) var isSubTitleHidden = true
    fileprivate private(set) var isAccessoryHidden = true
    fileprivate private(set) var isAccessoryDetailHidden = true
    
    // MARK: Initialization
    
    public override init() {
        super.init()
        size = .init(width: 0.0, height: 44.0)
        cellType = FSCollectionTitleCell.self
    }
    
    // MARK: Open
    
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
            accessoryFrame = .zero
            separatorFrame = .zero
            titleText = nil
            subTitleText = nil
            r_accessoryDetailIcon = nil
            isIconHidden = true
            isTitleHidden = true
            isSubTitleHidden = true
            isAccessoryHidden = true
            isAccessoryDetailHidden = true
            return
        }
        
        isIconHidden = icon == nil
        isTitleHidden = title?.isEmpty ?? true
        isSubTitleHidden = subTitle?.isEmpty ?? true
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
        // title
        do {
            titleText = nil
            titleFrame = .zero
            let x: CGFloat
            let size: CGSize
            if let text = title, !text.isEmpty {
                x = {
                    if isIconHidden {
                        return contentInset.left
                    }
                    return iconFrame.maxX + iconSpacing
                }()
                let color = titleColor
                let maxLayoutWidth = accessoryFrame.minX - x - {
                    var spacing: CGFloat = 0.0
                    if !isAccessoryHidden {
                        // accessory left spacing
                        spacing += 10.0
                    }
                    if !isSubTitleHidden {
                        // 预留给 subTitle 的空间
                        spacing += 50.0 + titleSpacing
                    }
                    return spacing
                }()
                let attr_text = NSAttributedString.inner.attributedString(string: text, font: titleFont, color: color)
                titleText = attr_text
                size = attr_text.inner.size(limitedWidth: maxLayoutWidth)
            } else {
                x = 0.0
                size = .zero
            }
            titleFrame.size = size
            titleFrame.origin.x = x
        }
        // subTitle
        do {
            subTitleText = nil
            subTitleFrame = .zero
            let x: CGFloat
            let size: CGSize
            if let text = subTitle, !text.isEmpty {
                x = {
                    if !isTitleHidden {
                        return titleFrame.maxX + titleSpacing
                    }
                    if !isIconHidden {
                        return iconFrame.maxX + iconSpacing
                    }
                    return contentInset.left
                }()
                let color = subTitleColor
                let maxLayoutWidth = accessoryFrame.minX - x - (isAccessoryHidden ? 0.0 : 10.0/*accessory left spacing*/)
                let attr_text = NSAttributedString.inner.attributedString(string: text, font: subTitleFont, color: color)
                subTitleText = attr_text
                size = attr_text.inner.size(limitedWidth: maxLayoutWidth)
            } else {
                x = 0.0
                size = .zero
            }
            subTitleFrame.size = size
            subTitleFrame.origin.x = x
        }
        do {
            // 计算高度
            let height: CGFloat
            if automaticallyAdjustsHeight {
                height = {
                    let heights = [
                        iconFrame.height,
                        titleFrame.height,
                        subTitleFrame.height,
                        accessoryFrame.height
                    ]
                    return (heights.max() ?? 0.0) + contentInset.inner.verticalValue()
                }()
            } else {
                height = size.height
            }
            self.size.height = height
            iconFrame.origin.y = _FSFlat((height - iconFrame.height) / 2)
            titleFrame.origin.y = _FSFlat((height - titleFrame.height) / 2)
            subTitleFrame.origin.y = _FSFlat((height - subTitleFrame.height) / 2)
            accessoryFrame.origin.y = _FSFlat((height - accessoryFrame.height) / 2)
        }
        do {
            let x = separatorInset.left
            let w = size.width - separatorInset.right - x
            let h = max(0, separatorHeight)
            let y = size.height - h
            separatorFrame = .init(x: x, y: y, width: w, height: h)
        }
    }
}


private class FSCollectionTitleCell: UICollectionViewCell, FSCollectionCellRenderable {
    
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
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
    
    // MARK: Override
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.isHidden = true
        accessoryDetailView.isHidden = true
        accessoryView?.removeFromSuperview()
        accessoryView = nil
    }
    
    // MARK: Private
    
    /// Invoked after initialization.
    private func p_didInitialize() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(accessoryDetailView)
        addSubview(separatorView)
    }
    
    // MARK: FSCollectionCellRenderable
    
    func render(with item: any FSCollectionItemConvertable) {
        guard let item = item as? FSCollectionTitleItem else { return }
        
        iconView.frame = item.iconFrame
        titleLabel.frame = item.titleFrame
        subTitleLabel.frame = item.subTitleFrame
        accessoryDetailView.frame = item.accessoryFrame
        separatorView.frame = item.separatorFrame
        
        iconView.isHidden = item.isIconHidden
        titleLabel.isHidden = item.isTitleHidden
        subTitleLabel.isHidden = item.isSubTitleHidden
        accessoryDetailView.isHidden = item.isAccessoryDetailHidden
        separatorView.isHidden = item.isSeparatorHidden
        
        separatorView.color = item.separatorColor
        
        if !item.isIconHidden {
            iconView.image = item.icon
        }
        if !item.isTitleHidden {
            titleLabel.attributedText = item.titleText
        }
        if !item.isSubTitleHidden {
            subTitleLabel.attributedText = item.subTitleText
        }
        if !item.isAccessoryDetailHidden {
            accessoryDetailView.image = item.r_accessoryDetailIcon
        }
        if let view = item.accessoryView {
            view.frame = item.accessoryFrame
            addSubview(view)
            accessoryView = view
        }
    }
}
