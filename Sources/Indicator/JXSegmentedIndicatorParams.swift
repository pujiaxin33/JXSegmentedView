//
//  JXSegmentedIndicatorParamsModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit
/**
 指示器传递的数据模型，不同情况会对不同的属性赋值，根据不同情况的api说明确认。
 为什么会通过model传递数据，因为指示器处理逻辑以后会扩展不同的使用场景，会新增参数。如果不通过model传递，就会在api新增参数，一旦修改api修改的地方就特别多了，而且会影响到之前自定义实现的开发者。
 */
public struct JXSegmentedIndicatorSelectedParams {
    public let currentSelectedIndex: Int
    public let currentSelectedItemFrame: CGRect
    public let selectedType: JXSegmentedViewItemSelectedType
    public let currentItemContentWidth: CGFloat
    /// collectionView的contentSize
    public var collectionViewContentSize: CGSize?

    public init(currentSelectedIndex: Int, currentSelectedItemFrame: CGRect, selectedType: JXSegmentedViewItemSelectedType, currentItemContentWidth: CGFloat, collectionViewContentSize: CGSize?) {
        self.currentSelectedIndex = currentSelectedIndex
        self.currentSelectedItemFrame = currentSelectedItemFrame
        self.selectedType = selectedType
        self.currentItemContentWidth = currentItemContentWidth
        self.collectionViewContentSize = collectionViewContentSize
    }
}

public struct JXSegmentedIndicatorTransitionParams {
    public let currentSelectedIndex: Int
    public let leftIndex: Int
    public let leftItemFrame: CGRect
    public let rightIndex: Int
    public let rightItemFrame: CGRect
    public let leftItemContentWidth: CGFloat
    public let rightItemContentWidth: CGFloat
    public let percent: CGFloat

    public init(currentSelectedIndex: Int, leftIndex: Int, leftItemFrame: CGRect, leftItemContentWidth: CGFloat, rightIndex: Int, rightItemFrame: CGRect, rightItemContentWidth: CGFloat, percent: CGFloat) {
        self.currentSelectedIndex = currentSelectedIndex
        self.leftIndex = leftIndex
        self.leftItemFrame = leftItemFrame
        self.leftItemContentWidth = leftItemContentWidth
        self.rightIndex = rightIndex
        self.rightItemFrame = rightItemFrame
        self.rightItemContentWidth = rightItemContentWidth
        self.percent = percent
    }
}
