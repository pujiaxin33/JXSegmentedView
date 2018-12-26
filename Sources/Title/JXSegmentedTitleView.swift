//
//  JXSegmentedTitleView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleView: UIView {
    open var titles = [String]() {
        didSet{
            reloadData()
        }
    }
    open var segmentedView: JXSegmentedBaseView!
    open var dataSource = [JXSegmentedBaseItemModel]()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    open func commonInit() {
        segmentedView = JXSegmentedBaseView()
        segmentedView.dataSource = self
        segmentedView.delegate = self
        segmentedView.register(JXSegmentedTitleCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(segmentedView)

        let indicator = JXSegmentedIndicatorLineView()
        segmentedView.indicators = [indicator]
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        segmentedView.frame = self.bounds
    }

    open func reloadData() {
        dataSource.removeAll()

        for title in titles {
            let itemModel = JXSegmentedTitleItemModel()
            itemModel.title = title
            dataSource.append(itemModel)
        }
        segmentedView.reloadData()
    }
}

extension JXSegmentedTitleView: JXSegmentedViewDataSource {
    public func segmentedView(_ segmentedView: JXSegmentedBaseView, widthForItemAt index: Int) -> CGFloat {
        return 50
    }

    public func segmentedView(_ segmentedView: JXSegmentedBaseView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    public func dataSource(in segmentedView: JXSegmentedBaseView) -> [JXSegmentedBaseItemModel] {
        return dataSource
    }

    public func refreshItemModel(currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel) {

    }
}

extension JXSegmentedTitleView: JXSegmentedViewDelegate {

}
