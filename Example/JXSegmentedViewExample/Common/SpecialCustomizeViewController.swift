//
//  SpecialCustomizeViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class SpecialCustomizeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var itemTitle: String?
        for subview in cell!.contentView.subviews {
            if let label = subview as? UILabel {
                itemTitle = label.text
                break
            }
        }

        switch itemTitle! {
        case "个人主页":
            let vc = PagingViewController()
            vc.title = itemTitle
            navigationController?.pushViewController(vc, animated: true)
        case "SegmentedControl":
            let vc = SegmentedControlViewController()
            vc.title = itemTitle
            navigationController?.pushViewController(vc, animated: true)
        case "导航栏使用":
            let vc = NaviSegmentedControlViewController()
            vc.title = itemTitle
            navigationController?.pushViewController(vc, animated: true)
        case "嵌套使用":
            let vc = NestViewController()
            vc.title = itemTitle
            navigationController?.pushViewController(vc, animated: true)
        case "刷新数据+JXSegmentedListContainerView":
            let vc = LoadDataViewController()
            vc.title = itemTitle
            navigationController?.pushViewController(vc, animated: true)
        case "刷新数据+列表自定义":
            let vc = LoadDataCustomViewController()
            vc.title = itemTitle
            navigationController?.pushViewController(vc, animated: true)
        case "isItemSpacingAverageEnabled为true":
            let titles = ["猴哥", "青蛙王子", "旺财"]
            let vc = ContentBaseViewController()
            vc.title = itemTitle
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isItemSpacingAverageEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            vc.segmentedView.indicators = [indicator]
            navigationController?.pushViewController(vc, animated: true)
        case "isItemSpacingAverageEnabled为false":
            let titles = ["猴哥", "青蛙王子", "旺财"]
            let vc = ContentBaseViewController()
            vc.title = itemTitle
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isItemSpacingAverageEnabled = false
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            vc.segmentedView.indicators = [indicator]
            navigationController?.pushViewController(vc, animated: true)
        case "导航栏自定义返回item手势处理":
            let vc = NaviItemCustomViewController()
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        case "自定义：网格cell":
            let vc = GridCellExampleViewController()
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        case "列表缓存":
            let vc = ListCacheViewController()
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        case "垂直列表滚动切换分类":
            let vc = VerticalListViewController()
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }

}
