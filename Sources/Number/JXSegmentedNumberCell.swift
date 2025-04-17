//
//  JXSegmentedNumberCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedNumberCell: JXSegmentedTitleCell {
    public let numberLabel = UILabel()

    open override func commonInit() {
        super.commonInit()

        numberLabel.isHidden = true
        numberLabel.textAlignment = .center
        numberLabel.layer.masksToBounds = true
        contentView.addSubview(numberLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? JXSegmentedNumberItemModel else {
            return
        }

        numberLabel.sizeToFit()
        let height = myItemModel.numberHeight
        /// fix issue #167: JXSegmentedNumberDataSource 当number为1234567890一位数字宽度不一致时，小红点不是圆形
        /// 解决方案：新增红点的最小宽度属性，就保证一位数的红点是圆的
        let width = max(myItemModel.numberMinimumWidth, numberLabel.bounds.size.width + myItemModel.numberWidthIncrement)
        numberLabel.layer.cornerRadius = height/2
        numberLabel.bounds.size = CGSize(width: width, height: height)
        numberLabel.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.numberOffset.x, y: titleLabel.frame.minY + myItemModel.numberOffset.y)
        
        /// fix: iOS设备的屏幕分辨率通常使用整数像素来进行渲染。带有小数点的坐标可能导致视图位置的像素对齐不精确，尤其是在某些较低分辨率的屏幕上，可能会导致视图边缘不平整，圆角部分被切割掉。
        numberLabel.frame.origin.x = round(numberLabel.frame.origin.x)
        numberLabel.frame.origin.y = round(numberLabel.frame.origin.y)
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedNumberItemModel else {
            return
        }

        numberLabel.backgroundColor = myItemModel.numberBackgroundColor
        numberLabel.textColor = myItemModel.numberTextColor
        numberLabel.text = myItemModel.numberString
        numberLabel.font = myItemModel.numberFont
        numberLabel.isHidden = myItemModel.number == 0

        setNeedsLayout()
    }
}
