//
//  UIWindow+JXSafeArea.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/7.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    func jx_layoutinsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if safeAreaInsets.bottom > 0 {
                return safeAreaInsets
            }else {
                return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            }
        }
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    func jx_navigationHeight() -> CGFloat {
        return jx_layoutinsets().top + 44
    }
}
