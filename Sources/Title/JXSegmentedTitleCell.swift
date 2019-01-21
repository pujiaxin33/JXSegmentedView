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

        if myItemModel.isTitleZoomEnabled {
            //先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleLabelZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
            let maxScaleFont = UIFont(descriptor: myItemModel.titleFont.fontDescriptor, size: myItemModel.titleFont.pointSize*CGFloat(myItemModel.titleMaxZoomScale))
            let baseScale = myItemModel.titleFont.lineHeight/maxScaleFont.lineHeight
            self.titleLabel.font = maxScaleFont
            self.maskTitleLabel.font = maxScaleFont
            self.titleLabel.transform = CGAffineTransform(scaleX: baseScale, y: baseScale)
            self.titleLabel.transform = CGAffineTransform(scaleX: baseScale*CGFloat(myItemModel.titleCurrentZoomScale), y: baseScale*CGFloat(myItemModel.titleCurrentZoomScale))
        }else {
            if myItemModel.isSelected {
                titleLabel.font = myItemModel.titleSelectedFont
                maskTitleLabel.font = myItemModel.titleSelectedFont
            }else {
                titleLabel.font = myItemModel.titleFont
                maskTitleLabel.font = myItemModel.titleFont
            }
        }
//        if isClicked {
//            if itemModel.isSelected {
//                UIView.animate(withDuration: 0.5) {
//                    self.titleLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//                }
//            }else {
//                UIView.animate(withDuration: 0.5) {
//                    self.titleLabel.transform = CGAffineTransform.identity
//                }
//            }
//        }else {
//            titleLabel.font = myItemModel.titleFont
//        }

        let title = myItemModel.title ?? ""
        let attriText = NSMutableAttributedString(string: title)
        if myItemModel.isTitleStrokeWidthEnabled {
            attriText.addAttributes([NSAttributedString.Key.strokeWidth: myItemModel.titleSelectedStrokeWidth], range: NSRange(location: 0, length: title.count))
        }

        if myItemModel.isTitleMaskEnabled {
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
            if myItemModel.isSelected {
                titleLabel.textColor = myItemModel.titleSelectedColor
            }else {
                titleLabel.textColor = myItemModel.titleColor
            }
        }

        titleLabel.attributedText = attriText
        titleLabel.sizeToFit()
        setNeedsLayout()
    }
}
