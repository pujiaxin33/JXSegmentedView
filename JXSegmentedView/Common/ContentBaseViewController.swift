//
//  ContentBaseViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class ContentBaseViewController: UIViewController {
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(parentVC: self, delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        view.addSubview(segmentedView)

        segmentedView.contentScrollView = listContainerView.scrollView
        view.addSubview(listContainerView)

        if (segmentedDataSource as? JXSegmentedTitleImageDataSource) != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didSetingsButtonClicked))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }

    @objc func didSetingsButtonClicked() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TitleImageSettingViewController") as! TitleImageSettingViewController
        vc.title = title
        vc.clickedClosure = {[weak self] (type) in
            (self?.segmentedDataSource as? JXSegmentedTitleImageDataSource)?.titleImageType = type
            //先更新数据源
            self?.segmentedDataSource?.reloadData(selectedIndex: self?.segmentedView.selectedIndex ?? 0)
            //再更新segmentedView
            self?.segmentedView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
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

