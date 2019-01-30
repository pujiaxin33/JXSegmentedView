//
//  JXSegmentedTitleAttributeDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleAttributeDataSource: JXSegmentedBaseDataSource {
    var attributeTitles = [NSAttributedString]()
    /// 选中时的富文本，可选。如果要使用确保count与attributeTitles一致。
    var selectedAttributeTitles: [NSAttributedString]?
    var titleNumberOfLines: Int = 2

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleAttributeItemModel()
    }

    override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for index in 0..<attributeTitles.count {
            let itemModel = preferredItemModelInstance() as! JXSegmentedTitleAttributeItemModel
            preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
            dataSource.append(itemModel)
        }
    }

    override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let myItemModel = itemModel as? JXSegmentedTitleAttributeItemModel else {
            return
        }

        myItemModel.attributeTitle = attributeTitles[index]
        myItemModel.selectedAttributeTitle = selectedAttributeTitles?[index]
        myItemModel.titleNumberOfLines = titleNumberOfLines
    }

    override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var itemWidth: CGFloat = 0
        if itemContentWidth == JXSegmentedViewAutomaticDimension {
            let myItemModel = dataSource[index] as? JXSegmentedTitleAttributeItemModel
            let attriText = myItemModel?.selectedAttributeTitle != nil ? myItemModel?.selectedAttributeTitle : myItemModel?.attributeTitle
            if let title = attriText {
                let textWidth = title.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: segmentedView.bounds.size.height), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil).size.width
                itemWidth = CGFloat(ceilf(Float(textWidth))) + itemWidthIncrement
            }
        }else {
            itemWidth = itemContentWidth + itemWidthIncrement
        }
        return itemWidth
    }

    //MARK: - JXSegmentedViewDataSource
    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedTitleAttributeCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
