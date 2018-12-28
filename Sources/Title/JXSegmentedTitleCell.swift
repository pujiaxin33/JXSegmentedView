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

        titleLabel.center = contentView.center
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, isClicked: Bool) {
        super.reloadData(itemModel: itemModel, isClicked: isClicked)

        guard let myItemModel = itemModel as? JXSegmentedTitleItemModel else {
            return
        }
        titleLabel.text = myItemModel.title
        if isClicked {
            if itemModel.isSelected {
                UIView.animate(withDuration: 0.5) {
                    self.titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }
            }else {
                UIView.animate(withDuration: 0.5) {
                    self.titleLabel.transform = CGAffineTransform.identity
                }
            }
        }else {
            titleLabel.font = myItemModel.titleFont
        }

        let title = myItemModel.title ?? ""
        let attriText = NSMutableAttributedString(string: title)
        if myItemModel.isTitleStrokeWidthEnabled {
            attriText.addAttributes([NSAttributedString.Key.strokeWidth: myItemModel.titleSelectedStrokeWidth], range: NSRange(location: 0, length: title.count))
        }

        if myItemModel.isSelected {
            titleLabel.textColor = myItemModel.titleSelectedColor
        }else {
            titleLabel.textColor = myItemModel.titleColor
        }

        titleLabel.attributedText = attriText
        titleLabel.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
