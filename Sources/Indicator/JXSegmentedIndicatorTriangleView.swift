//
//  JXSegmentedIndicatorTriangleView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedIndicatorTriangleView: JXSegmentedIndicatorBaseView {
    open override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private var path = UIBezierPath()

    open override func commonInit() {
        super.commonInit()

        indicatorWidth = 14
        indicatorHeight = 10
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
        super.refreshIndicatorState(model: model)

        backgroundColor = nil
        let shapeLayer = self.layer as! CAShapeLayer
        shapeLayer.fillColor = indicatorColor.cgColor

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        var y = model.currentSelectedItemFrame.size.height - height - verticalMargin
        if indicatorPosition == .top {
            y = verticalMargin
        }
        frame = CGRect(x: x, y: y, width: width, height: height)

        path = UIBezierPath()
        if indicatorPosition == .bottom {
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width/2, y: 0))
            path.addLine(to: CGPoint(x: width, y: height))
        }else {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width/2, y: height))
            path.addLine(to: CGPoint(x: width, y: 0))
        }
        path.close()

        shapeLayer.path = path.cgPath
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
        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)

        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - targetWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - targetWidth)/2
        let targetX = JXSegmentedViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))

        self.frame.origin.x = targetX
    }

    open override func selectItem(model: JXSegmentedIndicatorParamsModel) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        var toFrame = self.frame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth)/2
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
