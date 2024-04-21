//
//  ShowCaseRefreshViewController.swift
//  ExampleDemo
//
//  Created by Ravendeng on 2024/4/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import LFComponents

enum ShowCaseSectionType: Int {
    case bigSection = 0
    case smallSection = 1
}

struct ShowCaseDataUnit {
    let isBig: Bool
}

class ShowCaseRefreshViewController: UIViewController {
    
    var tintStyle: LFCRefreshTintStyle = .black
    
    var iconSize: LFCRefreshIconSize = .medium
    
    private var smallDataSource = [ShowCaseDataUnit]()
    
    private var bigDataSource = [ShowCaseDataUnit(isBig: true)]
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(ShowCaseCell.self, forCellWithReuseIdentifier: ShowCaseCell.reuseIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection view demo"
        collectionView.lfc.addRefreshHeader(style: tintStyle, size: iconSize, target: self, selector: #selector(refreshHeaderEvent))
        collectionView.lfc.addRefreshFooter(style: tintStyle, size: iconSize, target: self, selector: #selector(refreshFooterEvent))
        collectionView.lfc.addBaseHeaderStater(showClosure: { view in
            return "Refresh complete"
        }, dismissClosure: nil)
        collectionView.lfc.addBaseFooterStater(showClosure: { view in
            return "No more content"
        }, dismissClosure: nil)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ShowCaseRefreshViewController {
    @objc private func refreshHeaderEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.appendDataStopRefresh(isRefresh: true)
        }
    }
    
    @objc private func refreshFooterEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.appendDataStopRefresh(isRefresh: false)
        }
    }
    
    private func appendDataStopRefresh(isRefresh: Bool) {
        if isRefresh { self.smallDataSource = [] }
        _ = self.smallDataSource.count
        
        var datas: [ShowCaseDataUnit] = []
        for _ in 1 ..< 8 {
            datas.append(ShowCaseDataUnit(isBig: false))
        }
        self.smallDataSource.append(contentsOf: datas)
        self.collectionView.reloadData()
        if isRefresh {
            self.collectionView.lfc.stopHeaderRefreshing()
            return
        }
        if self.smallDataSource.count > 15 {
            self.collectionView.lfc.stopFooterRefreshingAndNoMoreData()
        } else {
            self.collectionView.lfc.stopFooterRefreshing()
        }
    }
}

extension ShowCaseRefreshViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionEnum = ShowCaseSectionType(rawValue: section) else {
            return 0
        }
        switch sectionEnum {
        case .bigSection:
            return bigDataSource.count
        case .smallSection:
            return smallDataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShowCaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCaseCell.reuseIdentifier, for: indexPath) as? ShowCaseCell ?? ShowCaseCell(frame: .zero)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sectionEnum = ShowCaseSectionType(rawValue: indexPath.section) else {
            return .zero
        }
        switch sectionEnum {
        case .bigSection:
            return CGSize(width: UIScreen.main.bounds.size.width, height: 165)
        case .smallSection:
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 6, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let sectionEnum = ShowCaseSectionType(rawValue: section) else {
            return .zero
        }
        switch sectionEnum {
        case .bigSection:
            return .zero
        case .smallSection:
            return CGSize(width: 0, height: 12)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 12)
    }
}

class ShowCaseCell: UICollectionViewCell {
    static let reuseIdentifier = "showCaseCell.reuse.collection.cell"
    
    private var heightConstraint: NSLayoutConstraint?
    
    private var widthConstraint: NSLayoutConstraint?
    
    private var unit: ShowCaseDataUnit? {
        didSet {
//            guard let unit = unit, let widthConstraint = widthConstraint, let heightConstraint = heightConstraint else {
//                return
//            }
        }
    }
    
    private lazy var bgView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 6),
            bgView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6),
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
