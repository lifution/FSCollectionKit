//
//  InsetGroupedViewController.swift
//  FSCollectionKit_Example
//
//  Created by Vincent on 2025/11/3.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import FSCollectionKit
import SwipeCellKit

final class InsetGroupedViewController: UIViewController {
    
    private let layout = CollectionInsetGroupedLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .groupTableViewBackground
        collection.register(Cell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    private var numberOfItems = [Int]()
    
    private var itemSize = CGSize.zero
    
    /// 当前控制器的 view 的 size。
    /// 当该属性更新时会回调 `viewSizeDidChange` 方法。
    private var viewSize: CGSize = .zero
    
    // MARK: =
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        p_didInitialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        p_didInitialize()
    }
}

// MARK: =

extension InsetGroupedViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p_setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewSize != view.frame.size {
            viewSize = view.frame.size
            viewSizeDidChange()
        }
    }
}

// MARK: =

private extension InsetGroupedViewController {
    
    /// Called after initialization.
    func p_didInitialize() {
        itemSize.height = 44.0
        numberOfItems = Array(0..<10).map { _ in Int(arc4random() % 5) + 1 }
        layout.delegate = self
        navigationItem.title = "Inset Grouped Collection"
    }
    
    /// Called in the `viewDidLoad` method.
    func p_setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(0.0)
        }
    }
    
    func viewSizeDidChange() {
        itemSize.width = viewSize.width - 16.0 * 2
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension InsetGroupedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            fatalError()
        }
        let numberOfItems = numberOfItems[indexPath.section]
        cell.textLabel.text = "Section: \(indexPath.section), Row: \(indexPath.row)"
        cell.separatorView.isHidden = indexPath.row == (numberOfItems - 1)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension InsetGroupedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10.0, left: 16.0, bottom: 0.0, right: 16.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - CollectionInsetGroupedLayoutDelegate

extension InsetGroupedViewController: CollectionInsetGroupedLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedCornerRadiusAt section: Int) -> CGFloat {
        return section % 2 == 0 ? 10.0 : 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedBackgroundColorAt section: Int) -> UIColor? {
        return section % 2 == 0 ? .white : .cyan.withAlphaComponent(0.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowInsetGroupedAt section: Int) -> Bool {
//        if section == 0 {
//            return false
//        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, insetGroupedInsetsAt section: Int) -> UIEdgeInsets {
        if section % 2 != 0 {
            return .init(top: -10.0, left: 0.0, bottom: -20.0, right: 0.0)
        }
        return .zero
    }
}

private final class Cell: SwipeCollectionViewCell, SwipeCollectionViewCellDelegate {
    
    let textLabel = UILabel()
    let separatorView = UIView()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_didInitialize()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? CollectionInsetGroupedLayoutAttributes else {
            return
        }
        separatorView.isHidden = attributes.isSeparatorHidden
        layer.cornerRadius = attributes.cornerRadius
        layer.maskedCorners = attributes.maskedCorners
        /// Fix: ``layoutAttributes.zIndex`` not work.
        layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }
    
    // MARK: =
    
    private func p_didInitialize() {
        
        delegate = self
        
        clipsToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        textLabel.font = .systemFont(ofSize: 15.0)
        textLabel.textColor = .black
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(12.0)
            make.centerY.equalToSuperview()
        }
        
        separatorView.backgroundColor = .gray
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.left.equalTo(12.0)
            make.bottom.equalTo(0.0)
            make.right.equalTo(-12.0)
            make.height.equalTo(1.0/UIScreen.main.scale)
        }
    }
    
    // MARK: =
    
    func collectionView(_ collectionView: UICollectionView,
                        editActionsForItemAt indexPath: IndexPath,
                        for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        return [SwipeAction(style: .destructive, title: "Delete", handler: nil)]
    }
}
