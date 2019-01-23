//
//  JXSegmentedTitleGradientItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleGradientItemModel: JXSegmentedTitleItemModel {
    open var titleDefaultGradientColors: [CGColor] = [CGColor]()
    open var titleCurrentGradientColors: [CGColor] = [CGColor]()
    open var titleSelectedGradientColors: [CGColor] = [CGColor]()
    open var titleGradientStartPoint: CGPoint = CGPoint(x: 0, y: 0)
    open var titleGradientEndPoint: CGPoint = CGPoint(x: 1, y: 0)
}
