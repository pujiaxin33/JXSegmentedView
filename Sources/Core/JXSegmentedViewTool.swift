//
//  JXSegmentedViewTool.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

class JXSegmentedViewTool {
    static func interpolate(from: CGFloat, to: CGFloat, percent: Double) -> CGFloat {
        let percent = max(0, min(1, percent))
        return from + (to - from) * CGFloat(percent)
    }
}
