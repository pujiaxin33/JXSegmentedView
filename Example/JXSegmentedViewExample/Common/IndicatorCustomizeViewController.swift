//
//  IndicatorCustomizeViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class IndicatorCustomizeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var itemTitle: String?
        for subview in cell!.contentView.subviews {
            if let label = subview as? UILabel {
                itemTitle = label.text
                break
            }
        }

        let titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        let vc = ContentBaseViewController()
        vc.title = itemTitle

        switch itemTitle! {
        case "LineView固定长度":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = 20
            vc.segmentedView.indicators = [indicator]
        case "LineView与Cell同宽":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            vc.segmentedView.indicators = [indicator]
        case "LineView延长style":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.lineStyle = .lengthen
            vc.segmentedView.indicators = [indicator]
        case "LineView延长+偏移style":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.lineStyle = .lengthenOffset
            vc.segmentedView.indicators = [indicator]
        case "LineView彩虹":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorRainbowLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.lineStyle = .lengthenOffset
            indicator.indicatorColors = [.red, .green, .blue, .orange, .purple, .cyan, .gray, .red, .yellow, .blue]
            vc.segmentedView.indicators = [indicator]
        case "TriangleView三角形":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorTriangleView()
            vc.segmentedView.indicators = [indicator]
        case "BallView小红点":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView椭圆形":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView椭圆形+阴影":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            indicator.layer.shadowColor = UIColor.red.cgColor
            indicator.layer.shadowRadius = 3
            indicator.layer.shadowOffset = CGSize(width: 3, height: 4)
            indicator.layer.shadowOpacity = 0.6
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView遮罩有背景":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = false
            dataSource.isTitleMaskEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.isIndicatorConvertToItemFrameEnabled = true
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView遮罩无背景":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = false
            dataSource.isTitleMaskEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.alpha = 0
            indicator.isIndicatorConvertToItemFrameEnabled = true
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView渐变色":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.clipsToBounds = true
            indicator.indicatorHeight = 30
            //相当于把JXSegmentedIndicatorBackgroundView当做视图容器，你可以在上面添加任何想要的效果
            let gradientView = JXSegmentedComponetGradientView()
            gradientView.gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientView.gradientLayer.colors = [UIColor(red: 90/255, green: 215/255, blue: 202/255, alpha: 1).cgColor, UIColor(red: 122/255, green: 232/255, blue: 169/255, alpha: 1).cgColor]
            //设置gradientView布局和JXSegmentedIndicatorBackgroundView一样
            gradientView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
            indicator.addSubview(gradientView)
            vc.segmentedView.indicators = [indicator]
        case "ImageView底部":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorImageView()
            indicator.image = UIImage(named: "car")
            indicator.indicatorWidth = 24
            indicator.indicatorHeight = 18
            vc.segmentedView.indicators = [indicator]
        case "ImageView背景":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorImageView()
            indicator.indicatorWidth = 50
            indicator.indicatorHeight = 50
            indicator.image = UIImage(named: "light")
            vc.segmentedView.indicators = [indicator]
        case "混合使用":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let lineIndicator = JXSegmentedIndicatorLineView()
            lineIndicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            lineIndicator.lineStyle = .normal

            let bgIndicator = JXSegmentedIndicatorBackgroundView()
            bgIndicator.indicatorHeight = 30
            vc.segmentedView.indicators = [lineIndicator, bgIndicator]
        case "DotLine点线效果":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorDotLineView()
            vc.segmentedView.indicators = [indicator]
        case "DoubleLine双线效果":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorDoubleLineView()
            vc.segmentedView.indicators = [indicator]
        case "GradientView渐变色":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorGradientView()

            vc.segmentedView.indicators = [indicator]
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
