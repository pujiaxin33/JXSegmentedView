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

class PagingRTLCollectionCell: UICollectionViewCell, JXPagingViewRTLCompatible {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        if pagingViewShouldRTLLayout() {
            pagingView(horizontalFlipForView: self)
            pagingView(horizontalFlipForView: contentView)
        }
    }
    
}

class PagingListBaseCell: UITableViewCell {
    
    private(set) lazy var titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        contentView.addSubview(titleLabel)
        
        let leading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 10)
        let top = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leading, top])
    }

}

