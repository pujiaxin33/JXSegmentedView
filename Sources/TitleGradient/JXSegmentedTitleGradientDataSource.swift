//
//  JXSegmentedTitleGradientDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleGradientDataSource: JXSegmentedTitleDataSource {
    open var titleGradientColors: [CGColor] = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
    open var titleSelectedGradientColors: [CGColor] = [UIColor(red: 18/255.0, green: 194/255.0, blue: 233/255.0, alpha: 1).cgColor, UIColor(red: 196/255.0, green: 113/255.0, blue: 237/255.0, alpha: 1).cgColor, UIColor(red: 246/255.0, green: 79/255.0, blue: 89/255.0, alpha: 1).cgColor]
    open var titleGradientStartPoint: CGPoint = CGPoint(x: 0, y: 0)
    open var titleGradientEndPoint: CGPoint = CGPoint(x: 1, y: 0)

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleGradientItemModel()
    }

    open override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleGradientItemModel else {
            return
        }

        itemModel.titleGradientStartPoint = titleGradientStartPoint
        itemModel.titleGradientEndPoint = titleGradientEndPoint
        itemModel.titleDefaultGradientColors = titleGradientColors
        itemModel.titleSelectedGradientColors = titleSelectedGradientColors
        if index == selectedIndex {
            itemModel.titleCurrentGradientColors = itemModel.titleSelectedGradientColors
        }else {
            itemModel.titleCurrentGradientColors = itemModel.titleDefaultGradientColors
        }
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.register(JXSegmentedTitleGradientCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(_ segmentedView: JXSegmentedView, leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let leftModel = leftItemModel as? JXSegmentedTitleGradientItemModel, let rightModel = rightItemModel as? JXSegmentedTitleGradientItemModel else {
            return
        }

        if isTitleColorGradientEnabled && isItemTransitionEnabled {
            leftModel.titleCurrentGradientColors = JXSegmentedViewTool.interpolateColors(from: leftModel.titleSelectedGradientColors, to: leftModel.titleDefaultGradientColors, percent: percent)
            rightModel.titleCurrentGradientColors = JXSegmentedViewTool.interpolateColors(from: rightModel.titleDefaultGradientColors, to: rightModel.titleSelectedGradientColors, percent: percent)
        }
    }

    open override func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleGradientItemModel, let myWilltSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleGradientItemModel else {
            return
        }

        myCurrentSelectedItemModel.titleCurrentGradientColors = myCurrentSelectedItemModel.titleDefaultGradientColors
        myWilltSelectedItemModel.titleCurrentGradientColors = myWilltSelectedItemModel.titleSelectedGradientColors
    }
}
