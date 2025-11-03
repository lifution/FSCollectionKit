//
//  CollectionReloader.swift
//  FSCollectionKit
//
//  Created by Vincent on 2025/11/3.
//

import UIKit
import Combine

public enum CollectionUpdate {
    case reloadData
    case reloadSections(Set<Int>)
    case reloadItems([FSCollectionItemConvertable])
    case insertItems([IndexPath])
}

/// collection view 刷新工具类，用于批量刷新或者频繁刷新的时候做防抖处理的。
///
public final class CollectionReloader {
    
    deinit {
        print("\(type(of: self)) deinit")
    }
    
    public weak var collectionView: UICollectionView?
    
    // MARK: =
    
    private let query = CurrentValueSubject<[CollectionUpdate], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: =
    
    public init(debounceInterval: Int = 50) {
        query
            .debounce(for: .milliseconds(debounceInterval), scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .sink(receiveValue: { [weak self] updates in
                self?.apply(updates: updates)
            })
            .store(in: &cancellables)
    }
    
    // MARK: =
    
    public func reloadData() {
        // Must be on main thread
        assert(Thread.isMainThread)
        // -
        query.send(query.value + [.reloadData])
    }
    
    public func reloadSections(_ sections: Set<Int>) {
        // Must be on main thread
        assert(Thread.isMainThread)
        // -
        guard !sections.isEmpty else {
            return
        }
        query.send(query.value + [.reloadSections(sections)])
    }
    
    public func reloadItem(_ item: FSCollectionItemConvertable) {
        // Must be on main thread
        assert(Thread.isMainThread)
        // -
        query.send(query.value + [.reloadItems([item])])
    }
    
    public func reloadItems(_ items: [FSCollectionItemConvertable]) {
        // Must be on main thread
        assert(Thread.isMainThread)
        // -
        guard !items.isEmpty else {
            return
        }
        query.send(query.value + [.reloadItems(items)])
    }
    
    public func insertItems(at indexPaths: [IndexPath]) {
        // Must be on main thread
        assert(Thread.isMainThread)
        // -
        guard !indexPaths.isEmpty else {
            return
        }
        query.send(query.value + [.insertItems(indexPaths)])
    }
    
    public func stop() {
        cancellables.removeAll()
    }
    
    // MARK: =
    
    private func apply(updates: [CollectionUpdate]) {
        guard !updates.isEmpty else {
            return
        }
        
        query.send([])
        
        var shouldReloadData = false
        var reloadSections = Set<Int>()
        var reloadItems = [FSCollectionItemConvertable]()
        var insertIndexPaths = [IndexPath]()
        
        for update in updates {
            switch update {
            case .reloadData:
                shouldReloadData = true
                break;
            case .reloadSections(let sections):
                reloadSections.union(sections)
            case .reloadItems(let items):
                reloadItems += items.filter { new in !reloadItems.contains(where: { old in old === new  }) }
            case .insertItems(let indexPaths):
                insertIndexPaths += indexPaths.filter { new in
                    !insertIndexPaths.contains(where: { old in
                        new.item == old.item && new.section == old.section
                    })
                }
            }
        }
        
        /// 如果单独刷新 item 的数量超过 5 个，则刷新整个列表。
        if !shouldReloadData, reloadItems.count > 5 {
            shouldReloadData = true
        }
        /// section/items/insert 只要有两个不为空，则同样刷新整个列表。
        if !shouldReloadData {
            let array = [
                reloadSections.isEmpty,
                reloadItems.isEmpty,
                insertIndexPaths.isEmpty
            ]
            shouldReloadData = array.filter { !$0 }.count > 1
        }
        
        if shouldReloadData {
            // -
            collectionView?.reloadData()
            // -
        } else if !reloadSections.isEmpty {
            // -
            collectionView?.reloadSections(IndexSet(reloadSections))
            // -
        } else if !reloadItems.isEmpty {
            // -
            reloadItems.forEach { item in
                if let item = item as? FSCollectionLayoutableItem {
                    item.reload()
                } else {
                    item.reload(.reload)
                }
            }
        } else if !insertIndexPaths.isEmpty {
            // -
            collectionView?.insertItems(at: insertIndexPaths)
        }
    }
}
