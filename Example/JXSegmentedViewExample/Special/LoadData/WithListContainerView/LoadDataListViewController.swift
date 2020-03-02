//
//  LoadDataListViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class LoadDataListViewController: UITableViewController {
    var typeString: String = ""
    var dataSource = [String]()
    var isDataLoaded = false

    deinit {
        print("LoadDataListViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        refreshControl?.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        headerRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear:\(typeString)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear:\(typeString)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear:\(typeString)")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidDisappear:\(typeString)")
    }

    @objc func headerRefresh() {
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            self.refreshControl?.endRefreshing()
            self.dataSource.removeAll()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let dateString = dateFormatter.string(from: Date())
            for index in 0..<20 {
                self.dataSource.append(String(format: "%@ 时间：%@ index:%d", self.typeString, dateString, index))
            }
            self.isDataLoaded = true
            self.tableView.reloadData()
        }
    }

    //MARK: - UITableViewDataSource & UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LoadDataDetailViewController()
        vc.detailText = dataSource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoadDataListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {
        //因为`JXSegmentedListContainerView`内部通过`UICollectionView`的cell加载列表。当切换tab的时候，之前的列表所在的cell就被回收到缓存池，就会从视图层级树里面被剔除掉，即没有显示出来且不在视图层级里面。这个时候MJRefreshHeader所持有的UIActivityIndicatorView就会被设置hidden。所以需要在列表显示的时候，且isRefreshing==YES的时候，再让UIActivityIndicatorView重新开启动画。
//        if (self.tableView.mj_header.isRefreshing) {
//            UIActivityIndicatorView *activity = [self.tableView.mj_header valueForKey:@"loadingView"];
//            [activity startAnimating];
//        }
        if refreshControl?.isRefreshing == true {
            refreshControl?.beginRefreshing()
        }
//        print("listDidAppear")
    }

    func listDidDisappear() {
//        print("listDidDisappear")
    }
}
