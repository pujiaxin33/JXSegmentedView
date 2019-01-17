//
//  JXSegmentedIndicatorBackgroundView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

/// 不支持indicatorPosition、verticalMargin，默认垂直居中
open class JXSegmentedIndicatorBackgroundView: JXSegmentedIndicatorBaseView {
    open var backgroundWidthIncrement: CGFloat = 20     //宽度增量，背景指示器一般要比cell宽一些

    open override func commonInit() {
        super.commonInit()

        indicatorHeight = 26
        indicatorColor = .gray
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
        super.refreshIndicatorState(model: model)

        backgroundColor = indicatorColor
        layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        let y = (model.currentSelectedItemFrame.size.height - height)/2
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    open override func contentScrollViewDidScroll(model: JXSegmentedIndicatorParamsModel) {
        super.contentScrollViewDidScroll(model: model)

        if model.percent == 0 || !isScrollEnabled {
            //model.percent等于0时不需要处理，会调用selectItem(model: JXSegmentedIndicatorParamsModel)方法处理
            //isScrollEnabled为false不需要处理
            return
        }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        var targetWidth = getIndicatorWidth(itemFrame: leftItemFrame)

        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightItemFrame)
        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - leftWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - rightWidth)/2
        let targetX = JXSegmentedViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))
        if indicatorWidth == JXSegmentedViewAutomaticDimension {
            targetWidth = JXSegmentedViewTool.interpolate(from: leftWidth, to: rightWidth, percent: CGFloat(percent))
        }

        self.frame.origin.x = targetX
        self.frame.size.width = targetWidth
    }

    open override func selectItem(model: JXSegmentedIndicatorParamsModel) {
        super.selectItem(model: model)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        toFrame.size.width = width
        if isScrollEnabled && model.isClicked {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.frame = toFrame
            }) { (_) in
            }
        }else {
            frame = toFrame
        }
    }

    open override func getIndicatorWidth(itemFrame: CGRect) -> CGFloat {
        return super.getIndicatorWidth(itemFrame: itemFrame) + backgroundWidthIncrement
    }
}
