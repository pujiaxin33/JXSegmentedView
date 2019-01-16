//
//  LoadDataDetailViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class LoadDataDetailViewController: UIViewController {
    var detailText = ""
    private var textLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "测试详情页面"
        self.view.backgroundColor = UIColor.white

        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(textLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textLabel.text = detailText
        textLabel.sizeToFit()
        textLabel.center = view.center
    }


}
