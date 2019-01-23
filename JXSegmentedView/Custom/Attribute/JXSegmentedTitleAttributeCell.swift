//
//  JXSegmentedTitleAttributeCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleAttributeCell: JXSegmentedBaseCell {
    var titleLabel = UILabel()

    override func commonInit() {
        super.commonInit()

        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.center = contentView.center
    }

    override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedTitleAttributeItemModel else {
            return
        }

        if myItemModel.isSelected && myItemModel.selectedAttributeTitle != nil {
            titleLabel.attributedText = myItemModel.selectedAttributeTitle
        }else {
            titleLabel.attributedText = myItemModel.attributeTitle
        }

        titleLabel.sizeToFit()
        setNeedsLayout()
    }
}
