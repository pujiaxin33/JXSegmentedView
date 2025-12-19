//
//  VerticalSectionHeaderView.swift
//  JXSegmentedViewExample
//
//  Created by Jason on 2025/6/27.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit

class VerticalSectionHeaderView: UICollectionReusableView {
    
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        
        titleLabel.textColor = .lightGray
        titleLabel.font = .systemFont(ofSize: 15)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(
            x: 16,
            y: (bounds.height - titleLabel.bounds.height) / 2,
            width: 200,
            height: titleLabel.bounds.height
        )
    }
}
