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
    /// title默认的textColor
    open var titleColor: UIColor = .black
    /// title选中的textColor
    open var titleSelectedColor: UIColor = .red
    /// title默认状态时的字体
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// title选中时的字体
    open var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// title的颜色是否渐变过渡
    open var isTitleColorGradientEnabled: Bool = false
    /// title是否缩放。使用该效果时，务必保证titleFont和titleSelectedFont值相同。
    open var isTitleZoomEnabled: Bool = false
    /// isTitleZoomEnabled为true才生效。是对字号的缩放，比如titleFont的pointSize为10，放大之后字号就是10*1.2=12。
    open var titleZoomScale: CGFloat = 1.2
    /// title的线宽是否允许粗细。使用该效果时，务必保证titleFont和titleSelectedFont值相同。
    open var isTitleStrokeWidthEnabled: Bool = false
    /// 用于控制字体的粗细（底层通过NSStrokeWidthAttributeName实现），负数越小字体越粗。
    open var titleSelectedStrokeWidth: CGFloat = -2
    /// title是否使用遮罩过渡
    open var isTitleMaskEnabled: Bool = false

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for (index, _) in titles.enumerated() {
            let itemModel = preferredItemModelInstance()
            preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
            dataSource.append(itemModel)
        }
    }

    open override func preferredRefreshItemModel( _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleItemModel else {
            return
        }

        itemModel.title = titles[index]
        itemModel.isSelectedAnimable = isSelectedAnimable
        itemModel.titleColor = titleColor
        itemModel.titleSelectedColor = titleSelectedColor
        itemModel.titleFont = titleFont
        itemModel.titleSelectedFont = titleSelectedFont
        itemModel.isTitleZoomEnabled = isTitleZoomEnabled
        itemModel.isTitleStrokeWidthEnabled = isTitleStrokeWidthEnabled
        itemModel.isTitleMaskEnabled = isTitleMaskEnabled
        itemModel.titleDefaultZoomScale = 1
        itemModel.titleSelectedZoomScale = titleZoomScale
        itemModel.titleSelectedStrokeWidth = titleSelectedStrokeWidth
        itemModel.titleDefaultStrokeWidth = 0
        if index == selectedIndex {
            itemModel.titleCurrentColor = titleSelectedColor
            itemModel.titleCurrentZoomScale = titleZoomScale
            itemModel.titleCurrentStrokeWidth = titleSelectedStrokeWidth
        }else {
            itemModel.titleCurrentColor = titleColor
            itemModel.titleCurrentZoomScale = 1
            itemModel.titleCurrentStrokeWidth = 0
        }
    }

    open override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var itemWidth = super.preferredSegmentedView(segmentedView, widthForItemAt: index)
        if itemContentWidth == JXSegmentedViewAutomaticDimension {
            if let title = (dataSource[index] as? JXSegmentedTitleItemModel)?.title {
                let textWidth = NSString(string: title).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: segmentedView.bounds.size.height), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: [NSAttributedString.Key.font : titleFont], context: nil).size.width
                itemWidth += CGFloat(ceilf(Float(textWidth)))
            }
        }else {
            itemWidth += itemContentWidth
        }
        return itemWidth
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.register(JXSegmentedTitleCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(_ segmentedView: JXSegmentedView, leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)
        
        guard let leftModel = leftItemModel as? JXSegmentedTitleItemModel, let rightModel = rightItemModel as? JXSegmentedTitleItemModel else {
            return
        }

        if isTitleZoomEnabled && isItemTransitionEnabled {
            leftModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: titleZoomScale, to: 1, percent: CGFloat(percent))
            rightModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: 1, to: titleZoomScale, percent: CGFloat(percent))
        }

        if isTitleStrokeWidthEnabled && isItemTransitionEnabled {
            leftModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: titleSelectedStrokeWidth, to: 0, percent: CGFloat(percent))
            rightModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: 0, to: titleSelectedStrokeWidth, percent: CGFloat(percent))
        }

        if isTitleColorGradientEnabled && isItemTransitionEnabled {
            if leftModel.isSelected {
                leftModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: titleSelectedColor, to: titleColor, percent: percent)
            }else {
                leftModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: titleSelectedColor, to: titleColor, percent: percent)
            }
            if rightModel.isSelected {
                rightModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from:titleColor , to:titleSelectedColor, percent: percent)
            }else {
                rightModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: titleColor, to:titleSelectedColor , percent: percent)
            }
        }
    }

    open override func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleItemModel, let myWilltSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleItemModel else {
            return
        }

        myCurrentSelectedItemModel.titleCurrentColor = titleColor
        myCurrentSelectedItemModel.titleCurrentZoomScale = 1
        myCurrentSelectedItemModel.titleCurrentStrokeWidth = 0
        myCurrentSelectedItemModel.indicatorConvertToItemFrame = CGRect.zero

        myWilltSelectedItemModel.titleCurrentColor = titleSelectedColor
        myWilltSelectedItemModel.titleCurrentZoomScale = titleZoomScale
        myWilltSelectedItemModel.titleCurrentStrokeWidth = titleSelectedStrokeWidth
    }
}
