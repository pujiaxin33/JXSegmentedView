//
//  JXPagingViewRTLCompatible.swift
//  JXSegmentedViewExample
//
//  Created by blue on 2020/6/18.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

protocol JXPagingViewRTLCompatible: class {
    func pagingViewShouldRTLLayout() -> Bool
    func pagingView(horizontalFlipForView view: UIView?)
}

extension JXPagingViewRTLCompatible {
    
    func pagingViewShouldRTLLayout() -> Bool {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
    
    func pagingView(horizontalFlipForView view: UIView?) {
        view?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}

class JXPagingRTLCollectionLayout: UICollectionViewFlowLayout {

    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }

}

