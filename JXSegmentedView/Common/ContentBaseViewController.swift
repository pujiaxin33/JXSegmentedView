//
//  ContentBaseViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class ContentBaseViewController: UIViewController {
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedNumberDataSource!
    var listContainerView: JXSegmentedListContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedDataSource = JXSegmentedNumberDataSource()
        segmentedDataSource.numbers = [1, 2, 3, 4]
        segmentedDataSource.titles = ["动画", "爱上了了", "额外", "测试啊啊"]
        segmentedDataSource.isTitleColorGradientEnabled = true
//        segmentedDataSource.titleFont = UIFont.systemFont(ofSize: 15)
//        segmentedDataSource.titleSelectedFont = UIFont.systemFont(ofSize: 20)
//        segmentedDataSource.isTitleZoomEnabled = true
//        segmentedDataSource.isTitleStrokeWidthEnabled = true
//        segmentedDataSource.titleSelectedStrokeWidth = -6

        segmentedView = JXSegmentedView()
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
//        segmentedView.isItemSpacingAverageEnabled = false
//        segmentedView.contentEdgeInsetLeft = 10
//        segmentedView.contentEdgeInsetRight = 10
//        segmentedView.itemSpacing = 100
//        segmentedView.itemWidthIncrement = 30
        segmentedView.isContentScrollViewClickTransitionAnimateEnabled = false
        print(segmentedView.selectedIndex)
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        view.addSubview(segmentedView)

        let indicator = JXSegmentedIndicatorRainbowLineView()
        indicator.lineStyle = .lengthenOffset
        indicator.indicatorColors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.purple]

        let backgroundIndicator = JXSegmentedIndicatorBackgroundView()

        let triangleIndicator = JXSegmentedIndicatorTriangleView()


        segmentedView.indicators = [triangleIndicator, backgroundIndicator]

        listContainerView = JXSegmentedListContainerView(parentVC: self, delegate: self)
        segmentedView.contentScrollView = listContainerView.scrollView
        view.addSubview(listContainerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }

}

extension ContentBaseViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        listContainerView.didClickSelectedItem(at: index)
    }

    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: Double) {
        listContainerView.categoryViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}

extension ContentBaseViewController: JXSegmentedListContainerViewDelegate {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContentViewDelegate {
        return TestListBaseView()
    }
}
