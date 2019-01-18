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
    /// 使用titleSelectedFont时就不要使用isTitleZoomEnabled、isTitleLineWidthEnabled
    open var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// title的颜色是否渐变过渡
    open var isTitleColorGradientEnabled: Bool = false
    /// title是否缩放。使用该特性时，务必保证titleFont和titleSelectedFont一致。
    open var isTitleZoomEnabled: Bool = false
    /// isTitleZoomEnabled为true才生效。是对字号的缩放，比如titleFont的pointSize为10，放大之后字号就是10*1.3=13。
    open var titleZoomScale: CGFloat = 1.3
    /// title的字体粗细是否变化。使用该特性时，务必保证titleFont和titleSelectedFont一致。
    open var isTitleLineWidthEnabled: Bool = false
    open var titleSelectedLineWidth: CGFloat = 0.3
    /// titleLabel是否使用遮罩过渡
    open var isTitleMaskEnabled: Bool = false

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for (index, _) in titles.enumerated() {
            let itemModel = preferredItemModelInstance()
            refreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
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
            leftModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: titleZoomScale, to: 1, percent: CGFloat(percent))
            rightModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: 1, to: titleZoomScale, percent: CGFloat(percent))
        }

        if isTitleLineWidthEnabled {
            leftModel.titleSelectedLineWidth = JXSegmentedViewTool.interpolate(from: titleSelectedLineWidth, to: 0, percent: CGFloat(percent))
            rightModel.titleSelectedLineWidth = JXSegmentedViewTool.interpolate(from: 0, to: titleSelectedLineWidth, percent: CGFloat(percent))
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
        myCurrentSelectedItemModel.titleCurrentZoomScale = 1
        myCurrentSelectedItemModel.titleSelectedLineWidth = 0
        myCurrentSelectedItemModel.indicatorConvertToItemFrame = CGRect.zero

        myWilltSelectedItemModel.titleColor = titleColor
        myWilltSelectedItemModel.titleSelectedColor = titleSelectedColor
        myWilltSelectedItemModel.titleCurrentZoomScale = titleZoomScale
        myWilltSelectedItemModel.titleSelectedLineWidth = titleSelectedLineWidth
    }

    open override func refreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        guard let itemModel = itemModel as? JXSegmentedTitleItemModel else {
            return
        }

        itemModel.title = titles[index]
        itemModel.titleColor = titleColor
        itemModel.titleSelectedColor = titleSelectedColor
        itemModel.titleFont = titleFont
        itemModel.titleSelectedFont = titleSelectedFont
        itemModel.isTitleZoomEnabled = isTitleZoomEnabled
        itemModel.isTitleLineWidthEnabled = isTitleLineWidthEnabled
        itemModel.isTitleMaskEnabled = isTitleMaskEnabled
        itemModel.titleMaxZoomScale = titleZoomScale
        if index == selectedIndex {
            itemModel.titleCurrentZoomScale = titleZoomScale
            itemModel.titleSelectedLineWidth = titleSelectedLineWidth
        }else {
            itemModel.titleCurrentZoomScale = 1
            itemModel.titleSelectedLineWidth = 0
        }
    }
}
