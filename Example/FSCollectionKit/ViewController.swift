//
//  ViewController.swift
//  FSCollectionKit
//
//  Created by Sheng on 12/20/2023.
//  Copyright (c) 2023 Sheng. All rights reserved.
//

import UIKit
import FSCollectionKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    private var isFirstTimeAppear = true
    
    private let manager = FSCollectionManager()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.collectionManager = manager
        return collection
    }()
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTimeAppear {
            isFirstTimeAppear = false
            p_addItems()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = .init(origin: .zero, size: view.frame.size)
    }
    
    // MARK: Private
    
    private func p_addItems() {
        let sections1: [FSCollectionSectionConvertable] = {
            var items: [FSCollectionItemConvertable] = []
            for _ in 0..<100 {
                let item = FSCollectionItem()
                item.size = .init(width: (CGFloat(arc4random() % 100) + 50.0), height: (CGFloat(arc4random() % 100) + 30.0))
                item.onWillDisplay = { (collectionView, cell, indexPath) in
                    cell.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                }
                items.append(item)
            }
            
            let header = FSCollectionTitleHeader()
            header.icon = UIImage(named: "book")
            header.title = "洗尽铅华"
            header.subTitle = "天地不仁，以万物为刍狗"
            header.accessoryType = .detail
            header.containerWidth = view.frame.width
            header.onDidSelect = {
                print("did select header")
            }
            header.updateLayout()
            
            let footer = FSCollectionSeparatorFooter()
            footer.inset = .init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
            footer.size.height = 1.0/UIScreen.main.scale
            
            let section = FSCollectionSection(items: items, header: header, footer: footer)
            section.inset = .init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
            section.minimumLineSpacing = 10.0
            section.minimumInteritemSpacing = 10.0
            
            return [section]
        }()
        let sections2: [FSCollectionSectionConvertable] = {
            var sections = [FSCollectionSectionConvertable]()
            for i in 0..<20 {
                var items: [FSCollectionItemConvertable] = []
                for _ in 0..<(arc4random() % 5 + 1) {
                    let item = FSCollectionItem()
                    item.size = .init(width: FSCollectionItem.AutomaticWidth, height: 100.0)
                    item.onWillDisplay = { (collectionView, cell, indexPath) in
                        cell.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                    }
                    item.onDidSelect = { (_, _) in
                        print("did select")
                    }
                    items.append(item)
                }
                
                let header = FSCollectionTitleHeader()
                if i.isMultiple(of: 2) {
                    header.icon = UIImage(named: "book")
                    header.title = "洗尽铅华"
                    header.subTitle = "天地不仁，以万物为刍狗"
                    header.accessoryView = UIImageView(image: UIImage(named: "gift"))
                    header.accessoryViewSize = UIImage(named: "gift")?.size ?? .zero
                } else {
                    header.icon = UIImage(named: "smile")
                    header.title = "天之道，损有余而补不足"
                    header.accessoryType = .detail
                }
                header.size.height = 50.0
                header.containerWidth = view.frame.width
                header.automaticallyAdjustsHeight = false
                header.updateLayout()
                header.onDidSelect = { [weak self] in
                    print("did select header")
                    let vc = ViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
                let footer = FSCollectionSeparatorFooter()
                footer.inset = .init(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
                footer.size.height = 1.0/UIScreen.main.scale
                
                let section = FSCollectionSection(items: items, header: header, footer: footer)
                section.inset = .init(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
                section.minimumLineSpacing = 10.0
                section.minimumInteritemSpacing = 10.0
                
                sections.append(section)
            }
            return sections
        }()
        collectionView.collectionManager?.sections = sections2
        collectionView.reloadData()
    }
}
