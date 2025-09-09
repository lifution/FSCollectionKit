//
//  FSCollectionManager.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

///
/// - Note:
/// 该 manager 目前默认仅适配 UICollectionViewFlowLayout，
/// 如果使用了其它自定义 layout 则需要使用者自己实现 size 以及 sectionInset 的管理。
///
public final class FSCollectionManager {
    
    public var sections: [FSCollectionSectionConvertable] = [] {
        didSet {
            p_collectionDataDidUpdate()
        }
    }
    
    /// UIScrollViewDelegate，提供给外部监听。
    public weak var scrollDelegate: UIScrollViewDelegate?
    
    public private(set) weak var collectionView: UICollectionView?
    
    // MARK: =
    
    private var delegator: FSCollectionDelegator?
    
    /// 记录已注册的 cellClass，以免多次注册。
    private var registeredCellMap: [String: AnyClass] = [:]
    
    /// 记录已注册的 headerClass，以免多次注册。
    private var registeredHeaderMap: [String: AnyClass] = [:]
    
    /// 记录已注册的 footerClass，以免多次注册。
    private var registeredFooterMap: [String: AnyClass] = [:]
    
    private var emptyView: UIView?
    
    // MARK: =
    
    public init(sections: [FSCollectionSectionConvertable] = []) {
        self.sections = sections
    }
    
    // MARK: =
    
    deinit {
        delegator = nil
    }
}

// MARK: - Private

private extension FSCollectionManager {
    
    func p_register() {
        guard
            let collection = collectionView,
            !sections.isEmpty
        else {
            return
        }
        for section in sections {
            // -
            for item in section.items {
                collection.register(item.cellType, forCellWithReuseIdentifier: item.reuseIdentifier)
            }
            if let header = section.header {
                collection.register(
                    header.viewType,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: header.reuseIdentifier
                )
            }
            if let footer = section.footer {
                collection.register(
                    footer.viewType,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: footer.reuseIdentifier
                )
            }
        }
    }
    
