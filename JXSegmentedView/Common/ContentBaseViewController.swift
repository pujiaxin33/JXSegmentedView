//
//  ContentBaseViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class ContentBaseViewController: UIViewController {
    var segmentedDataSource: JXSegmentedViewDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(parentVC: self, delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        /*
        segmentedDataSource.titleImageType = .bottomImage
        segmentedDataSource.isImageZoomEnabled = true
        segmentedDataSource.imageInfos = ["monkey", "chicken", "dog", "pig", "sheep", "frog", "horse", "cow", "elephant", "dragon"]
        segmentedDataSource.selectedImageInfos = ["chicken", "dog", "pig", "sheep", "frog", "horse", "cow", "elephant", "dragon", "monkey"]
        segmentedDataSource.titles = ["猴哥", "黄焖鸡", "旺财", "粉红猪", "喜羊羊", "青蛙王子", "小马哥", "牛魔王", "大象先生", "神龙"]
        segmentedDataSource.loadImageClosure = {(imageView, imageInfo) in
        }
        */

//        segmentedDataSource.dotStates = [true, false, true, false]
//        segmentedDataSource.dotOffset = CGPoint(x: -10, y: 10)

//        segmentedDataSource.numbers = [1, 2, 3, 4]
//        segmentedDataSource.numberOffset = CGPoint(x: -10, y: 10)

//        segmentedDataSource.titles = ["猴哥", "黄焖鸡", "旺财", "粉红猪", "喜羊羊", "青蛙王子", "小马哥", "牛魔王", "大象先生", "神龙"]
//        segmentedDataSource.isTitleColorGradientEnabled = true
//        segmentedDataSource.titleFont = UIFont.systemFont(ofSize: 15)
//        segmentedDataSource.titleSelectedFont = UIFont.systemFont(ofSize: 20)
//        segmentedDataSource.isTitleZoomEnabled = true
//        segmentedDataSource.isTitleStrokeWidthEnabled = true
//        segmentedDataSource.titleSelectedStrokeWidth = -6

        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
//        segmentedView.isItemSpacingAverageEnabled = false
//        segmentedView.contentEdgeInsetLeft = 10
//        segmentedView.contentEdgeInsetRight = 10
//        segmentedView.itemSpacing = 100
//        segmentedView.itemWidthIncrement = 30
//        segmentedView.isContentScrollViewClickTransitionAnimateEnabled = false
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        view.addSubview(segmentedView)

//        let indicator = JXSegmentedIndicatorRainbowLineView()
//        indicator.lineStyle = .lengthenOffset
//        indicator.indicatorColors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.purple]
//
//        let backgroundIndicator = JXSegmentedIndicatorBackgroundView()
//
//        let triangleIndicator = JXSegmentedIndicatorTriangleView()
//
//
//        segmentedView.indicators = [triangleIndicator, backgroundIndicator]

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
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContentViewDelegate {
        return TestListBaseView()
    }
}
