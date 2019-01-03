//
//  JXSegmentedTitleView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleDataSource: JXSegmentedBaseDataSource{
    open var titles = [String]()
    open var titleColor: UIColor = .black
    open var titleSelectedColor: UIColor = .red
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    open var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    open var isTitleColorGradientEnabled: Bool = false  //title的颜色是否渐变过渡
    open var isTitleZoomEnabled: Bool = false  //title是否缩放。使用该属性，务必让titleFont和titleSelectedFont设置为一样的！！！
    open var titleZoomScale: Double = 1.2   //isTitleZoomEnabled为true才生效
    open var isTitleStrokeWidthEnabled: Bool = false
    open var titleSelectedStrokeWidth: Double = -2  //用于控制字体的粗细（底层通过NSStrokeWidthAttributeName实现）。使用该属性，务必让titleFont和titleSelectedFont设置为一样的！！！
    /// titleLabel是否使用遮罩过渡
    open var isTitleMaskEnabled: Bool = false

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for (index, title) in titles.enumerated() {
            let itemModel = preferredItemModelInstance() as! JXSegmentedTitleItemModel
            itemModel.title = title
            itemModel.titleColor = titleColor
            itemModel.titleSelectedColor = titleSelectedColor
            itemModel.titleFont = titleFont
            itemModel.titleSelectedFont = titleSelectedFont
            itemModel.isTitleZoomEnabled = isTitleZoomEnabled
            itemModel.isTitleStrokeWidthEnabled = isTitleStrokeWidthEnabled
            itemModel.isTitleMaskEnabled = isTitleMaskEnabled
            if index == selectedIndex {
                itemModel.titleZoomScale = titleZoomScale
                itemModel.titleSelectedStrokeWidth = titleSelectedStrokeWidth
            }else {
                itemModel.titleZoomScale = 1
                itemModel.titleSelectedStrokeWidth = 0
            }
            dataSource.append(itemModel)
        }
    }

    //MARK: - JXSegmentedViewDataSource
    open override func segmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        if itemContentWidth == JXSegmentedViewAutomaticDimension {
            if let title = (dataSource[index] as? JXSegmentedTitleItemModel)?.title {
                let textWidth = NSString(string: title).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: segmentedView.bounds.size.height), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: [NSAttributedString.Key.font : titleFont], context: nil).size.width
                return CGFloat(ceilf(Float(textWidth))) + itemWidthIncrement
            }
        }
        return itemContentWidth + itemWidthIncrement
    }

    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.register(JXSegmentedTitleCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: Double) {
        guard let leftModel = leftItemModel as? JXSegmentedTitleItemModel, let rightModel = rightItemModel as? JXSegmentedTitleItemModel else {
            return
        }

        if isTitleZoomEnabled {
            leftModel.titleZoomScale = JXSegmentedViewTool.interpolate(from: titleZoomScale, to: 1, percent: percent)
            rightModel.titleZoomScale = JXSegmentedViewTool.interpolate(from: 1, to: titleZoomScale, percent: percent)
        }

        if isTitleStrokeWidthEnabled {
            leftModel.titleSelectedStrokeWidth = JXSegmentedViewTool.interpolate(from: titleSelectedStrokeWidth, to: 0, percent: percent)
            rightModel.titleSelectedStrokeWidth = JXSegmentedViewTool.interpolate(from: 0, to: titleSelectedStrokeWidth, percent: percent)
        }

        if isTitleColorGradientEnabled {
            if leftModel.isSelected {
                leftModel.titleSelectedColor = JXSegmentedViewTool.interpolateColor(from: titleSelectedColor, to: titleColor, percent: percent)
                leftModel.titleColor = titleColor
            }else {
                leftModel.titleColor = JXSegmentedViewTool.interpolateColor(from: titleSelectedColor, to: titleColor, percent: percent)
                leftModel.titleSelectedColor = titleSelectedColor
            }
            if rightModel.isSelected {
                rightModel.titleSelectedColor = JXSegmentedViewTool.interpolateColor(from:titleColor , to:titleSelectedColor, percent: percent)
                rightModel.titleColor = titleColor
            }else {
                rightModel.titleColor = JXSegmentedViewTool.interpolateColor(from: titleColor, to:titleSelectedColor , percent: percent)
                rightModel.titleSelectedColor = titleSelectedColor
            }
        }
    }

    open override func refreshItemModel(currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel) {
        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleItemModel, let myWilltSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleItemModel else {
            return
        }

        myCurrentSelectedItemModel.titleColor = titleColor
        myCurrentSelectedItemModel.titleSelectedColor = titleSelectedColor
        myCurrentSelectedItemModel.titleZoomScale = 1
        myCurrentSelectedItemModel.titleSelectedStrokeWidth = 0
        myCurrentSelectedItemModel.indicatorConvertToItemFrame = CGRect.zero

        myWilltSelectedItemModel.titleColor = titleColor
        myWilltSelectedItemModel.titleSelectedColor = titleSelectedColor
        myWilltSelectedItemModel.titleZoomScale = titleZoomScale
        myWilltSelectedItemModel.titleSelectedStrokeWidth = titleSelectedStrokeWidth
    }
}
