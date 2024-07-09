//
//  TitleImageSettingViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class TitleImageSettingViewController: UITableViewController {
    var clickedClosure: ((JXSegmentedTitleImageType) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let types: [JXSegmentedTitleImageType] = [.topImage, .leftImage, .bottomImage, .rightImage, .onlyImage, .onlyTitle, .backgroundImage]
        clickedClosure?(types[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
