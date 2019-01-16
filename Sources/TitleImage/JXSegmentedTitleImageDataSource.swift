//
//  JXSegmentedTitleImageDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public enum JXSegmentedTitleImageType {
    case topImage
    case leftImage
    case bottomImage
    case rightImage
    case onlyImage
    case onlyTitle
}

public typealias LoadImageClosure = ((UIImageView, String) -> Void)

open class JXSegmentedTitleImageDataSource: JXSegmentedTitleDataSource {
    open var titleImageType: JXSegmentedTitleImageType = .rightImage
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片地址
    open var imageInfos: [String]?
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片地址。如果不赋值，选中时就不会处理图片切换。
    open var selectedImageInfos: [String]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    open var loadImageClosure: LoadImageClosure?
    open var imageSize: CGSize = CGSize(width: 20, height: 20)
    /// title和image之间的间隔。title和image的center默认水平对齐或者垂直对齐
    open var titleImageSpacing: CGFloat = 5
    open var isImageZoomEnabled: Bool = false
    open var imageZoomScale: CGFloat = 1.2

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleImageItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for (index, itemModel) in (dataSource as! [JXSegmentedTitleImageItemModel]).enumerated() {
            refreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
        }
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.register(JXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var itemWidth = super.segmentedView(segmentedView, widthForItemAt: index)
        switch titleImageType {
            case .leftImage, .rightImage:
                itemWidth += titleImageSpacing + imageSize.width
            case .topImage, .bottomImage:
                itemWidth = max(itemWidth, imageSize.width)
            case .onlyImage:
                itemWidth = imageSize.width
            case .onlyTitle:
                itemWidth = itemWidth * 1
        }
        return itemWidth
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: Double) {
        super.refreshItemModel(leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let leftModel = leftItemModel as? JXSegmentedTitleImageItemModel, let rightModel = rightItemModel as? JXSegmentedTitleImageItemModel else {
            return
        }
        if isImageZoomEnabled {
            leftModel.imageZoomScale = JXSegmentedViewTool.interpolate(from: imageZoomScale, to: 1, percent: CGFloat(percent))
            rightModel.imageZoomScale = JXSegmentedViewTool.interpolate(from: 1, to: imageZoomScale, percent: CGFloat(percent))
        }
    }

    open override func refreshItemModel(currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel) {
        super.refreshItemModel(currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleImageItemModel, let myWilltSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        myCurrentSelectedItemModel.imageZoomScale = 1
        if isImageZoomEnabled {
            myWilltSelectedItemModel.imageZoomScale = imageZoomScale
        }else {
            myWilltSelectedItemModel.imageZoomScale = 1
        }
    }

    open override func refreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.refreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        itemModel.titleImageType = titleImageType
        itemModel.imageInfo = imageInfos?[index]
        itemModel.selectedImageInfo = selectedImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
        itemModel.isImageZoomEnabled = isImageZoomEnabled
        if index == selectedIndex {
            itemModel.imageZoomScale = imageZoomScale
        }else {
            itemModel.imageZoomScale = 1
        }
    }
}