    func p_updateReloadHandlers() {
        guard !sections.isEmpty else { return }
        for section in sections {
            // section reload
            if section.reloadHandler == nil {
                section.reloadHandler = { [weak self, weak section] type in
                    guard let self = self, let section = section else { return }
                    switch type {
                    case .reload:
                        self.reloadSection(of: section)
                    case .reRender:
                        self.rerenderSection(of: section)
                    case .reloadCollection:
                        self.reloadData()
                    }
                }
            }
            // item reload
            for item in section.items {
                if item.reloadHandler == nil {
                    item.reloadHandler = { [weak self, weak item] (type) in
                        guard let self = self, let item = item else { return }
                        switch type {
                        case .reload:
                            self.reloadCell(of: item)
                        case .reRender:
                            self.rerenderCell(of: item)
                        case .reloadCollection:
                            self.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func p_collectionDataDidUpdate() {
        p_register()
        p_updateReloadHandlers()
    }
    
    func p_index(for section: FSCollectionSectionConvertable) -> Int? {
        return sections.firstIndex { section === $0 }
    }
    
    /// item 可能存在多个 section 中，因此查找 item 会遍历所有的 section，
    /// 最后返回的是一个数组，如果不存在则返回空数组。
    func p_indexPaths(for item: FSCollectionItemConvertable) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for (sectionIndex, section) in sections.enumerated() {
            for (itemIndex, item_) in section.items.enumerated() {
                if item_ === item {
                    indexPaths.append(IndexPath(item: itemIndex, section: sectionIndex))
                }
            }
        }
        return indexPaths
    }
    
    func p_updateEmptyViewVisibleStatus() {
        guard let view = emptyView else { return }
        let count = sections.count
        if count == 0 {
            view.isHidden = false
        } else {
            var shouldHide = false
            for i in 0..<count {
                if sections[i].items.count > 0 {
                    shouldHide = true
                    break
                }
            }
            view.isHidden = shouldHide
        }
    }
    
    func p_updateEmptyView() {
        guard let collection = collectionView, let view = emptyView else {
            return
        }
        collection.backgroundView = view
        p_updateEmptyViewVisibleStatus()
    }
}

// MARK: - Internal

extension FSCollectionManager {
    
    func bind(to collectionView: UICollectionView) {
        if let collection = self.collectionView, collection !== collectionView {
            registeredCellMap = [:]
            registeredHeaderMap = [:]
            registeredFooterMap = [:]
        }
        self.collectionView = collectionView
        p_register()
        p_updateEmptyView()
        delegator = .init(manager: self)
        collectionView.delegate = delegator
        collectionView.dataSource = delegator
    }
    
    /// 当数据更新后，而且 UI 还没 reload 前，会回调到该方法。
    /// 该方法是提供给 FSCollectionDelegator 使用的，其它地方不可调用，以免出现不可预知的问题。
    func collectionDataDidUpdate() {
        p_collectionDataDidUpdate()
        p_updateEmptyViewVisibleStatus()
    }
}

// MARK: - Public

public extension FSCollectionManager {
    
    func reloadData() {
        collectionView?.reloadData()
    }
    
    /// 更新 section 所在的 collectionView-section。
    func reloadSection(of section: FSCollectionSectionConvertable) {
        guard let _ = collectionView?.superview else { return }
        if let index = p_index(for: section) {
            collectionView?.reloadSections([index])
        }
    }
    
    /// 重新渲染指定 section 内所有的内容。
    /// - Note: 这种方式是不会调用 collectionView 的刷新方法的。
    func rerenderSection(of section: FSCollectionSectionConvertable) {
        guard let _ = collectionView?.superview else { return }
        guard let sectionIndex = p_index(for: section) else { return }
        let items = sections[sectionIndex].items
        for (index, item) in items.enumerated() {
            let indexPath = IndexPath(item: index, section: sectionIndex)
            if let cell = collectionView?.cellForItem(at: indexPath) as? FSCollectionCellRenderable {
                cell.render(with: item)
            }
        }
    }
    
    /// 更新 item 所在的 cell。
    func reloadCell(of item: FSCollectionItemConvertable) {
        guard let _ = collectionView?.superview else { return }
        let indexPaths = p_indexPaths(for: item)
        if !indexPaths.isEmpty {
            collectionView?.reloadItems(at: indexPaths)
        }
    }
    
    /// 重新渲染 item 所在的 cell。
    /// - Note: 这种方式是不会调用 collectionView 的刷新方法的。
    func rerenderCell(of item: FSCollectionItemConvertable) {
        guard let _ = collectionView?.superview else { return }
        let indexPaths = p_indexPaths(for: item)
        if !indexPaths.isEmpty {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? FSCollectionCellRenderable {
                    cell.render(with: item)
                }
            }
        }
    }
    
    /// 读取指定 indexPath 下的 FSCollectionSectionConvertable 对象。
    func section(at indexPath: IndexPath) -> FSCollectionSectionConvertable? {
        guard
            indexPath.section >= 0,
            indexPath.section < sections.count
        else {
            return nil
        }
        return sections[indexPath.section]
    }
    
    /// 读取指定 indexPath 下的 FSCollectionItemConvertable 对象。
    func item(at indexPath: IndexPath) -> FSCollectionItemConvertable? {
        guard
            let section = section(at: indexPath),
            indexPath.item >= 0,
            indexPath.item < section.items.count
        else {
            return nil
        }
        return section.items[indexPath.item]
    }
    
    func setEmptyView(_ view: UIView?) {
        do {
            emptyView?.removeFromSuperview()
            emptyView = nil
            collectionView?.backgroundView = nil
        }
        emptyView = view
        p_updateEmptyView()
    }
    
    /// 更新布局
    ///
    /// 该方法只适用于遵守 ``FSCollectionContentLayoutable/FSCollectionItemLayoutable`` 协议的
    /// header/footer/item。
    ///
    func updateCollectionLayout(needsReload: Bool = true) {
        let containerSize = collectionView?.frame.size ?? .zero
        sections.forEach { section in
            if let header = section.header as? FSCollectionContentLayoutable {
                header.containerSize = containerSize
                header.updateLayout()
            }
            if let footer = section.footer as? FSCollectionContentLayoutable {
                footer.containerSize = containerSize
                footer.updateLayout()
            }
            section.items.compactMap { $0 as? FSCollectionItemLayoutable }.forEach {
                $0.sectionInset = section.inset
                $0.containerSize = containerSize
                $0.updateLayout()
            }
        }
        if needsReload {
            collectionView?.reloadData()
        }
    }
}
