//
//  JXSegmentedTitleOrImageCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleOrImageCell: JXSegmentedTitleCell {
    var imageView = UIImageView()
    private var currentImageInfo: String?

    override func prepareForReuse() {
        super.prepareForReuse()

        currentImageInfo = nil
    }

    override func commonInit() {
        super.commonInit()

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.center = contentView.center
    }

    override func reloadData(itemModel: JXSegmentedBaseItemModel, isClicked: Bool) {
        super.reloadData(itemModel: itemModel, isClicked: isClicked)

        guard let myItemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return
        }

        if myItemModel.isSelected && myItemModel.selectedImageInfo?.isEmpty == false {
            titleLabel.isHidden = true
            imageView.isHidden = false
        }else {
            titleLabel.isHidden = false
            imageView.isHidden = true
        }

        imageView.bounds = CGRect(x: 0, y: 0, width: myItemModel.imageSize.width, height: myItemModel.imageSize.height)

        //因为`func reloadData(itemModel: JXSegmentedBaseItemModel, isClicked: Bool)`方法会回调多次，尤其是左右滚动的时候会调用无数次。如果每次都触发图片加载，会非常消耗性能。所以只会在图片发生了变化的时候，才进行图片加载。
        if myItemModel.isSelected &&
            myItemModel.selectedImageInfo != nil &&
            myItemModel.selectedImageInfo?.isEmpty == false &&
            myItemModel.selectedImageInfo != currentImageInfo {
            currentImageInfo = myItemModel.selectedImageInfo
            if myItemModel.loadImageClosure != nil {
                myItemModel.loadImageClosure!(imageView, myItemModel.selectedImageInfo!)
            }else {
                imageView.image = UIImage(named: myItemModel.selectedImageInfo!)
            }
        }

        setNeedsLayout()
    }
}
