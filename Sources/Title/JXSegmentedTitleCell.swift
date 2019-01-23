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
    public let maskLayer = CALayer()
    open var animator: JXSegmentedAnimator?

    deinit {
        animator?.stop()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        animator?.stop()
    }

    open override func commonInit() {
        super.commonInit()

        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        maskTitleLabel.textAlignment = .center
        maskTitleLabel.isHidden = true
        contentView.addSubview(maskTitleLabel)

        maskLayer.backgroundColor = UIColor.red.cgColor
        maskTitleLabel.layer.mask = maskLayer
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

        var isSelectedAnimateEnabled = false
        if myItemModel.isSelectedAnimable {
            if selectedType == .scroll {
                //滚动选中且没有开启左右过渡，允许动画
                if !myItemModel.isItemTransitionEnabled {
                    isSelectedAnimateEnabled = true
                }
            }else if selectedType == .click || selectedType == .code {
                //点击和代码选中，允许动画
                isSelectedAnimateEnabled = true
            }
        }
        if myItemModel.isSelectedAnimable {
            if isSelectedAnimateEnabled {
                animator = JXSegmentedAnimator()
                animator?.duration = myItemModel.selectedAnimationDuration
            }else {
                animator?.stop()
            }
        }
        var titleZoomClosure: ((CGFloat)->())?
        var titleStrokeWidthClosure: ((CGFloat)->())?
        var titleColorClosure: ((CGFloat)->())?

        if myItemModel.isTitleZoomEnabled {
            //先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleCurrentZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
            let maxScaleFont = UIFont(descriptor: myItemModel.titleFont.fontDescriptor, size: myItemModel.titleFont.pointSize*CGFloat(myItemModel.titleSelectedZoomScale))
            let baseScale = myItemModel.titleFont.lineHeight/maxScaleFont.lineHeight

            if myItemModel.isSelectedAnimable && isSelectedAnimateEnabled {
                //允许动画且当前是点击的
                titleZoomClosure = preferredTitleZoomAnimateClosure(itemModel: myItemModel, baseScale: baseScale)
            }else {
                self.titleLabel.font = maxScaleFont
                self.maskTitleLabel.font = maxScaleFont
                let currentTransform = CGAffineTransform(scaleX: baseScale*CGFloat(myItemModel.titleCurrentZoomScale), y: baseScale*CGFloat(myItemModel.titleCurrentZoomScale))
                self.titleLabel.transform = currentTransform
                self.maskTitleLabel.transform = currentTransform
            }
        }else {
            if myItemModel.isSelected {
                titleLabel.font = myItemModel.titleSelectedFont
                maskTitleLabel.font = myItemModel.titleSelectedFont
            }else {
                titleLabel.font = myItemModel.titleFont
                maskTitleLabel.font = myItemModel.titleFont
            }
        }

        let title = myItemModel.title ?? ""
        let attriText = NSMutableAttributedString(string: title)
        if myItemModel.isTitleStrokeWidthEnabled {
            if myItemModel.isSelectedAnimable && isSelectedAnimateEnabled {
                //允许动画且当前是点击的
                titleStrokeWidthClosure = preferredTitleStrokeWidthAnimateClosure(itemModel: myItemModel, attriText: attriText)
            }else {
                attriText.addAttributes([NSAttributedString.Key.strokeWidth: myItemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: title.count))
                titleLabel.attributedText = attriText
            }
        }else {
            titleLabel.attributedText = attriText
        }

        if myItemModel.isTitleMaskEnabled {
            //允许mask，maskTitleLabel在titleLabel上面，maskTitleLabel设置为titleSelectedColor。titleLabel设置为titleColor
            titleLabel.textColor = myItemModel.titleColor
            maskTitleLabel.isHidden = false
            maskTitleLabel.textColor = myItemModel.titleSelectedColor
            maskTitleLabel.attributedText = attriText
            maskTitleLabel.sizeToFit()

            var frame = myItemModel.indicatorConvertToItemFrame
            frame.origin.x -= (contentView.bounds.size.width - maskTitleLabel.bounds.size.width)/2
            frame.origin.y = 0
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            maskLayer.frame = frame
            CATransaction.commit()
        }else {
            maskTitleLabel.isHidden = true
            if myItemModel.isSelectedAnimable && isSelectedAnimateEnabled {
                //允许动画且当前是点击的
                titleColorClosure = preferredTitleColorAnimateClosure(itemModel: myItemModel)
            }else {
                titleLabel.textColor = myItemModel.titleCurrentColor
            }
        }
        
        if myItemModel.isSelectedAnimable && isSelectedAnimateEnabled {
            //需要更新isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
            myItemModel.isTransitionAnimating = true
            animator?.progressClosure = {(percent) in
                titleZoomClosure?(percent)
                titleStrokeWidthClosure?(percent)
                titleColorClosure?(percent)
            }
            animator?.completedClosure = {
                myItemModel.isTransitionAnimating = false
            }
            animator?.start()
        }

        titleLabel.sizeToFit()
        setNeedsLayout()
    }

    open func preferredTitleZoomAnimateClosure(itemModel: JXSegmentedTitleItemModel, baseScale: CGFloat) -> ((CGFloat)->()) {
        return {[weak self] (percnet) in
            if itemModel.isSelected {
                //将要选中，scale从小到大插值渐变
                itemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: itemModel.titleDefaultZoomScale, to: itemModel.titleSelectedZoomScale, percent: percnet)
            }else {
                //将要取消选中，scale从大到小插值渐变
                itemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: itemModel.titleSelectedZoomScale, to:itemModel.titleDefaultZoomScale , percent: percnet)
            }
            let currentTransform = CGAffineTransform(scaleX: baseScale*itemModel.titleCurrentZoomScale, y: baseScale*itemModel.titleCurrentZoomScale)
            self?.titleLabel.transform = currentTransform
            self?.maskTitleLabel.transform = currentTransform
        }
    }

    open func preferredTitleStrokeWidthAnimateClosure(itemModel: JXSegmentedTitleItemModel, attriText: NSMutableAttributedString) -> ((CGFloat)->()){
        return {[weak self] (percent) in
            if itemModel.isSelected {
                //将要选中，StrokeWidth从小到大插值渐变
                itemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: itemModel.titleDefaultStrokeWidth, to: itemModel.titleSelectedStrokeWidth, percent: percent)
            }else {
                //将要取消选中，StrokeWidth从大到小插值渐变
                itemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: itemModel.titleSelectedStrokeWidth, to:itemModel.titleDefaultStrokeWidth , percent: percent)
            }
            attriText.addAttributes([NSAttributedString.Key.strokeWidth: itemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: attriText.string.count))
            self?.titleLabel.attributedText = attriText
        }
    }

    open func preferredTitleColorAnimateClosure(itemModel: JXSegmentedTitleItemModel) -> ((CGFloat)->()) {
        return {[weak self] (percent) in
            if itemModel.isSelected {
                //将要选中，textColor从titleColor到titleSelectedColor插值渐变
                itemModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: itemModel.titleColor, to: itemModel.titleSelectedColor, percent: percent)
            }else {
                //将要取消选中，textColor从titleSelectedColor到titleColor插值渐变
                itemModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: itemModel.titleSelectedColor, to: itemModel.titleColor, percent: percent)
            }
            self?.titleLabel.textColor = itemModel.titleCurrentColor
        }
    }
}
