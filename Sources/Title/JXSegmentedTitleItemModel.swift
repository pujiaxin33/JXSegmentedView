//
//  JXSegmentedTitleItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleItemModel: JXSegmentedBaseItemModel {
    open var title: String?
    open var titleColor: UIColor = .black
    open var titleSelectedColor: UIColor = .red
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    open var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    open var isTitleZoomEnabled: Bool = false
    open var titleZoomScale: Double = 1.2
    open var isTitleStrokeWidthEnabled: Bool = false
    open var titleSelectedStrokeWidth: Double = -2
}
