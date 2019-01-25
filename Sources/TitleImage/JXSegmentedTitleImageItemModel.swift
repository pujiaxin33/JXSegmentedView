//
//  JXSegmentedTitleImageItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleImageItemModel: JXSegmentedTitleItemModel {
    open var titleImageType: JXSegmentedTitleImageType = .rightImage
    open var normalImageInfo: String?
    open var selectedImageInfo: String?
    open var loadImageClosure: LoadImageClosure?
    open var imageSize: CGSize = CGSize(width: 20, height: 20)
    open var titleImageSpacing: CGFloat = 5
    open var isImageZoomEnabled: Bool = false
    open var imageNormalZoomScale: CGFloat = 1
    open var imageCurrentZoomScale: CGFloat = 1
    open var imageSelectedZoomScale: CGFloat = 1.2
}
