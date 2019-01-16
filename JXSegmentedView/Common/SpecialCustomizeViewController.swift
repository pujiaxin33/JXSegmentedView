//
//  SpecialCustomizeViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

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
            self.navigationController?.pushViewController(vc, animated: true)
        case "SegmentedControl":
            let vc = SegmentedControlViewController()
            vc.title = itemTitle
            self.navigationController?.pushViewController(vc, animated: true)
        case "导航栏使用":
            let vc = NaviSegmentedControlViewController()
            vc.title = itemTitle
            self.navigationController?.pushViewController(vc, animated: true)
        case "嵌套使用":
            let vc = NestViewController()
            vc.title = itemTitle
            self.navigationController?.pushViewController(vc, animated: true)
        case "刷新数据+JXSegmentedListContainerView":
            let vc = LoadDataViewController()
            vc.title = itemTitle
            self.navigationController?.pushViewController(vc, animated: true)
        case "刷新数据+列表自定义":
            let vc = LoadDataCustomViewController()
            vc.title = itemTitle
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }

}
