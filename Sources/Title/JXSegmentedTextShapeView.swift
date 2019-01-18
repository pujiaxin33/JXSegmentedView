//
//  JXSegmentedTextShapeView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTextShapeView: UIView {
    open var text: String?
    open var font: UIFont?
    open class override var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    open var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    open func commonInit() {
        backgroundColor = UIColor.clear

        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.isGeometryFlipped = true
        shapeLayer.lineWidth = 0
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard text != nil && font != nil else {
            return size
        }

        let textSize = NSString(string: text!).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue), attributes: [NSAttributedString.Key.font : font!], context: nil).size
        return CGSize(width: textSize.width, height: font!.lineHeight)
    }




}
