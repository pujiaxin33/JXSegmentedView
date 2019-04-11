//
//  JXSegmentedListContainerView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

@objc
public protocol JXSegmentedListContainerViewListDelegate {
    /// 如果列表是VC，就返回VC.view
    /// 如果列表是View，就返回View自己
    ///
    /// - Returns: 返回列表视图
    func listView() -> UIView
    /// 可选实现，列表显示的时候调用
    @objc optional func listDidAppear()
    /// 可选实现，列表消失的时候调用
    @objc optional func listDidDisappear()
}

@objc
public protocol JXSegmentedListContainerViewDataSource {
    /// 返回list的数量
    ///
    /// - Parameter listContainerView: JXSegmentedListContainerView
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int

    /// 根据index初始化一个对应列表实例，需要是遵从`JXSegmentedListContainerViewListDelegate`协议的对象。
    /// 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXSegmentedListContainerViewListDelegate`协议，该方法返回自定义UIView即可。
    /// 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXSegmentedListContainerViewListDelegate`协议，该方法返回自定义UIViewController即可。
    /// 注意：一定要是新生成的实例！！！
    ///
    /// - Parameters:
    ///   - listContainerView: JXSegmentedListContainerView
    ///   - index: 目标index
    /// - Returns: 遵从JXSegmentedListContainerViewListDelegate协议的实例
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate


    /// 返回自定义UIScrollView实例
    /// 某些特殊情况需要自己处理UIScrollView内部逻辑。比如项目用了FDFullscreenPopGesture，需要处理手势相关代理。
    ///
    /// - Parameter listContainerView: JXSegmentedListContainerView
    /// - Returns: 自定义UIScrollView实例
    @objc optional func scrollView(in listContainerView: JXSegmentedListContainerView) -> UIScrollView
}

open class JXSegmentedListContainerView: UIView {
    public private(set) weak var dataSource: JXSegmentedListContainerViewDataSource!
    public private(set) var scrollView: UIScrollView!
    /// 已经加载过的列表字典。key是index，value是对应的列表
    open var validListDict = [Int:JXSegmentedListContainerViewListDelegate]()
    /// 滚动切换的时候，滚动距离超过一页的多少百分比，就认为切换了页面。默认0.5（即滚动超过了半屏，就认为翻页了）。范围0~1，开区间不包括0和1
    open var didAppearPercent: CGFloat = 0.5
    /// 需要和segmentedView.defaultSelectedIndex保持一致，用于触发默认index列表的加载
    open var defaultSelectedIndex: Int = 0 {
        didSet {
            currentIndex = defaultSelectedIndex
        }
    }
    private var currentIndex: Int = 0
    private var willRemoveFromWindow: Bool = false
    private var retainedSelf: JXSegmentedListContainerView?

    public init(dataSource: JXSegmentedListContainerViewDataSource) {
        self.dataSource = dataSource
        super.init(frame: CGRect.zero)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func commonInit() {
        if let customScrollView = dataSource.scrollView?(in: self) {
            scrollView = customScrollView
        }else {
            scrollView = UIScrollView()
        }
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(scrollView)
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        //当前页面push到一个新的页面时，willMoveToWindow会调用三次。第一次调用的newWindow为nil，第二次调用间隔1ms左右newWindow有值，第三次调用间隔400ms左右newWindow为nil。
        //根据上述事实，第一次和第二次为无效调用，可以根据其间隔1ms左右过滤掉
        if newWindow == nil {
            willRemoveFromWindow = true
            //当前页面被pop的时候，willMoveToWindow只会调用一次，而且整个页面会被销毁掉，所以需要循环引用自己，确保能延迟执行currentListDidDisappear方法，触发列表消失事件。由此可见，循环引用也不一定是个坏事。是天使还是魔鬼，就看你如何对待它了。
            retainedSelf = self
            perform(#selector(currentListDidDisappear), with: nil, afterDelay: 0.02)
        }else {
            if willRemoveFromWindow {
                willRemoveFromWindow = false
                retainedSelf = nil
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(currentListDidDisappear), object: nil)
            }else {
                currentListDidAppear()
            }
        }
    }

    open func reloadData() {
        if currentIndex < 0 || currentIndex >= dataSource.numberOfLists(in: self) {
            defaultSelectedIndex = 0
            currentIndex = 0
        }
        for list in validListDict.values {
            list.listView().removeFromSuperview()
        }
        validListDict.removeAll()

        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dataSource.numberOfLists(in: self)), height: scrollView.bounds.size.height)

        listDidAppear(at: currentIndex)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dataSource.numberOfLists(in: self)), height: scrollView.bounds.size.height)
        for (index, list) in validListDict {
            list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
        }
    }

    /// 必须调用！在`func segmentedView(_ segmentedView: JXSegmentedBaseView, scrollingFrom leftIndex: Int, to rightIndex: Int, progress: CGFloat)`回调里面调用
    ///
    /// - Parameters:
    ///   - leftIndex: leftIndex description
    ///   - rightIndex: rightIndex description
    ///   - percent: percent description
    ///   - selectedIndex: selectedIndex description
    open func segmentedViewScrolling(from leftIndex: Int, to rightIndex: Int, percent: CGFloat, selectedIndex: Int) {
        var targetIndex: Int = -1
        var disappearIndex: Int = -1
        if rightIndex == selectedIndex {
            //当前选中的在右边，用户正在从右边往左边滑动
            if percent < (1 - didAppearPercent) {
                targetIndex = leftIndex
                disappearIndex = rightIndex
            }else if selectedIndex != currentIndex {
                //处理快速滑动的时候，percent值比较跳跃
                targetIndex = selectedIndex
                disappearIndex = currentIndex
            }
        }else {
            //当前选中的在左边，用户正在从左边往右边滑动
            if percent > didAppearPercent {
                targetIndex = rightIndex
                disappearIndex = leftIndex
            }else if selectedIndex != currentIndex {
                //处理快速滑动的时候，percent值比较跳跃
                targetIndex = selectedIndex
                disappearIndex = currentIndex
            }
        }

        if targetIndex != -1 && currentIndex != targetIndex {
            listDidAppear(at: targetIndex)
            listDidDisappear(at: disappearIndex)
        }
    }


    /// 必须调用！在`func segmentedView(_ segmentedView: JXSegmentedBaseView, didClickSelectedItemAt index: Int)`回调里面调用
    ///
    /// - Parameter index: index description
    open func didClickSelectedItem(at index: Int) {
        listDidDisappear(at: currentIndex)
        listDidAppear(at: index)
    }

    //MARK: - Private
    private func currentListDidAppear() {
        listDidAppear(at: currentIndex)
    }

    @objc private func currentListDidDisappear() {
        let list = validListDict[currentIndex]
        list?.listDidDisappear?()
        willRemoveFromWindow = false
        retainedSelf = nil
    }

    private func listDidAppear(at index: Int) {
        let count = dataSource.numberOfLists(in: self)
        if count <= 0 || index >= count {
            return
        }
        currentIndex = index
        var list = validListDict[index]
        if list == nil {
            list = dataSource.listContainerView(self, initListAt: index)
        }
        if list?.listView().superview == nil {
            list?.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            scrollView.addSubview(list!.listView())
            validListDict[index] = list!
        }
        list?.listDidAppear?()
    }

    private func listDidDisappear(at index: Int) {
        let count = dataSource.numberOfLists(in: self)
        if count <= 0 || index >= count {
            return
        }
        validListDict[index]?.listDidDisappear?()
    }
}
