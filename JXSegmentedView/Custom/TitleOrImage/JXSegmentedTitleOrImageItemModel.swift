//
//  JXSegmentedTitleOrImageItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleOrImageItemModel: JXSegmentedTitleItemModel {
    open var selectedImageInfo: String?
    open var loadImageClosure: LoadImageClosure?
    open var imageSize: CGSize = CGSize(width: 30, height: 30)
}
