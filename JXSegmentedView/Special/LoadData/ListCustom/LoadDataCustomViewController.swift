//
//  LoadDataListCustomViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class LoadDataCustomViewController: UIViewController {
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    var contentScrollView: UIScrollView!
    var listVCArray = [LoadDataCustomListViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        //1、初始化JXSegmentedView
        segmentedView = JXSegmentedView()

        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource

        //3、配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        segmentedView.indicators = [indicator]

        //4、配置JXSegmentedView的属性
        segmentedView.delegate = self
        view.addSubview(segmentedView)

        //5、初始化contentScrollView
        contentScrollView = UIScrollView()
        contentScrollView.isPagingEnabled = true
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.scrollsToTop = false
        contentScrollView.bounces = false
        //禁用automaticallyInset
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            contentScrollView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(contentScrollView)

        //6、将contentScrollView和segmentedView.contentScrollView进行关联
        segmentedView.contentScrollView = contentScrollView

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新数据", style: UIBarButtonItem.Style.plain, target: self, action: #selector(reloadData))

        reloadData()
    }

    @objc func reloadData() {
        //一定要统一segmentedDataSource、segmentedView的defaultSelectedIndex
        segmentedDataSource.titles = getRandomTitles()
        //reloadData(selectedIndex:)一定要调用
        segmentedDataSource.reloadData(selectedIndex: 0)

        segmentedView.defaultSelectedIndex = 0
        segmentedView.reloadData()

        for vc in listVCArray {
            vc.view.removeFromSuperview()
        }
        listVCArray.removeAll()

        for index in 0..<segmentedDataSource.titles.count {
            let vc = LoadDataCustomListViewController.init(style: .plain)
            vc.typeString = segmentedDataSource.titles[index]
            vc.naviController = self.navigationController
            contentScrollView.addSubview(vc.view)
            listVCArray.append(vc)
        }

        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        listVCArray.first?.loadDataForFirst()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        contentScrollView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(segmentedDataSource.dataSource.count), height: contentScrollView.bounds.size.height)
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
        }
    }

    func getRandomTitles() -> [String] {
        let titles = ["猴哥", "黄焖鸡", "旺财", "粉红猪", "喜羊羊", "青蛙王子", "小马哥", "牛魔王", "大象先生", "神龙"]
        //随机title数量，4~n
        let randomCount = Int(arc4random()%7 + 4)
        var tempTitles = titles
        var resultTitles = [String]()
        for _ in 0..<randomCount {
            let randomIndex = Int(arc4random()%UInt32(tempTitles.count))
            resultTitles.append(tempTitles[randomIndex])
            tempTitles.remove(at: randomIndex)
        }
        return resultTitles
    }
}

extension LoadDataCustomViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        listVCArray[index].loadDataForFirst()
    }
}

