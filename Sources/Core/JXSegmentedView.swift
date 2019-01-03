//
//  JXSegmentedView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit


@objc
public protocol JXSegmentedViewDataSource {
    func dataSource(in segmentedView: JXSegmentedView) -> [JXSegmentedBaseItemModel]

    func segmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat

    func registerCellClass(in segmentedView: JXSegmentedView)

    func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell

    func refreshItemModel(currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel)

    func refreshItemModel(leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: Double)
}

@objc
public protocol JXSegmentedViewDelegate: NSObjectProtocol {
    @objc optional func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int)

    @objc optional func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int)

    @objc optional func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int)

    @objc optional func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: Double)
}

let JXSegmentedViewAutomaticDimension: CGFloat = -1

open class JXSegmentedView: UIView {
    open weak var dataSource: JXSegmentedViewDataSource? {
        didSet {
            setNeedsLayout()
        }
    }
    open weak var delegate: JXSegmentedViewDelegate?
    open var contentScrollView: UIScrollView? {
        willSet {
            contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
        didSet {
            contentScrollView?.scrollsToTop = false
            contentScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    public var indicators = [JXSegmentedIndicatorProtocol & UIView]() {
        didSet {
            collectionView.indicators = indicators
        }
    }
    public var defaultSelectedIndex: Int = 0 {
        didSet {
            selectedIndex = defaultSelectedIndex
        }
    }
    open private(set) var selectedIndex: Int = 0
    open var contentEdgeInsetLeft: CGFloat = JXSegmentedViewAutomaticDimension
    open var contentEdgeInsetRight: CGFloat = JXSegmentedViewAutomaticDimension
    open var itemSpacing: CGFloat = 20
    open var isItemSpacingAverageEnabled: Bool = true
    open var isContentScrollViewClickTransitionAnimateEnabled: Bool = true  //点击切换的时候，contentScrollView的切换是否需要动画

    private var collectionView: JXSegmentedCollectionView!
    private var itemDataSource = [JXSegmentedBaseItemModel]()
    private var innerItemSpacing: CGFloat = 0
    private var lastContentOffset: CGPoint = CGPoint.zero

    deinit {
        contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    fileprivate func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = JXSegmentedCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collectionView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        reloadData()
    }

    //MARK: - Public
    public final func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    public final func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> JXSegmentedBaseCell {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard cell.isKind(of: JXSegmentedBaseCell.self) else {
            fatalError("Cell class must be subclass of JXSegmentedBaseCell")
        }
        return cell as! JXSegmentedBaseCell
    }

    open func reloadData() {
        //FIXME:registerCellClass
        self.dataSource?.registerCellClass(in: self)
        if let itemSource = self.dataSource?.dataSource(in: self) {
            itemDataSource = itemSource
        }

        innerItemSpacing = itemSpacing
        var totalItemWidth: CGFloat = 0
        var totalContentWidth: CGFloat = getContentEdgeInsetLeft()
        for (index, itemModel) in itemDataSource.enumerated() {
            itemModel.index = index
            itemModel.itemWidth = (self.dataSource?.segmentedView(self, widthForItemAt: index) ?? 0)
            itemModel.isSelected = (index == selectedIndex)
            totalItemWidth += itemModel.itemWidth
            if index == itemDataSource.count - 1 {
                totalContentWidth += itemModel.itemWidth + getContentEdgeInsetRight()
            }else {
                totalContentWidth += itemModel.itemWidth + self.innerItemSpacing
            }
        }

        if isItemSpacingAverageEnabled && totalContentWidth < self.bounds.size.width {
            var itemSpacingCount = itemDataSource.count - 1
            var totalItemSpacingWidth = self.bounds.size.width - totalItemWidth
            if contentEdgeInsetLeft == JXSegmentedViewAutomaticDimension {
                itemSpacingCount += 1
            }else {
                totalItemSpacingWidth -= contentEdgeInsetLeft
            }
            if contentEdgeInsetRight == JXSegmentedViewAutomaticDimension {
                itemSpacingCount += 1
            }else {
                totalItemSpacingWidth -= contentEdgeInsetRight
            }
            if itemSpacingCount > 0 {
                innerItemSpacing = totalItemSpacingWidth / CGFloat(itemSpacingCount)
            }
        }

        var selectedItemFrameX = innerItemSpacing
        var selectedItemWidth: CGFloat = 0
        totalContentWidth = getContentEdgeInsetLeft()
        for (index, itemModel) in itemDataSource.enumerated() {
            if index < selectedIndex {
                selectedItemFrameX += itemModel.itemWidth + innerItemSpacing
            }else if index == selectedIndex {
                selectedItemWidth = itemModel.itemWidth
            }
            if index == itemDataSource.count - 1 {
                totalContentWidth += itemModel.itemWidth + getContentEdgeInsetRight()
            }else {
                totalContentWidth += itemModel.itemWidth + innerItemSpacing
            }
        }

        let minX: CGFloat = 0
        let maxX = totalContentWidth - self.bounds.size.width
        let targetX = selectedItemFrameX - self.bounds.size.width/2 + selectedItemWidth/2
        collectionView.setContentOffset(CGPoint(x: max(min(maxX, targetX), minX), y: 0), animated: false)

        if contentScrollView != nil {
            if contentScrollView!.frame.equalTo(CGRect.zero) &&
                contentScrollView!.superview != nil {
                //某些情况、系统会出现JXCategoryView先布局，contentScrollView后布局。就会导致下面指定defaultSelectedIndex失效，所以发现frame为zero时，强行触发布局。
                contentScrollView?.superview?.setNeedsLayout()
                contentScrollView?.superview?.layoutIfNeeded()
            }

            contentScrollView!.setContentOffset(CGPoint(x: CGFloat(selectedIndex) * contentScrollView!.bounds.size.width
                , y: 0), animated: false)
        }

        for (index, indicator) in indicators.enumerated() {
            if itemDataSource.isEmpty {
                indicator.isHidden = true
            }else {
                indicator.isHidden = false
                let indicatorParamsModel = JXSegmentedIndicatorParamsModel()
                indicatorParamsModel.contentSize = CGSize(width: totalContentWidth, height: self.bounds.size.height)
                indicatorParamsModel.currentSelectedIndex = selectedIndex
                let selectedItemFrame = getItemFrameAt(index: selectedIndex)
                indicatorParamsModel.currentSelectedItemFrame = selectedItemFrame
                indicator.refreshIndicatorState(model: indicatorParamsModel)

                if indicator.isIndicatorConvertToItemFrameEnabled || (!indicator.isIndicatorConvertToItemFrameEnabled && index == indicators.count - 1) {
                    var indicatorConvertToItemFrame = indicator.frame
                    indicatorConvertToItemFrame.origin.x -= selectedItemFrame.origin.x
                    itemDataSource[selectedIndex].indicatorConvertToItemFrame = indicatorConvertToItemFrame
                }
            }
        }
        collectionView.reloadData()
    }

    open func selectItemAt(index: Int) {
        selectIteAt(index: index, isClicked: true)
    }

    //MARK: - KVO
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let contentOffset = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            if contentScrollView?.isTracking == true || contentScrollView?.isDecelerating == true {
                //用户滚动引起的contentOffset变化，才处理。
                var progress = Double(contentOffset.x/contentScrollView!.bounds.size.width)
                if Int(progress) > itemDataSource.count - 1 || progress < 0 {
                    //超过了边界，不需要处理
                    return
                }
                if contentOffset.x == 0 && selectedIndex == 0 && lastContentOffset.x == 0 {
                    //滚动到了最左边，且已经选中了第一个，且之前的contentOffset.x为0
                    return
                }
                let maxContentOffsetX = contentScrollView!.contentSize.width - contentScrollView!.bounds.size.width
                if contentOffset.x == maxContentOffsetX && selectedIndex == itemDataSource.count - 1 && lastContentOffset.x == maxContentOffsetX {
                    //滚动到了最右边，且已经选中了最后一个，且之前的contentOffset.x为maxContentOffsetX
                    return
                }

                progress = max(0, min(Double(itemDataSource.count - 1), progress))
                let baseIndex = Int(floor(progress))
                let remainderProgress = progress - Double(baseIndex)

                let leftItemFrame = getItemFrameAt(index: baseIndex)
                let rightItemFrame = getItemFrameAt(index: baseIndex + 1)

                let indicatorParamsModel = JXSegmentedIndicatorParamsModel()
                indicatorParamsModel.currentSelectedIndex = selectedIndex
                indicatorParamsModel.leftIndex = baseIndex
                indicatorParamsModel.leftItemFrame = leftItemFrame
                indicatorParamsModel.rightIndex = baseIndex + 1
                indicatorParamsModel.rightItemFrame = rightItemFrame
                indicatorParamsModel.percent = remainderProgress

                if remainderProgress == 0 {
                    //滑动翻页，需要更新选中状态
                    //滑动一小段距离，然后放开回到原位，contentOffset同样的值会回调多次。例如在index为1的情况，滑动放开回到原位，contentOffset会多次回调CGPoint(width, 0)
                    if !(lastContentOffset.x == contentOffset.x && selectedIndex == baseIndex) {
                        scrollSelectItemAt(index: baseIndex)
                    }
                    if baseIndex + 1 < itemDataSource.count {
                        //右边的index不能越界
                        for indicator in indicators {
                            indicator.contentScrollViewDidScroll(model: indicatorParamsModel)
                        }
                    }
                }else {
                    //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
                    if abs(progress - Double(selectedIndex)) > 1 {
                        var targetIndex = baseIndex
                        if progress < Double(selectedIndex) {
                            targetIndex = baseIndex + 1
                        }
                        scrollSelectItemAt(index: targetIndex)
                    }

                    dataSource?.refreshItemModel(leftItemModel: itemDataSource[baseIndex], rightItemModel: itemDataSource[baseIndex + 1], percent: remainderProgress)

                    for (index, indicator) in indicators.enumerated() {
                        indicator.contentScrollViewDidScroll(model: indicatorParamsModel)

                        if indicator.isIndicatorConvertToItemFrameEnabled || (!indicator.isIndicatorConvertToItemFrameEnabled && index == indicators.count - 1) {
                            var leftIndicatorConvertToItemFrame = indicator.frame
                            leftIndicatorConvertToItemFrame.origin.x -= leftItemFrame.origin.x
                            itemDataSource[baseIndex].indicatorConvertToItemFrame = leftIndicatorConvertToItemFrame

                            var rightIndicatorConvertToItemFrame = indicator.frame
                            rightIndicatorConvertToItemFrame.origin.x -= rightItemFrame.origin.x
                            itemDataSource[baseIndex + 1].indicatorConvertToItemFrame = rightIndicatorConvertToItemFrame
                        }
                    }

                    let leftCell = collectionView.cellForItem(at: IndexPath(item: baseIndex, section: 0)) as? JXSegmentedBaseCell
                    leftCell?.reloadData(itemModel: itemDataSource[baseIndex], isClicked: false)

                    let rightCell = collectionView.cellForItem(at: IndexPath(item: baseIndex + 1, section: 0)) as? JXSegmentedBaseCell
                    rightCell?.reloadData(itemModel: itemDataSource[baseIndex + 1], isClicked: false)

                    delegate?.segmentedView?(self, scrollingFrom: baseIndex, to: baseIndex + 1, percent: remainderProgress)
                }
            }
            lastContentOffset = contentOffset
        }
    }

    //MARK: - Private
    fileprivate func clickSelectItemAt(index: Int) {
        selectIteAt(index: index, isClicked: true)
    }

    fileprivate func scrollSelectItemAt(index: Int) {
        selectIteAt(index: index, isClicked: false)
    }

    fileprivate func selectIteAt(index: Int, isClicked: Bool) {
        guard index < itemDataSource.count else {
            return
        }

        if index == selectedIndex {
            if isClicked {
                delegate?.segmentedView?(self, didClickSelectedItemAt: index)
            }else {
                delegate?.segmentedView?(self, didScrollSelectedItemAt: index)
            }
            delegate?.segmentedView?(self, didSelectedItemAt: index)
            return
        }

        let currentSelectedItemModel = itemDataSource[selectedIndex]
        let willSelectedItemModel = itemDataSource[index]
        currentSelectedItemModel.isSelected = false
        willSelectedItemModel.isSelected = true
        dataSource?.refreshItemModel(currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel)

        let currentSelectedCell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? JXSegmentedBaseCell
        currentSelectedCell?.reloadData(itemModel: currentSelectedItemModel, isClicked: isClicked)

        let willSelectedCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? JXSegmentedBaseCell
        willSelectedCell?.reloadData(itemModel: willSelectedItemModel, isClicked: isClicked)

        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        if contentScrollView != nil {
            contentScrollView!.setContentOffset(CGPoint(x: contentScrollView!.bounds.size.width*CGFloat(index), y: 0), animated: isContentScrollViewClickTransitionAnimateEnabled)
        }

        let lastSelectedIndex = selectedIndex
        selectedIndex = index
        if isClicked {
            delegate?.segmentedView?(self, didClickSelectedItemAt: index)
        }else {
            delegate?.segmentedView?(self, didScrollSelectedItemAt: index)
        }
        delegate?.segmentedView?(self, didSelectedItemAt: index)

        let currentSelectedItemFrame = getItemFrameAt(index: selectedIndex)
        for (index, indicator) in indicators.enumerated() {
            let indicatorParamsModel = JXSegmentedIndicatorParamsModel()
            indicatorParamsModel.lastSelectedIndex = lastSelectedIndex
            indicatorParamsModel.currentSelectedIndex = selectedIndex
            indicatorParamsModel.currentSelectedItemFrame = currentSelectedItemFrame
            indicatorParamsModel.isClicked = isClicked
            indicator.selectItem(model: indicatorParamsModel)

            if indicator.isIndicatorConvertToItemFrameEnabled || (!indicator.isIndicatorConvertToItemFrameEnabled && index == indicators.count - 1) {
                var indicatorConvertToItemFrame = indicator.frame
                indicatorConvertToItemFrame.origin.x -= currentSelectedItemFrame.origin.x
                itemDataSource[selectedIndex].indicatorConvertToItemFrame = indicatorConvertToItemFrame
                willSelectedCell?.reloadData(itemModel: willSelectedItemModel, isClicked: isClicked)
            }
        }
    }

    fileprivate func getItemFrameAt(index: Int) -> CGRect {
        guard index < itemDataSource.count else {
            return CGRect.zero
        }
        var x = getContentEdgeInsetLeft()
        for i in 0..<index {
            x += itemDataSource[i].itemWidth + innerItemSpacing
        }
        return CGRect(x: x, y: 0, width: itemDataSource[index].itemWidth, height: self.bounds.size.height)
    }

    fileprivate func getContentEdgeInsetLeft() -> CGFloat {
        if contentEdgeInsetLeft == JXSegmentedViewAutomaticDimension {
            return innerItemSpacing
        }else {
            return contentEdgeInsetLeft
        }
    }

    fileprivate func getContentEdgeInsetRight() -> CGFloat {
        if contentEdgeInsetRight == JXSegmentedViewAutomaticDimension {
            return innerItemSpacing
        }else {
            return contentEdgeInsetRight
        }
    }
}

extension JXSegmentedView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.dataSource?.segmentedView(self, cellForItemAt: indexPath.item) {
            cell.reloadData(itemModel: itemDataSource[indexPath.item], isClicked: false)
            return cell
        }else {
            return UICollectionViewCell(frame: CGRect.zero)
        }
    }
}

extension JXSegmentedView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickSelectItemAt(index: indexPath.item)
    }
}

extension JXSegmentedView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: getContentEdgeInsetLeft(), bottom: 0, right: getContentEdgeInsetRight())
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemDataSource[indexPath.item].itemWidth, height: self.bounds.size.height)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return innerItemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return innerItemSpacing
    }
}
