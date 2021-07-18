//
//  NestChildViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class NestChildViewController: UIViewController {
    var titles = [String]()
    let segmentedDataSource = JXSegmentedTitleDataSource()
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // 配置数据源
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titles = titles

        // 配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen

        // segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [indicator]
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        view.addSubview(segmentedView)

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }
}

extension NestChildViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension NestChildViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return TestListBaseView()
    }
}
