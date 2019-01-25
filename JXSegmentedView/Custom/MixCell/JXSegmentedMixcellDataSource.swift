//
//  JXSegmentedMixcellDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

/// 该示例主要用于展示cell的自定义组合。就像使用UITableView一样，注册不同的cell class，为不同的cell赋值。
/// 当你的需求需要处理不同类型的cell时，可以参考这里的逻辑。但是数据源这一块就需要你自己处理了。
/// 多种cell混用时，不建议处理cell之间元素的过渡。所以该示例也没有处理滚动过渡。
class JXSegmentedMixcellDataSource: JXSegmentedBaseDataSource {

    override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        let titleModel = JXSegmentedTitleItemModel()
        titleModel.title = "我只是title"
        titleModel.isSelected = true
        titleModel.titleCurrentColor = titleModel.titleSelectedColor
        dataSource.append(titleModel)

        let titleImageModel = JXSegmentedTitleImageItemModel()
        titleImageModel.title = "图片"
        titleImageModel.imageInfo = "dog"
        dataSource.append(titleImageModel)

        let numberModel = JXSegmentedNumberItemModel()
        numberModel.title = "数字"
        numberModel.number = 33
        numberModel.numberString = "33"
        dataSource.append(numberModel)

        let dotModel = JXSegmentedDotItemModel()
        dotModel.title = "红点"
        dotModel.dotState = true
        dataSource.append(dotModel)
    }

    override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        //根据不同的cell类型返回对应的cell宽度
        var otherWidth: CGFloat = 0
        var title: String?
        var titleFont: UIFont?
        if let itemModel = dataSource[index] as? JXSegmentedTitleItemModel {
            title = itemModel.title
            titleFont = itemModel.titleFont
        }else if let itemModel = dataSource[index] as? JXSegmentedTitleImageItemModel {
            title = itemModel.title
            titleFont = itemModel.titleFont
            otherWidth += itemModel.titleImageSpacing + itemModel.imageSize.width
        }else if let itemModel = dataSource[index] as? JXSegmentedNumberItemModel {
            title = itemModel.title
            titleFont = itemModel.titleFont
        }else if let itemModel = dataSource[index] as? JXSegmentedDotItemModel {
            title = itemModel.title
            titleFont = itemModel.titleFont
        }

        let textWidth = NSString(string: title!).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: segmentedView.bounds.size.height), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), attributes: [NSAttributedString.Key.font : titleFont!], context: nil).size.width
        let itemWidth = CGFloat(ceilf(Float(textWidth))) + itemWidthIncrement + otherWidth
        return itemWidth
    }

    //MARK: - JXSegmentedViewDataSource
    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.register(JXSegmentedTitleCell.self, forCellWithReuseIdentifier: "titleCell")
        segmentedView.register(JXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "titleImageCell")
        segmentedView.register(JXSegmentedNumberCell.self, forCellWithReuseIdentifier: "numberCell")
        segmentedView.register(JXSegmentedDotCell.self, forCellWithReuseIdentifier: "dotCell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        var cell:JXSegmentedBaseCell?
        if dataSource[index] is JXSegmentedTitleImageItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleImageCell", at: index)
        }else if dataSource[index] is JXSegmentedNumberItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "numberCell", at: index)
        }else if dataSource[index] is JXSegmentedDotItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "dotCell", at: index)
        }else if dataSource[index] is JXSegmentedTitleItemModel {
            cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "titleCell", at: index)
        }
        return cell!
    }

    //针对不同的cell处理选中态和未选中态的刷新
    override func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleItemModel, let myWilltSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleItemModel else {
            return
        }

        myCurrentSelectedItemModel.titleCurrentColor = myCurrentSelectedItemModel.titleNormalColor

        myWilltSelectedItemModel.titleCurrentColor = myWilltSelectedItemModel.titleSelectedColor
    }
}
