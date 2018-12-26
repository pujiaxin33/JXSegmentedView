//
//  JXSegmentedTitleCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleCell: JXSegmentedBaseCell {
    open var titleLabel = UILabel()

    open override func commonInit() {
        super.commonInit()

        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = contentView.bounds
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, isClicked: Bool) {
        super.reloadData(itemModel: itemModel, isClicked: isClicked)

        guard let myItemModel = itemModel as? JXSegmentedTitleItemModel else {
            return
        }
        titleLabel.text = myItemModel.title
    }
}
