//
//  PagingListBaseCell.swift
//  JXSegmentedViewExample
//
//  Created by blue on 2020/6/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

class PagingListBaseCell: UITableViewCell {

    private(set) lazy var titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        contentView.addSubview(titleLabel)

        let leading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 10)
        let top = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leading, top])
    }

}
