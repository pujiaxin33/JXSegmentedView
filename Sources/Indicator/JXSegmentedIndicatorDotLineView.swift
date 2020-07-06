//
//  JXSegmentedIndicatorDotLineView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedIndicatorDotLineView: JXSegmentedIndicatorBaseView {
    /// 线的最大宽度
    open var lineMaxWidth: CGFloat = 50

    open override func commonInit() {
        super.commonInit()

        //配置点的size
        indicatorWidth = 10
        indicatorHeight = 10
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = indicatorColor
        layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        var y: CGFloat = 0
        switch indicatorPosition {
        case .top:
            y = verticalOffset
        case .bottom:
            y = model.currentSelectedItemFrame.size.height - height - verticalOffset
        case .center:
            y = (model.currentSelectedItemFrame.size.height - height)/2 + verticalOffset
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }

    open override func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        var targetX: CGFloat = leftItemFrame.origin.x
        let dotWidth = getIndicatorWidth(itemFrame: leftItemFrame, itemContentWidth: model.leftItemContentWidth)
        var targetWidth = dotWidth

        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightItemFrame, itemContentWidth: model.rightItemContentWidth)
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

        self.frame.origin.x = targetX
        self.frame.size.width = targetWidth
    }

    open override func selectItem(model: JXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth)/2
        toFrame.size.width = targetWidth
        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.frame = toFrame
            }) { (_) in
            }
        }else {
            frame = toFrame
        }
    }

}
