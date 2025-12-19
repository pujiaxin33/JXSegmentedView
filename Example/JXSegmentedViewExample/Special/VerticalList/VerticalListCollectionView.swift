//
//  VerticalListCollectionView.swift
//  JXSegmentedViewExample
//
//  Created by Jason on 2025/6/27.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit

class VerticalListCollectionView: UICollectionView {
    var layoutSubviewsCallback: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutSubviewsCallback?()
    }

}
