//
//  TitleImageSettingViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class TitleImageSettingViewController: UITableViewController {
    var clickedClosure: ((JXSegmentedTitleImageType) -> ())?

    deinit {
        clickedClosure = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var types: [JXSegmentedTitleImageType] = [.topImage, .leftImage, .bottomImage, .rightImage, .onlyImage, .onlyTitle]
        clickedClosure?(types[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
