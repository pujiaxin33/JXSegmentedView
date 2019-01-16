//
//  JXSegmentedIndicatorDotLineView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedIndicatorDotLineView: JXSegmentedIndicatorBaseView {
    open var lineMaxWidth: CGFloat = 50    //线的最大宽度

    open override func commonInit() {
        super.commonInit()

        //配置点的size
        indicatorWidth = 10
        indicatorHeight = 10
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
        super.refreshIndicatorState(model: model)

        backgroundColor = indicatorColor
        layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        var y = model.currentSelectedItemFrame.size.height - height - verticalMargin
        if indicatorPosition == .top {
            y = verticalMargin
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    open override func contentScrollViewDidScroll(model: JXSegmentedIndicatorParamsModel) {
        super.contentScrollViewDidScroll(model: model)

        if model.percent == 0 {
            //model.percent等于0时不需要处理，会调用selectItem(model: JXSegmentedIndicatorParamsModel)方法处理
            return
        }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        var targetX: CGFloat = leftItemFrame.origin.x
        let dotWidth = getIndicatorWidth(itemFrame: leftItemFrame)
        var targetWidth = dotWidth

        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightItemFrame)
        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - leftWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - rightWidth)/2
        let centerX = leftX + (rightX - leftX - lineMaxWidth)/2

        //前50%，移动x，增加宽度；后50%，移动x并减小width
        if percent <= 0.5 {
            targetX = JXSegmentedViewTool.interpolate(from: leftX, to: centerX, percent: CGFloat(percent*2))
            targetWidth = JXSegmentedViewTool.interpolate(from: dotWidth, to: lineMaxWidth, percent: CGFloat(percent*2))
        }else {
            targetX = JXSegmentedViewTool.interpolate(from: centerX, to: rightX, percent: CGFloat((percent - 0.5)*2))
            targetWidth = JXSegmentedViewTool.interpolate(from: lineMaxWidth, to: dotWidth, percent: CGFloat((percent - 0.5)*2))
        }

        //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
        if isScrollEnabled || (!isScrollEnabled && !model.isClicked && percent == 0) {
            self.frame.origin.x = targetX
            self.frame.size.width = targetWidth
        }
    }

    open override func selectItem(model: JXSegmentedIndicatorParamsModel) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth)/2
        toFrame.size.width = targetWidth
        if isScrollEnabled {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.frame = toFrame
            }) { (_) in
            }
        }else {
            frame = toFrame
        }
    }

}
