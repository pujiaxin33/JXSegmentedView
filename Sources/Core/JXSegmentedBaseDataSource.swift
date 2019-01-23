//
//  JXSegmentedBaseDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import  UIKit

open class JXSegmentedBaseDataSource: JXSegmentedViewDataSource {
    /// cell的内容宽度，为JXSegmentedViewAutomaticDimension时就以内容计算的宽度为准，否则以itemContentWidth的具体值为准。
    open var itemContentWidth: CGFloat = JXSegmentedViewAutomaticDimension
    /// 真实的item宽度 = itemContentWidth + itemWidthIncrement。
    open var itemWidthIncrement: CGFloat = 0
    open var dataSource = [JXSegmentedBaseItemModel]()
    /// item左右滚动过渡时，是否允许渐变。比如JXSegmentedTitleDataSource的titleZoom、titleColor、titleStrokeWidth等渐变。
    open var isItemTransitionEnabled: Bool = true
    /// 选中的时候，是否需要动画过渡。自定义的cell需要自己处理动画过渡逻辑，动画处理逻辑参考`JXSegmentedTitleCell`
    open var isSelectedAnimable: Bool = false
    open var selectedAnimationDuration: TimeInterval = 0.25

    /// 配置完各种属性之后，需要手动调用该方法，更新数据源
    ///
    /// - Parameter selectedIndex: 当前选中的index
    open func reloadData(selectedIndex: Int) {
        dataSource.removeAll()
    }

    /// 子类需要重载该方法，用于返回自己定义的JXSegmentedBaseItemModel子类实例
    ///
    /// - Returns: JXSegmentedBaseItemModel子类实例
    open func preferredItemModelInstance() -> JXSegmentedBaseItemModel  {
        return JXSegmentedBaseItemModel()
    }

    //MARK: - JXSegmentedViewDataSource
    open func dataSource(in segmentedView: JXSegmentedView) -> [JXSegmentedBaseItemModel] {
        return dataSource
    }

    open func segmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        return itemWidthIncrement
    }

    open func registerCellClass(in segmentedView: JXSegmentedView) {

    }

    open func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        return JXSegmentedBaseCell()
    }

    open func refreshItemModel(currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel) {
        currentSelectedItemModel.isSelected = false

        willSelectedItemModel.isSelected = true
    }

    open func refreshItemModel(leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat) {

    }

    open func refreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        itemModel.index = index
        itemModel.isItemTransitionEnabled = isItemTransitionEnabled
        itemModel.isSelectedAnimable = isSelectedAnimable
        itemModel.selectedAnimationDuration = selectedAnimationDuration
        if index == selectedIndex {
            itemModel.isSelected = true
        }else {
            itemModel.isSelected = false
        }
    }
}
