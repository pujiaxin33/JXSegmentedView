//
//  JXSegmentedIndicatorGradientLineView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2020/7/6.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

/// 会无视indicatorColor属性，以gradientColors为准
open class JXSegmentedIndicatorGradientLineView: JXSegmentedIndicatorLineView {
    open var colors = [UIColor]()
    open var startPoint = CGPoint.zero
    open var endPoint = CGPoint(x: 1, y: 0)
    open var locations: [NSNumber]?
    public let gradientLayer = CAGradientLayer()

    open override func commonInit() {
        super.commonInit()

        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = .clear
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        CATransaction.commit()
    }

    open override func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.commit()
    }

    open override func selectItem(model: JXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        CATransaction.begin()
        CATransaction.setAnimationDuration(scrollAnimationDuration)
        CATransaction.setAnimationTimingFunction(.init(name: .easeOut))
        gradientLayer.frame.size.width = targetWidth
        CATransaction.commit()
    }

}
