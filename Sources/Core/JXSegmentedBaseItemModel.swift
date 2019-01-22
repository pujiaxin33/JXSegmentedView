//
//  JXSegmentedBaseItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

open class JXSegmentedBaseItemModel {
    open var index: Int = 0
    open var isSelected: Bool = false
    open var itemWidth: CGFloat = 0
    /// 指示器视图Frame转换到cell
    open var indicatorConvertToItemFrame: CGRect = CGRect.zero
    open var isClickedAnimable: Bool = false
    /// 是否正在进行过渡动画
    open var isTransitionAnimating: Bool = false
}
