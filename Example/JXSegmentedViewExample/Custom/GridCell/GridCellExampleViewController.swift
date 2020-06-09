//
//  GridCellExampleViewController.swift
//  JXSegmentedViewExample
//
//  Created by jiaxin on 2020/1/9.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class GridCellExampleViewController: ContentBaseViewController {
    var totalItemWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        totalItemWidth = UIScreen.main.bounds.size.width - 30*2
        let titles = ["吃饭🍚", "睡觉😴", "游泳🏊", "跳舞💃"]
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.itemWidth = totalItemWidth/CGFloat(titles.count)
        titleDataSource.titles = titles
        titleDataSource.isTitleMaskEnabled = true
        titleDataSource.titleNormalColor = UIColor.red
        titleDataSource.titleSelectedColor = UIColor.white
        titleDataSource.itemSpacing = 0
        segmentedDataSource = titleDataSource

        let gridView = UIView()
        gridView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        gridView.backgroundColor = UIColor.white
        gridView.layer.masksToBounds = true
        gridView.layer.cornerRadius = 3
        gridView.layer.borderColor = UIColor.gray.cgColor
        gridView.layer.borderWidth = 1/UIScreen.main.scale
        let itemWidth = totalItemWidth/CGFloat(titles.count)
        for index in 0..<(titles.count - 1) {
            let line = UIView()
            line.backgroundColor = .gray
            line.frame = CGRect(x: CGFloat(index)*itemWidth - 1, y: 0, width: 1/UIScreen.main.scale, height: 30)
            gridView.addSubview(line)
        }

        segmentedView.dataSource = titleDataSource
        segmentedView.collectionView.backgroundView = gridView

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorCornerRadius = 3
        indicator.indicatorWidthIncrement = 2
        indicator.indicatorColor = UIColor.red
        segmentedView.indicators = [indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 30, y: 10, width: totalItemWidth, height: 30)
    }

}
