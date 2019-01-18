//
//  JXSegmentedTitleCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleCell: JXSegmentedBaseCell {
    open var titleLabel = UILabel()
    open var maskTitleLabel = UILabel()
    open var maskLayer = CALayer()
    open var textLayer: CAShapeLayer!
    open var textView: JXSegmentedTextShapeView!
    open var maskTextView: JXSegmentedTextShapeView!

    open override func commonInit() {
        super.commonInit()

        textView = JXSegmentedTextShapeView()
        contentView.addSubview(textView)

        maskTextView = JXSegmentedTextShapeView()
        contentView.addSubview(maskTextView)
        maskLayer.backgroundColor = UIColor.red.cgColor
        maskTextView.layer.mask = maskLayer
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        //textView.shapeLayer内容有向下4个point的偏移，我也不知道为什么，先补偿回来。
        textView.center = CGPoint(x: contentView.center.x, y: contentView.center.y - 4)
        maskTextView.center = CGPoint(x: contentView.center.x, y: contentView.center.y - 4)
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, isClicked: Bool) {
        super.reloadData(itemModel: itemModel, isClicked: isClicked)

        guard let myItemModel = itemModel as? JXSegmentedTitleItemModel else {
            return
        }

        var targetFont = myItemModel.titleFont
        if myItemModel.isSelected {
            targetFont = myItemModel.titleSelectedFont
        }
        let title = myItemModel.title ?? ""
        textView.font = targetFont
        textView.text = title
        textView.sizeToFit()

        maskTextView.font = targetFont
        maskTextView.text = title
        maskTextView.sizeToFit()

        let textPath = JXSegmentedViewTool.convertTextPath(from: title, font: targetFont)
        textView.shapeLayer.path = textPath.cgPath
        maskTextView.shapeLayer.path = textPath.cgPath

        var animations = [CAAnimation]()
        if myItemModel.isTitleZoomEnabled {
            if isClicked {
                let transformAnimation = CABasicAnimation(keyPath: "transform")
                transformAnimation.fromValue = textView.shapeLayer.transform
                transformAnimation.toValue = CATransform3DMakeScale(myItemModel.titleCurrentZoomScale, myItemModel.titleCurrentZoomScale, 1)
                animations.append(transformAnimation)
            }
            textView.shapeLayer.transform = CATransform3DMakeScale(myItemModel.titleCurrentZoomScale, myItemModel.titleCurrentZoomScale, 1)
            maskTextView.shapeLayer.transform = CATransform3DMakeScale(myItemModel.titleCurrentZoomScale, myItemModel.titleCurrentZoomScale, 1)
        }

        if myItemModel.isTitleLineWidthEnabled {
            if isClicked {
                let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
                lineWidthAnimation.fromValue = textView.shapeLayer.lineWidth
                lineWidthAnimation.toValue = myItemModel.titleSelectedLineWidth
                animations.append(lineWidthAnimation)
            }
            textView.shapeLayer.lineWidth = myItemModel.titleSelectedLineWidth
            maskTextView.shapeLayer.lineWidth = myItemModel.titleSelectedLineWidth
        }

        if myItemModel.isTitleMaskEnabled {
            textView.shapeLayer.fillColor = myItemModel.titleColor.cgColor
            maskTextView.isHidden = false
            maskTextView.shapeLayer.fillColor = myItemModel.titleSelectedColor.cgColor

            var frame = myItemModel.indicatorConvertToItemFrame
            frame.origin.x -= (contentView.bounds.size.width - maskTextView.bounds.size.width)/2
            frame.origin.y = -4
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskLayer.frame = frame
            CATransaction.commit()
        }else {
            maskTextView.isHidden = true
            var targetCorlor = myItemModel.titleColor
            if myItemModel.isSelected {
                targetCorlor = myItemModel.titleSelectedColor
            }
            if isClicked {
                let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
                fillColorAnimation.fromValue = textView.shapeLayer.fillColor
                fillColorAnimation.toValue = targetCorlor.cgColor
                animations.append(fillColorAnimation)

                let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
                strokeColorAnimation.fromValue = textView.shapeLayer.strokeColor
                strokeColorAnimation.toValue = targetCorlor.cgColor
                animations.append(strokeColorAnimation)
            }
            textView.shapeLayer.fillColor = targetCorlor.cgColor
            textView.shapeLayer.strokeColor = targetCorlor.cgColor
        }

        if myItemModel.isTitleZoomEnabled {
            textView.shapeLayer.removeAnimation(forKey: "group")
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.25
            animationGroup.animations = animations
            textView.shapeLayer.add(animationGroup, forKey: "group")
        }

        setNeedsLayout()
    }
}
