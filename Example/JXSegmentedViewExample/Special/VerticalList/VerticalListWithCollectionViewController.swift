//
//  VerticalListWithCollectionViewController.swift
//  JXSegmentedViewExample
//
//  Created by Jason on 2025/6/27.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class VerticalListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JXSegmentedViewDelegate {
    
    private let verticalListCategoryViewHeight: CGFloat = 60  // 悬浮categoryView的高度
    private let verticalListPinSectionIndex: Int = 1         // 悬浮固定section的index
    
    private var collectionView: VerticalListCollectionView!
    private var dataSource: [VerticalListSectionModel] = []
    private var headerTitles: [String] = []
    private var pinCategoryView: JXSegmentedView!
    private var sectionCategoryHeaderView: VerticalSectionSegmentedHeaderView?
    private var sectionHeaderAttributes: [UICollectionViewLayoutAttributes]?
    private let segmentedDataSource = JXSegmentedTitleDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = VerticalListCollectionView(frame: .zero, collectionViewLayout: layout)
        
        weak var weakSelf = self
        collectionView.layoutSubviewsCallback = {
            weakSelf?.updateSectionHeaderAttributes()
        }
        
        collectionView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(VerticalListCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(VerticalSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(VerticalSectionSegmentedHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryHeader")
        view.addSubview(collectionView)
        
        // 创建 pinCategoryView，但是不要被 addSubview
        pinCategoryView = JXSegmentedView()
        pinCategoryView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        pinCategoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: verticalListCategoryViewHeight)
        
        segmentedDataSource.titles = ["超级大IP", "热门HOT", "周边衍生", "影视综", "游戏集锦", "搞笑百事"]
        pinCategoryView.dataSource = segmentedDataSource
        
        let lineView = JXSegmentedIndicatorLineView()
        pinCategoryView.indicators = [lineView]
        pinCategoryView.delegate = self
        
        let loading = UIActivityIndicatorView(style: .gray)
        loading.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        loading.transform = CGAffineTransform(scaleX: 3, y: 3)
        loading.center = view.center
        loading.startAnimating()
        view.addSubview(loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 模拟数据加载
            loading.stopAnimating()
            loading.removeFromSuperview()
            
            var dataSource: [VerticalListSectionModel] = []
            self.headerTitles = ["我的频道", "超级大IP", "热门HOT", "周边衍生", "影视综", "游戏集锦", "搞笑百事"]
            let imageNames = ["frog", "horse", "elephant", "dragon", "sheep", "cow", "dog"]
            
            for (idx, title) in self.headerTitles.enumerated() {
                let sectionModel = VerticalListSectionModel()
                sectionModel.sectionTitle = title
                
                let randomCount = Int(arc4random() % 10) + 5
                var cellModels: [VerticalListCellModel] = []
                
                for _ in 0..<randomCount {
                    let cellModel = VerticalListCellModel()
                    cellModel.imageName = imageNames[idx]
                    cellModel.itemName = title
                    cellModels.append(cellModel)
                }
                
                sectionModel.cellModels = cellModels
                dataSource.append(sectionModel)
            }
            
            self.dataSource = dataSource
            self.collectionView.reloadData()
        }
    }
    
    private func updateSectionHeaderAttributes() {
        if sectionHeaderAttributes == nil {
            // 获取到所有的sectionHeaderAtrributes，用于后续的点击，滚动到指定contentOffset.y使用
            var attributes: [UICollectionViewLayoutAttributes] = []
            var lastHeaderAttri: UICollectionViewLayoutAttributes? = nil
            
            for i in 0..<headerTitles.count {
                let indexPath = IndexPath(item: 0, section: i)
                if let attri = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                    attributes.append(attri)
                }
                
                if i == headerTitles.count - 1 {
                    lastHeaderAttri = attributes.last
                }
            }
            
            if attributes.isEmpty {
                return
            }
            
            sectionHeaderAttributes = attributes
            
            // 如果最后一个section条目太少了，会导致滚动最底部，但是却不能触发categoryView选中最后一个item。而且点击最后一个滚动的contentOffset.y也不好弄。所以添加contentInset，让最后一个section滚到最下面能显示完整个屏幕。
            let lastSection = headerTitles.count - 1
            let lastItem = dataSource[lastSection].cellModels.count - 1
            let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
            
            if let lastCellAttri = collectionView.collectionViewLayout.layoutAttributesForItem(at: lastIndexPath),
               let lastHeaderAttri = lastHeaderAttri {
                
                let lastSectionHeight = lastCellAttri.frame.maxY - lastHeaderAttri.frame.minY
                let value = (view.bounds.height - verticalListCategoryViewHeight) - lastSectionHeight
                
                if value > 0 {
                    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VerticalListCell
        let sectionModel = dataSource[indexPath.section]
        let cellModel = sectionModel.cellModels[indexPath.row]
        cell.itemImageView.image = UIImage(named: cellModel.imageName)
        cell.titleLabel.text = cellModel.itemName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == verticalListPinSectionIndex {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "categoryHeader", for: indexPath) as! VerticalSectionSegmentedHeaderView
                sectionCategoryHeaderView = headerView
                if pinCategoryView.superview == nil {
                    // 首次使用VerticalSectionCategoryHeaderView的时候，把pinCategoryView添加到它上面。
                    headerView.addSubview(pinCategoryView)
                }
                return headerView
            } else {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! VerticalSectionHeaderView
                let sectionModel = dataSource[indexPath.section]
                headerView.titleLabel.text = sectionModel.sectionTitle
                return headerView
            }
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "other", for: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let sectionHeaderAttributes = sectionHeaderAttributes else { return }
        let attri = sectionHeaderAttributes[verticalListPinSectionIndex]
        
        if scrollView.contentOffset.y >= attri.frame.origin.y {
            // 当滚动的contentOffset.y大于了指定sectionHeader的y值，且还没有被添加到self.view上的时候，就需要切换superView
            if pinCategoryView.superview != view {
                view.addSubview(pinCategoryView)
            }
        } else if pinCategoryView.superview != sectionCategoryHeaderView {
            // 当滚动的contentOffset.y小于了指定sectionHeader的y值，且还没有被添加到sectionCategoryHeaderView上的时候，就需要切换superView
            sectionCategoryHeaderView?.addSubview(pinCategoryView)
        }
        
        if pinCategoryView.selectedIndex != 0 && scrollView.contentOffset.y == 0 {
            // 点击了状态栏滚动到顶部时的处理
            pinCategoryView.selectItemAt(index: 0)
        }
        
        if !(scrollView.isTracking || scrollView.isDecelerating) {
            // 不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
            return
        }
        
        // 用户滚动的才处理
        // 获取categoryView下面一点的所有布局信息，用于知道，当前最上方是显示的哪个section
        let topRect = CGRect(x: 0, y: scrollView.contentOffset.y + verticalListCategoryViewHeight + 1, width: view.bounds.width, height: 1)
        if let topAttributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: topRect)?.first {
            let topSection = topAttributes.indexPath.section
            if topSection >= verticalListPinSectionIndex {
                if pinCategoryView.selectedIndex != topSection - verticalListPinSectionIndex {
                    // 不相同才切换
                    pinCategoryView.selectItemAt(index: topSection - verticalListPinSectionIndex)
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == verticalListPinSectionIndex {
            // categoryView所在的headerView要高一些
            return CGSize(width: view.bounds.width, height: verticalListCategoryViewHeight)
        }
        return CGSize(width: view.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (view.bounds.width - 100 * 3) / 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = (view.bounds.width - 100 * 3) / 4
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
    
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        // 这里关心点击选中的回调！！！
        guard let sectionHeaderAttributes = sectionHeaderAttributes else { return }
        let targetAttri = sectionHeaderAttributes[index + verticalListPinSectionIndex]
        
        if index == 0 {
            // 选中了第一个，特殊处理一下，滚动到sectionHeaer的最上面
            collectionView.setContentOffset(CGPoint(x: 0, y: targetAttri.frame.origin.y), animated: true)
        } else {
            // 不是第一个，需要滚动到categoryView下面
            collectionView.setContentOffset(CGPoint(x: 0, y: targetAttri.frame.origin.y - verticalListCategoryViewHeight), animated: true)
        }
    }
    
}

