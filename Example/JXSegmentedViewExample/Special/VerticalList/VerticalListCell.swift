//
//  VerticalListCell.swift
//  JXSegmentedViewExample
//
//  Created by Jason on 2025/6/27.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit

class VerticalListCell: UICollectionViewCell {
    
    var titleLabel: UILabel = UILabel()
    var itemImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(itemImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemImageView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        itemImageView.center = CGPoint(x: bounds.width/2, y: 30)
        
        titleLabel.frame = CGRect(x: 0,
                                y: itemImageView.frame.maxY + 5,
                                width: bounds.width,
                                height: 30)
    }
}
