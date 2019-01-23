//
//  JXSegmentedTitleImageCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleImageCell: JXSegmentedTitleCell {
    open var imageView = UIImageView()
    private var currentImageInfo: String?

    open override func prepareForReuse() {
        super.prepareForReuse()

        currentImageInfo = nil
    }

    open override func commonInit() {
        super.commonInit()

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        let imageSize = myItemModel.imageSize
        switch myItemModel.titleImageType {
            case .topImage:
                let contentHeight = imageSize.height + myItemModel.titleImageSpacing + titleLabel.bounds.size.height
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - contentHeight)/2 + imageSize.height/2)
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: imageView.frame.maxY + myItemModel.titleImageSpacing + titleLabel.bounds.size.height/2)
            case .leftImage:
                let contentWidth = imageSize.width + myItemModel.titleImageSpacing + titleLabel.bounds.size.width
                imageView.center = CGPoint(x: (contentView.bounds.size.width - contentWidth)/2 + imageSize.width/2, y: contentView.bounds.size.height/2)
                titleLabel.center = CGPoint(x: imageView.frame.maxX + myItemModel.titleImageSpacing + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
            case .bottomImage:
                let contentHeight = imageSize.height + myItemModel.titleImageSpacing + titleLabel.bounds.size.height
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - contentHeight)/2 + titleLabel.bounds.size.height/2)
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: titleLabel.frame.maxY + myItemModel.titleImageSpacing + imageSize.height/2)
            case .rightImage:
                let contentWidth = imageSize.width + myItemModel.titleImageSpacing + titleLabel.bounds.size.width
                titleLabel.center = CGPoint(x: (contentView.bounds.size.width - contentWidth)/2 + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
                imageView.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.titleImageSpacing + imageSize.width/2, y: contentView.bounds.size.height/2)
            case .onlyImage:
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
            case .onlyTitle:
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
        }
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        titleLabel.isHidden = false
        imageView.isHidden = false
        if myItemModel.titleImageType == .onlyTitle {
            imageView.isHidden = true
        }else if myItemModel.titleImageType == .onlyImage {
            titleLabel.isHidden = true
        }

        imageView.bounds = CGRect(x: 0, y: 0, width: myItemModel.imageSize.width, height: myItemModel.imageSize.height)

        var imageInfo = myItemModel.imageInfo
        if myItemModel.isSelected && myItemModel.selectedImageInfo != nil {
            imageInfo = myItemModel.selectedImageInfo
        }

        //因为`func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType)`方法会回调多次，尤其是左右滚动的时候会调用无数次。如果每次都触发图片加载，会非常消耗性能。所以只会在图片发生了变化的时候，才进行图片加载。
        if imageInfo != nil && imageInfo != currentImageInfo {
            currentImageInfo = imageInfo
            if myItemModel.loadImageClosure != nil {
                myItemModel.loadImageClosure!(imageView, imageInfo!)
            }else {
                imageView.image = UIImage(named: imageInfo!)
            }
        }

        if myItemModel.isImageZoomEnabled {
            imageView.transform = CGAffineTransform(scaleX: myItemModel.imageCurrentZoomScale, y: myItemModel.imageCurrentZoomScale)
        }else {
            imageView.transform = .identity
        }

        setNeedsLayout()
    }
}
