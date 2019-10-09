//
//  SegmentedControlViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class SegmentedControlViewController: ContentBaseViewController {
    var totalItemWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        totalItemWidth = UIScreen.main.bounds.size.width - 30*2
        let titles = ["吃饭🍚", "睡觉😴", "游泳🏊", "跳舞💃"]
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.itemContentWidth = totalItemWidth/CGFloat(titles.count)
        titleDataSource.titles = titles
        titleDataSource.isTitleMaskEnabled = true
        titleDataSource.titleNormalColor = UIColor.red
        titleDataSource.titleSelectedColor = UIColor.white
        titleDataSource.itemSpacing = 0
        segmentedDataSource = titleDataSource

        segmentedView.dataSource = titleDataSource
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 15
        segmentedView.layer.borderColor = UIColor.red.cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.backgroundWidthIncrement = 0
        indicator.indicatorColor = UIColor.red
        segmentedView.indicators = [indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 30, y: 10, width: totalItemWidth, height: 30)
    }
}
