//
//  JXSegmentedIndicatorBaseView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public enum JXSegmentedIndicatorPosition {
    case top
    case bottom
}

open class JXSegmentedIndicatorBaseView: UIView, JXSegmentedIndicatorProtocol {
    open var indicatorPosition: JXSegmentedIndicatorPosition = .bottom
    open var verticalMargin: CGFloat = 0        //垂直方向边距；默认：0
    open var isScrollEnabled: Bool = true       //手势滚动、点击切换的时候，是否允许滚动，默认YES

    public func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {

    }

    public func contentScrollViewDidScroll(model: JXSegmentedIndicatorParamsModel) {

    }

    public func selectItem(model: JXSegmentedIndicatorParamsModel) {

    }
}
