//
//  NaviSegmentedControlViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class NaviSegmentedControlViewController: ContentBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let totalItemWidth: CGFloat = 150
        let titles = ["吃饭🍚", "睡觉😴"]
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.itemContentWidth = totalItemWidth/CGFloat(titles.count)
        titleDataSource.titles = titles
        titleDataSource.isTitleMaskEnabled = true
        titleDataSource.titleColor = UIColor.red
        titleDataSource.titleSelectedColor = UIColor.white
        titleDataSource.reloadData(selectedIndex: 0)
        segmentedDataSource = titleDataSource

        segmentedView.dataSource = titleDataSource
        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 30)
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.red.cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale
        segmentedView.itemSpacing = 0
        navigationItem.titleView = segmentedView

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.backgroundWidthIncrement = 0
        indicator.indicatorColor = UIColor.red
        segmentedView.indicators = [indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = view.bounds
    }
}
