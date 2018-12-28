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

    open func reloadData(selectedIndex: Int) {
        dataSource.removeAll()
    }

    open func preferredItemModelInstance() -> JXSegmentedBaseItemModel  {
        return JXSegmentedBaseItemModel()
    }

    //MARK: - JXSegmentedViewDataSource
    open func dataSource(in segmentedView: JXSegmentedView) -> [JXSegmentedBaseItemModel] {
        return [JXSegmentedBaseItemModel]()
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

    }

    open func refreshItemModel(leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: Double) {

    }
}
