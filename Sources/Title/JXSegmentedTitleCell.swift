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
    private var animator: JXSegmentedAnimator?

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

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, isClicked: Bool) {
        super.reloadData(itemModel: itemModel, isClicked: isClicked)

        guard let myItemModel = itemModel as? JXSegmentedTitleItemModel else {
            return
        }

        if myItemModel.isClickedAnimable {
            if isClicked {
                animator = JXSegmentedAnimator()
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

            if myItemModel.isClickedAnimable && isClicked {
                //允许动画且当前是点击的
                titleZoomClosure = {[weak self] (percnet) in
                    if myItemModel.isSelected {
                        //将要选中，scale从小到大插值渐变
                        myItemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: myItemModel.titleDefaultZoomScale, to: myItemModel.titleSelectedZoomScale, percent: percnet)
                    }else {
                        //将要取消选中，scale从大到小插值渐变
                        myItemModel.titleCurrentZoomScale = JXSegmentedViewTool.interpolate(from: myItemModel.titleSelectedZoomScale, to:myItemModel.titleDefaultZoomScale , percent: percnet)
                    }
                    let currentTransform = CGAffineTransform(scaleX: baseScale*myItemModel.titleCurrentZoomScale, y: baseScale*myItemModel.titleCurrentZoomScale)
                    self?.titleLabel.transform = currentTransform
                    self?.maskTitleLabel.transform = currentTransform
                }
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
            if myItemModel.isClickedAnimable && isClicked {
                //允许动画且当前是点击的
                titleStrokeWidthClosure = {[weak self] (percent) in
                    if myItemModel.isSelected {
                        //将要选中，StrokeWidth从小到大插值渐变
                        myItemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: myItemModel.titleDefaultStrokeWidth, to: myItemModel.titleSelectedStrokeWidth, percent: percent)
                    }else {
                        //将要取消选中，StrokeWidth从大到小插值渐变
                        myItemModel.titleCurrentStrokeWidth = JXSegmentedViewTool.interpolate(from: myItemModel.titleSelectedStrokeWidth, to:myItemModel.titleDefaultStrokeWidth , percent: percent)
                    }
                    attriText.addAttributes([NSAttributedString.Key.strokeWidth: myItemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: title.count))
                    self?.titleLabel.attributedText = attriText
                }
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
            if myItemModel.isClickedAnimable && isClicked {
                //允许动画且当前是点击的
                titleColorClosure = {[weak self] (percent) in
                    if myItemModel.isSelected {
                        //将要选中，textColor从titleColor到titleSelectedColor插值渐变
                        myItemModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: myItemModel.titleColor, to: myItemModel.titleSelectedColor, percent: Double(percent))
                    }else {
                        //将要取消选中，textColor从titleSelectedColor到titleColor插值渐变
                        myItemModel.titleCurrentColor = JXSegmentedViewTool.interpolateColor(from: myItemModel.titleSelectedColor, to: myItemModel.titleColor, percent: Double(percent))
                    }
                    self?.titleLabel.textColor = myItemModel.titleCurrentColor
                }
            }else {
                titleLabel.textColor = myItemModel.titleCurrentColor
            }
        }
        if myItemModel.isClickedAnimable && isClicked {
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
}
