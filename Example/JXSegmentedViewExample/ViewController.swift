//
//  ViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        tableView.rowHeight = 44
        title = "JXSegmentedView Example"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var title: String?
        for subview in cell!.contentView.subviews {
            if let label = subview as? UILabel {
                title = label.text
                break
            }
        }

        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IndicatorCustomizeViewController")
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CellCustomizeViewController")
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpecialCustomizeViewController")
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
