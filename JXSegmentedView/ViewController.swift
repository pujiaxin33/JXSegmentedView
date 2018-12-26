//
//  ViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var contentScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let segmentedView = JXSegmentedTitleView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50))
        segmentedView.titles = ["动画", "爱上", "额外", "测试"]
        view.addSubview(segmentedView)

        contentScrollView = UIScrollView()
        contentScrollView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 100)
        contentScrollView.isPagingEnabled = true
        contentScrollView.contentSize = CGSize(width: view.bounds.size.width*CGFloat(segmentedView.titles.count), height: view.bounds.size.height - 100)
        view.addSubview(contentScrollView)

        segmentedView.segmentedView.contentScrollView = contentScrollView

        for index in 0..<segmentedView.titles.count {
            let vc = ListBaseViewController()
            addChild(vc)
            vc.view.frame = CGRect(x: view.bounds.size.width*CGFloat(index), y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 100)
            contentScrollView.addSubview(vc.view)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()


    }


}

