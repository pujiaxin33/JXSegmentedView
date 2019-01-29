//
//  JXSegmentedTitleCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleCell: JXSegmentedBaseCell {
    public let titleLabel = UILabel()
    public let maskTitleLabel = UILabel()
    public let titleMaskLayer = CALayer()

    open override func commonInit() {
        super.commonInit()

        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        maskTitleLabel.textAlignment = .center
        maskTitleLabel.isHidden = true
        contentView.addSubview(maskTitleLabel)

        titleMaskLayer.backgroundColor = UIColor.red.cgColor
        maskTitleLabel.layer.mask = titleMaskLayer
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.center = contentView.center
        maskTitleLabel.center = contentView.center
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedTitleItemModel else {
            return
        }

        if myItemModel.isTitleZoomEnabled {
            //先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleCurrentZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
            let maxScaleFont = UIFont(descriptor: myItemModel.titleNormalFont.fontDescriptor, size: myItemModel.titleNormalFont.pointSize*CGFloat(myItemModel.titleSelectedZoomScale))
            let baseScale = myItemModel.titleNormalFont.lineHeight/maxScaleFont.lineHeight

            if myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let titleZoomClosure = preferredTitleZoomAnimateClosure(itemModel: myItemModel, baseScale: baseScale)
                appendSelectedAnimationClosure(closure: titleZoomClosure)
            }else {
                titleLabel.font = maxScaleFont
                maskTitleLabel.font = maxScaleFont
                let currentTransform = CGAffineTransform(scaleX: baseScale*CGFloat(myItemModel.titleCurrentZoomScale), y: baseScale*CGFloat(myItemModel.titleCurrentZoomScale))
                titleLabel.transform = currentTransform
                maskTitleLabel.transform = currentTransform
            }
        }else {
            if myItemModel.isSelected {
                titleLabel.font = myItemModel.titleSelectedFont
                maskTitleLabel.font = myItemModel.titleSelectedFont
            }else {
                titleLabel.font = myItemModel.titleNormalFont
                maskTitleLabel.font = myItemModel.titleNormalFont
            }
        }

        let title = myItemModel.title ?? ""
        let attriText = NSMutableAttributedString(string: title)
        if myItemModel.isTitleStrokeWidthEnabled {
            if myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let titleStrokeWidthClosure = preferredTitleStrokeWidthAnimateClosure(itemModel: myItemModel, attriText: attriText)
                appendSelectedAnimationClosure(closure: titleStrokeWidthClosure)
            }else {
                attriText.addAttributes([NSAttributedString.Key.strokeWidth: myItemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: title.count))
                titleLabel.attributedText = attriText
            }
        }else {
            titleLabel.attributedText = attriText
        }

        if myItemModel.isTitleMaskEnabled {
            //允许mask，maskTitleLabel在titleLabel上面，maskTitleLabel设置为titleSelectedColor。titleLabel设置为titleNormalColor
            titleLabel.textColor = myItemModel.titleNormalColor
            maskTitleLabel.isHidden = false
            maskTitleLabel.textColor = myItemModel.titleSelectedColor
            maskTitleLabel.attributedText = attriText
            maskTitleLabel.sizeToFit()

            var frame = myItemModel.indicatorConvertToItemFrame
            frame.origin.x -= (contentView.bounds.size.width - maskTitleLabel.bounds.size.width)/2
            frame.origin.y = 0
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            titleMaskLayer.frame = frame
            CATransaction.commit()
        }else {
            maskTitleLabel.isHidden = true
            if myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let titleColorClosure = preferredTitleColorAnimateClosure(itemModel: myItemModel)
                appendSelectedAnimationClosure(closure: titleColorClosure)
            }else {
                titleLabel.textColor = myItemModel.titleCurrentColor
            }
        }

        startSelectedAnimationIfNeeded(itemModel: itemModel, selectedType: selectedType)

        titleLabel.sizeToFit()
        setNeedsLayout()
    }

    open func preferredTitleZoomAnimateClosure(itemModel: JXSegmentedTitleItemModel, baseScale: CGFloat) -> JXSegmentedCellSelectedAnimationClosure {
        return {[weak self] (percnet) in
            if itemModel.isSelected {
                //将要选中，scale从小到大插值渐变
                itemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: itemModel.titleNormalZoomScale, to: itemModel.titleSelectedZoomScale, percent: percnet)
            }else {
                //将要取消选中，scale从大到小插值渐变
                itemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: itemModel.titleSelectedZoomScale, to:itemModel.titleNormalZoomScale , percent: percnet)
            }
            let currentTransform = CGAffineTransform(scaleX: baseScale*itemModel.titleCurrentZoomScale, y: baseScale*itemModel.titleCurrentZoomScale)
            self?.titleLabel.transform = currentTransform
            self?.maskTitleLabel.transform = currentTransform
        }
    }

    open func preferredTitleStrokeWidthAnimateClosure(itemModel: JXSegmentedTitleItemModel, attriText: NSMutableAttributedString) -> JXSegmentedCellSelectedAnimationClosure{
        return {[weak self] (percent) in
            if itemModel.isSelected {
                //将要选中，StrokeWidth从小到大插值渐变
                itemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: itemModel.titleNormalStrokeWidth, to: itemModel.titleSelectedStrokeWidth, percent: percent)
            }else {
                //将要取消选中，StrokeWidth从大到小插值渐变
                itemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: itemModel.titleSelectedStrokeWidth, to:itemModel.titleNormalStrokeWidth , percent: percent)
            }
            attriText.addAttributes([NSAttributedString.Key.strokeWidth: itemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: attriText.string.count))
            self?.titleLabel.attributedText = attriText
        }
    }

    open func preferredTitleColorAnimateClosure(itemModel: JXSegmentedTitleItemModel) -> JXSegmentedCellSelectedAnimationClosure {
        return {[weak self] (percent) in
            if itemModel.isSelected {
                //将要选中，textColor从titleNormalColor到titleSelectedColor插值渐变
                itemModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: itemModel.titleNormalColor, to: itemModel.titleSelectedColor, percent: percent)
            }else {
                //将要取消选中，textColor从titleSelectedColor到titleNormalColor插值渐变
                itemModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: itemModel.titleSelectedColor, to: itemModel.titleNormalColor, percent: percent)
            }
            self?.titleLabel.textColor = itemModel.titleCurrentColor
        }
    }
}
