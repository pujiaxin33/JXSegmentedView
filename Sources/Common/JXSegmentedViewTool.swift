//
//  JXSegmentedViewTool.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var jx_red: CGFloat {
        var r: CGFloat = 0
        self.getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    var jx_green: CGFloat {
        var g: CGFloat = 0
        self.getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    var jx_blue: CGFloat {
        var b: CGFloat = 0
        self.getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    var jx_alpha: CGFloat {
        return self.cgColor.alpha
    }
}

class JXSegmentedViewTool {
    static func interpolate<T: SignedNumeric & Comparable>(from: T, to:  T, percent:  T) ->  T {
        let percent = max(0, min(1, percent))
        return from + (to - from) * percent
    }

    static func interpolateColor(from: UIColor, to: UIColor, percent: Double) -> UIColor {
        let r = interpolate(from: from.jx_red, to: to.jx_red, percent: CGFloat(percent))
        let g = interpolate(from: from.jx_green, to: to.jx_green, percent: CGFloat(percent))
        let b = interpolate(from: from.jx_blue, to: to.jx_blue, percent: CGFloat(percent))
        let a = interpolate(from: from.jx_alpha, to: to.jx_alpha, percent: CGFloat(percent))
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    static func convertTextPath(from string: String, font: UIFont) -> UIBezierPath {
        let letters = CGMutablePath()
        let fontRef = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attrs = [NSAttributedString.Key.font : fontRef]
        let attrString = NSAttributedString(string: string, attributes: attrs)
        let line = CTLineCreateWithAttributedString(attrString as CFAttributedString)
        let runArray = CTLineGetGlyphRuns(line)
        for runIndex in 0..<CFArrayGetCount(runArray) {
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let runFont = unsafeBitCast(CFDictionaryGetValue(CTRunGetAttributes(run), unsafeBitCast(kCTFontAttributeName, to: UnsafeRawPointer.self)), to: CTFont.self)
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph = CGGlyph()
                var position = CGPoint.zero
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &position)

                let letter = CTFontCreatePathForGlyph(runFont, glyph, nil)
                let transform = CGAffineTransform.init(translationX: position.x, y: position.y)
                letters.addPath(letter!, transform: transform)

            }
        }
        let path = UIBezierPath(cgPath: letters)
        path.move(to: CGPoint.zero)
        path.append(UIBezierPath(cgPath: letters))
        return path
    }
}
