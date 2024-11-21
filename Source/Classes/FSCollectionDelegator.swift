//
//  FSCollectionDelegator.swift
//  FSCollectionKit
//
//  Created by Sheng on 2023/12/20.
//  Copyright © 2023 Sheng. All rights reserved.
//

import UIKit

final class FSCollectionDelegator: NSObject {
    weak var manager: FSCollectionManager!
}

private extension FSCollectionDelegator {
    
    func p_section(at index: Int) -> FSCollectionSectionConvertable? {
        guard index >= 0, index < manager.sections.count else {
            return nil
        }
        return manager.sections[index]
    }
    
    func p_item(at indexPath: IndexPath) -> FSCollectionItemConvertable? {
        guard
            let section = p_section(at: indexPath.section),
            indexPath.item < section.items.count
        else {
            return nil
        }
        return section.items[indexPath.item]
    }
}

extension FSCollectionDelegator: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /// 每次数据更新都必经过该方法，因此在此处做一些数据更新后的相关操作。
        manager.collectionDataDidUpdate()
        return manager.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionObj = p_section(at: section) else {
            return 0
        }
        return sectionObj.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let section = p_section(at: indexPath.section),
            indexPath.item < section.items.count
        else {
            preconditionFailure("Invalid data.")
        }
        let item = section.items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reuseIdentifier, for: indexPath)
        /// cellForItemAt 和 willDisplay 两个方法并不是同步调用的，有时候调用了 cellForItemAt 但却不会立即调用 willDisplay 的，
        /// 因此更新 cell 的操作必须放在 `cellForItemAt` 方法中。
        if let renderable = cell as? FSCollectionCellRenderable {
            renderable.render(with: item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = p_section(at: indexPath.section) else {
            preconditionFailure("Invalid supplementary view type for this collection view.")
        }
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = section.header else {
                preconditionFailure("Invalid supplementary view type for this collection view.")
            }
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header.reuseIdentifier, for: indexPath)
        case UICollectionView.elementKindSectionFooter:
            guard let footer = section.footer else {
                preconditionFailure("Invalid supplementary view type for this collection view.")
            }
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footer.reuseIdentifier, for: indexPath)
        default:
            preconditionFailure("Invalid supplementary view type for this collection view.")
        }
    }
}

extension FSCollectionDelegator: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if let item = p_item(at: indexPath) {
            return item.shouldHighlight
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let item = p_item(at: indexPath) {
            return item.shouldSelect
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let item = p_item(at: indexPath) {
            return item.shouldDeselect
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = p_item(at: indexPath) {
            item.onDidSelect?(collectionView, indexPath, item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let item = p_item(at: indexPath) {
            item.onDidDeselect?(collectionView, indexPath, item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let section = p_section(at: indexPath.section), indexPath.item < section.items.count {
            let item = section.items[indexPath.item]
            item.onWillDisplay?(collectionView, cell, indexPath, item)
        }
        if let renderable = cell as? FSCollectionCellRenderable {
            renderable.willDisplay()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let section = p_section(at: indexPath.section), indexPath.item < section.items.count {
            let item = section.items[indexPath.item]
            item.onDidEndDisplaying?(collectionView, cell, indexPath, item)
        }
        if let renderable = cell as? FSCollectionCellRenderable {
            renderable.didEndDisplaying()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let section = p_section(at: indexPath.section) else {
            return
        }
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = section.header else {
                return
            }
            if let renderable = view as? FSCollectionHeaderFooterViewRenderable {
                renderable.render(with: header)
            }
            header.onWillDisplay?(collectionView, view, indexPath, header)
        case UICollectionView.elementKindSectionFooter:
            guard let footer = section.footer else {
                return
            }
            if let renderable = view as? FSCollectionHeaderFooterViewRenderable {
                renderable.render(with: footer)
            }
            footer.onWillDisplay?(collectionView, view, indexPath, footer)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let section = p_section(at: indexPath.section) else {
            return
        }
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = section.header else {
                return
            }
            header.onDidEndDisplaying?(collectionView, view, indexPath, header)
        case UICollectionView.elementKindSectionFooter:
            guard let footer = section.footer else {
                return
            }
            footer.onDidEndDisplaying?(collectionView, view, indexPath, footer)
        default:
            break
        }
    }
}

extension FSCollectionDelegator: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = p_section(at: indexPath.section), indexPath.item < section.items.count else {
            #if DEBUG
            fatalError("数据访问越界")
            #else
            return .zero
            #endif
        }
        var size = section.items[indexPath.item].size
        do {
            /// 按需自适应宽高。
            if size.width == FSCollectionItem.AutomaticWidth || size.height == FSCollectionItem.AutomaticHeight {
                if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                    switch layout.scrollDirection {
                    case .vertical:
                        do {
                            if size.height == FSCollectionItem.AutomaticHeight {
                                size.height = 0.0
                            }
                            if size.width == FSCollectionItem.AutomaticWidth {
                                let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
                                size.width = collectionView.bounds.width - sectionInset.inner.horizontalValue()
                                if #available(iOS 11.0, *) {
                                    size.width -= collectionView.adjustedContentInset.inner.horizontalValue()
                                } else {
                                    size.width -= collectionView.contentInset.inner.horizontalValue()
                                }
                                size.width = floor(size.width)
                            }
                        }
                    case .horizontal:
                        do {
                            if size.width == FSCollectionItem.AutomaticWidth {
                                size.width = 0.0
                            }
                            if size.height == FSCollectionItem.AutomaticHeight {
                                let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
                                size.height = collectionView.bounds.height - sectionInset.inner.verticalValue()
                                if #available(iOS 11.0, *) {
                                    size.height -= collectionView.adjustedContentInset.inner.verticalValue()
                                } else {
                                    size.height -= collectionView.contentInset.inner.verticalValue()
                                }
                                size.height = floor(size.height)
                            }
                        }
                    default:
                        fatalError("unknown type")
                    }
                }
            }
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let sectionObj = p_section(at: section) else {
            return .zero
        }
        return sectionObj.inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let sectionObj = p_section(at: section) else {
            return 0.0
        }
        return sectionObj.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let sectionObj = p_section(at: section) else {
            return 0.0
        }
        return sectionObj.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = p_section(at: section), let header = section.header else {
            return .zero
        }
        return header.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let section = p_section(at: section), let footer = section.footer else {
            return .zero
        }
        return footer.size
    }
}

extension FSCollectionDelegator: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        manager.scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        manager.scrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        manager.scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        manager.scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        manager.scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        manager.scrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        manager.scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)  {
        manager.scrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return manager.scrollDelegate?.viewForZooming?(in: scrollView)
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        manager.scrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        manager.scrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return manager.scrollDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        manager.scrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        manager.scrollDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}
