//
//  LoadDataCustomListViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class LoadDataCustomListViewController: UITableViewController {
    var typeString: String = ""
    weak var naviController: UINavigationController?
    private var dataSource = [String]()
    private var isDataLoaded = false
    private var isRequesting = false

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        refreshControl?.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func loadDataForFirst() {
        if !isDataLoaded {
            //为什么要手动设置contentoffset：https://stackoverflow.com/questions/14718850/uirefreshcontrol-beginrefreshing-not-working-when-uitableviewcontroller-is-ins
            tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl!.bounds.size.height), animated: true)
            headerRefresh()
        }
    }

    @objc func headerRefresh() {
        guard !isRequesting else {
            return
        }

        isRequesting = true
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
            self.isRequesting = false
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
        naviController?.pushViewController(vc, animated: true)
    }
}
