//
//  SegmentedControlOptionalImageController.swift
//  JXSegmentedViewExample
//
//  Created by Van on 24.09.2025.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

final class SegmentedControlOptionalImageController: UIViewController {
	var segmentedDataSource: JXSegmentedBaseDataSource?
	let segmentedView = JXSegmentedView()
	let titleDataSource = JXSegmentedTitleImageDataSource()
	
	var totalItemWidth: CGFloat = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor: UIColor
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        view.backgroundColor = backgroundColor
        
        let titles = ["Pro", "Free"]
        
        titleDataSource.itemWidth = JXSegmentedViewAutomaticDimension;
        titleDataSource.itemWidthIncrement = 24;
        titleDataSource.titles = titles
        titleDataSource.isTitleMaskEnabled = true
        if #available(iOS 13.0, *) {
            titleDataSource.titleNormalColor = .label
        } else {
            titleDataSource.titleNormalColor = .black
        }
        titleDataSource.titleSelectedColor = .white
        titleDataSource.itemSpacing = 0
        titleDataSource.titleNormalFont = UIFont.preferredFont(forTextStyle: .subheadline)
        titleDataSource.isSelectedAnimable = false
        
        let isRTL = segmentedView.segmentedViewShouldRTLLayout()
        titleDataSource.titleImageType = isRTL ? .rightImage : .leftImage
        titleDataSource.titleImageSpacing = 4
        titleDataSource.normalImageInfos = ["D1", ""]
        titleDataSource.selectedImageInfos = ["S1", ""]
        if #available(iOS 13.0, *) {
            titleDataSource.loadImageClosure = { [weak self] (imageView, normalImageInfo) in
                let prefix = normalImageInfo.prefix(1)
                let tint: UIColor?
                let isLightTheme: Bool
                
                isLightTheme = (self?.traitCollection.userInterfaceStyle ?? .light) == .light
                
                switch prefix {
                case "D":
                    tint = isLightTheme ? .black : nil
                case "S":
                    tint = nil
                default:
                    tint = nil
                }
                let rawImage = UIImage(systemName: "crown.fill")
                if let tint {
                    imageView.tintColor = tint
                    imageView.image = rawImage?.withRenderingMode(.alwaysTemplate)
                } else {
                    imageView.tintColor = .white
                    imageView.image = rawImage
                }
            }
        }
		titleDataSource.imageSize = .init(width: 16, height: 16)

		segmentedDataSource = titleDataSource
		
		segmentedView.dataSource = titleDataSource
		segmentedView.backgroundColor = backgroundColor
		segmentedView.layer.masksToBounds = true
		segmentedView.layer.cornerRadius = 19
		segmentedView.layer.borderColor = UIColor.lightGray.cgColor
		segmentedView.layer.borderWidth = 1 / UIScreen.main.scale
		
		let indicator = JXSegmentedIndicatorBackgroundView()
		indicator.indicatorHeight = 30
		indicator.indicatorWidthIncrement = 0
		indicator.indicatorColor = UIColor.orange
		segmentedView.indicators = [indicator]
		
		segmentedView.dataSource = segmentedDataSource
		segmentedView.delegate = self
		segmentedView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(segmentedView)
		NSLayoutConstraint.activate([
			segmentedView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
			segmentedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			segmentedView.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
			segmentedView.heightAnchor.constraint(equalToConstant: 38)
		])
	}
}

extension SegmentedControlOptionalImageController: JXSegmentedViewDelegate {
	func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
		if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
			//先更新数据源的数据
			dotDataSource.dotStates[index] = false
			//再调用reloadItem(at: index)
			segmentedView.reloadItem(at: index)
		}
	}
}
