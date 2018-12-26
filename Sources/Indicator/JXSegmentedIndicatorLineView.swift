//
//  JXSegmentedIndicatorLineView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedIndicatorLineView: JXSegmentedIndicatorBaseView {
    open var lineViewHeight: CGFloat = 3
    open var lineViewWidth: CGFloat = JXSegmentedViewAutomaticDimension     //默认JXCategoryViewAutomaticDimension（与cellWidth相等）
    open var lineViewCornerRadius: CGFloat = JXSegmentedViewAutomaticDimension      //默认JXCategoryViewAutomaticDimension （等于self.indicatorLineViewHeight/2）
    open var lineViewColor: UIColor = .red

    public override func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
        super.refreshIndicatorState(model: model)

        backgroundColor = lineViewColor
        layer.cornerRadius = getLineViewCornerRadius()

        let selectedLineWidth = getLineViewWidth(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - selectedLineWidth)/2
        var y = superview!.bounds.size.height - lineViewHeight - verticalMargin
        if indicatorPosition == .top {
            y = verticalMargin
        }
        frame = CGRect(x: x, y: y, width: selectedLineWidth, height: lineViewHeight)
    }

    public override func contentScrollViewDidScroll(model: JXSegmentedIndicatorParamsModel) {
        super.contentScrollViewDidScroll(model: model)

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        var targetX = leftItemFrame.origin.x
        var targetWidth = getLineViewWidth(itemFrame: leftItemFrame)

        if percent == 0 {
            targetX = leftItemFrame.origin.x + (leftItemFrame.size.width - targetWidth)/2
        }else {
            let leftWidth = targetWidth
            let rightWidth = getLineViewWidth(itemFrame: rightItemFrame)
            let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - leftWidth)/2
            let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - rightWidth)/2
            targetX = JXSegmentedViewTool.interpolate(from: leftX, to: rightX, percent: percent)
            if lineViewWidth == JXSegmentedViewAutomaticDimension {
                targetWidth = JXSegmentedViewTool.interpolate(from: leftItemFrame.size.width, to: rightItemFrame.size.width, percent: percent)
            }
        }

        //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
        if isScrollEnabled || (!isScrollEnabled && !model.isClicked && percent == 0) {
            self.frame.origin.x = targetX
            self.frame.size.width = targetWidth
        }
    }

    public override func selectItem(model: JXSegmentedIndicatorParamsModel) {
        super.selectItem(model: model)

        let targetWidth = getLineViewWidth(itemFrame: model.currentSelectedItemFrame)
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

    public final func getLineViewCornerRadius() -> CGFloat {
        if lineViewCornerRadius == JXSegmentedViewAutomaticDimension {
            return lineViewHeight/2
        }
        return lineViewCornerRadius
    }

    public final func getLineViewWidth(itemFrame: CGRect) -> CGFloat {
        if lineViewWidth == JXSegmentedViewAutomaticDimension {
            return itemFrame.size.width
        }
        return lineViewWidth
    }
}
