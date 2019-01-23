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
    var selectedAttributeTitles = [NSAttributedString]()

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleAttributeItemModel()
    }

    override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for index in 0..<attributeTitles.count {
            let itemModel = preferredItemModelInstance() as! JXSegmentedTitleAttributeItemModel
            itemModel.attributeTitle = attributeTitles[index]
            itemModel.selectedAttributeTitle = selectedAttributeTitles[index]
            dataSource.append(itemModel)
        }
    }

    override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var itemWidth: CGFloat = 0
        if itemContentWidth == JXSegmentedViewAutomaticDimension {
            if let title = (dataSource[index] as? JXSegmentedTitleAttributeItemModel)?.attributeTitle {
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
        segmentedView.register(JXSegmentedTitleAttributeCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
