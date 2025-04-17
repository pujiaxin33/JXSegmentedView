//
//  JXSegmentedDotCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedDotCell: JXSegmentedTitleCell {
    open var dotView = UIView()

    open override func commonInit() {
        super.commonInit()

        contentView.addSubview(dotView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? JXSegmentedDotItemModel else {
            return
        }

        dotView.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.dotOffset.x, y: titleLabel.frame.minY + myItemModel.dotOffset.y)
        
        /// fix issue #167: 标题 只有小红点的话，显示的时候红点🔴会有被切掉的感觉，不是圆形展示
        /// 原因：iOS设备的屏幕分辨率通常使用整数像素来进行渲染。带有小数点的坐标可能导致视图位置的像素对齐不精确，尤其是在某些较低分辨率的屏幕上，可能会导致视图边缘不平整，圆角部分被切割掉。
        /// 解决方案：起始点取整
        dotView.frame.origin.x = round(dotView.frame.origin.x)
        dotView.frame.origin.y = round(dotView.frame.origin.y)
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedDotItemModel else {
            return
        }

        dotView.backgroundColor = myItemModel.dotColor
        dotView.bounds = CGRect(x: 0, y: 0, width: myItemModel.dotSize.width, height: myItemModel.dotSize.height)
        dotView.isHidden = !myItemModel.dotState
        dotView.layer.cornerRadius = myItemModel.dotCornerRadius
    }
}
