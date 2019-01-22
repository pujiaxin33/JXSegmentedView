//
//  JXSegmentedTitleOrImageDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleOrImageDataSource: JXSegmentedTitleDataSource {
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片地址。选中时不显示图片就填""空字符串
    open var selectedImageInfos: [String]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    open var loadImageClosure: LoadImageClosure?
    open var imageSize: CGSize = CGSize(width: 30, height: 30)

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleOrImageItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for (index, itemModel) in (dataSource as! [JXSegmentedTitleOrImageItemModel]).enumerated() {
            refreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
        }
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.register(JXSegmentedTitleOrImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        return super.segmentedView(segmentedView, widthForItemAt: index)
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.refreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return
        }

        itemModel.selectedImageInfo = selectedImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
    }
}
