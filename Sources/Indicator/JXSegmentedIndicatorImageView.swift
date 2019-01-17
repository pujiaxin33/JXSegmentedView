//
//  JXSegmentedIndicatorImageView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedIndicatorImageView: JXSegmentedIndicatorBaseView {
    open var image: UIImage? {
        didSet {
            layer.contents = image?.cgImage
        }
    }

    open override func commonInit() {
        super.commonInit()

        indicatorWidth = 20
        indicatorHeight = 20
        layer.contentsGravity = .resizeAspect
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
        super.refreshIndicatorState(model: model)

        backgroundColor = nil

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
        if isScrollEnabled && model.isClicked {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.frame = toFrame
            }) { (_) in
            }
        }else {
            frame = toFrame
        }
    }

}
