//
//  JXSegmentedIndicatorGradientView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

/// 整个背景是一个渐变色layer，通过gradientMaskLayer遮罩显示不同位置，达到不同文字底部有不同的渐变色。
open class JXSegmentedIndicatorGradientView: JXSegmentedIndicatorBaseView {
    @available(*, deprecated, renamed: "indicatorWidthIncrement")
    open var gradientViewWidthIncrement: CGFloat = 20 {
        didSet {
            indicatorWidthIncrement = gradientViewWidthIncrement
        }
    }

    /// 渐变colors
    open var gradientColors = [CGColor]()
    /// 渐变CAGradientLayer，通过它设置startPoint、endPoint等其他属性
    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    public let gradientMaskLayer: CAShapeLayer = CAShapeLayer()
    open class override var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientMaskLayerFrame = CGRect.zero

    open override func commonInit() {
        super.commonInit()

        indicatorWidthIncrement = 20
        indicatorHeight = 26
        indicatorPosition = .center
        verticalOffset = 0

        gradientColors = [UIColor(red: 194.0/255, green: 229.0/255, blue: 156.0/255, alpha: 1).cgColor, UIColor(red: 100.0/255, green: 179.0/255, blue: 244.0/255, alpha: 1).cgColor]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.mask = gradientMaskLayer
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        gradientLayer.colors = gradientColors

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
        gradientMaskLayerFrame = CGRect(x: x, y: y, width: width, height: height)
        let path = UIBezierPath(roundedRect: gradientMaskLayerFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientMaskLayer.path = path.cgPath
        CATransaction.commit()
        if let collectionViewContentSize = model.collectionViewContentSize {
            frame = CGRect(x: 0, y: 0, width: collectionViewContentSize.width, height: collectionViewContentSize.height)
        }
    }

    open override func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent
        var targetWidth = getIndicatorWidth(itemFrame: leftItemFrame, itemContentWidth: model.leftItemContentWidth)

        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightItemFrame, itemContentWidth: model.rightItemContentWidth)
        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - leftWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - rightWidth)/2
        let targetX = JXSegmentedViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))
        if indicatorWidth == JXSegmentedViewAutomaticDimension {
            targetWidth = JXSegmentedViewTool.interpolate(from: leftWidth, to: rightWidth, percent: CGFloat(percent))
        }

        gradientMaskLayerFrame.origin.x = targetX
        gradientMaskLayerFrame.size.width = targetWidth
        let path = UIBezierPath(roundedRect: gradientMaskLayerFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: leftItemFrame))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientMaskLayer.path = path.cgPath
        CATransaction.commit()
    }

    open override func selectItem(model: JXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = gradientMaskLayerFrame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        toFrame.size.width = width
        let path = UIBezierPath(roundedRect: toFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame))
        if canSelectedWithAnimation(model: model) {
            gradientMaskLayer.removeAnimation(forKey: "path")
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = gradientMaskLayer.path
            animation.toValue = path.cgPath
            animation.duration = scrollAnimationDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            gradientMaskLayer.add(animation, forKey: "path")
            gradientMaskLayer.path = path.cgPath
        }else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientMaskLayer.path = path.cgPath
            CATransaction.commit()
        }
    }
}
