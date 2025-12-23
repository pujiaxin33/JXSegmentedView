//
//  CellCustomizeViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class CellCustomizeViewController: UITableViewController {

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
        let numbers = [1, 22, 333, 44444, 0, 66, 777, 0, 99999, 10]
        let dotStates = [false, true, true, true, false, false, true, true, false, true]
        let vc = ContentBaseViewController()
        vc.title = itemTitle

        switch itemTitle! {
        case "颜色渐变":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.titles = titles
            dataSource.bgNormalColor = UIColor.green
            vc.segmentedDataSource = dataSource
        case "文字渐变":
            //配置数据源
            let dataSource = JXSegmentedTitleGradientDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
        case "大小缩放":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.isTitleZoomEnabled = true
            dataSource.titleSelectedZoomScale = 1.3
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
        case "大小缩放+字体粗细":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.isTitleZoomEnabled = true
            dataSource.titleSelectedZoomScale = 1.3
            dataSource.isTitleStrokeWidthEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
        case "大小缩放+点击动画":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.isTitleZoomEnabled = true
            dataSource.titleSelectedZoomScale = 1.3
            dataSource.isTitleStrokeWidthEnabled = true
            dataSource.isSelectedAnimable = true
            dataSource.titles = titles
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            vc.segmentedView.indicators = [indicator]

            vc.segmentedDataSource = dataSource
        case "大小缩放+Cell宽度缩放":
            //高仿汽车之家
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.isTitleZoomEnabled = true
            dataSource.titleSelectedZoomScale = 1.3
            dataSource.isTitleStrokeWidthEnabled = true
            dataSource.isSelectedAnimable = true
            dataSource.isItemWidthZoomEnabled = true
            dataSource.titles = titles

            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            vc.segmentedView.indicators = [indicator]

            vc.segmentedDataSource = dataSource
        case "数字":
            //配置数据源
            let dataSource = JXSegmentedNumberDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.numbers = numbers
//            dataSource.numberHeight = 20
//            dataSource.numberFont = .systemFont(ofSize: 15)
            dataSource.numberStringFormatterClosure = {(number) -> String in
                if number > 999 {
                    return "999+"
                }
                return "\(number)"
            }
            vc.segmentedDataSource = dataSource
        case "红点":
            //配置数据源
            let dataSource = JXSegmentedDotDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.dotStates = dotStates
            vc.segmentedDataSource = dataSource
        case "文字和图片":
            //配置数据源
            let dataSource = JXSegmentedTitleImageDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.titleImageType = .rightImage
            dataSource.isImageZoomEnabled = true
            dataSource.normalImageInfos = ["monkey", "frog", "dog", "pig", "sheep", "chicken", "horse", "cow", "elephant", "dragon"]
            dataSource.loadImageClosure = {(imageView, normalImageInfo) in
                //如果normalImageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: normalImageInfo)
            }
            vc.segmentedDataSource = dataSource
        case "文字或者图片":
            //配置数据源
            let dataSource = JXSegmentedTitleOrImageDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.isTitleZoomEnabled = true
            dataSource.titleSelectedZoomScale = 1.3
            dataSource.isTitleStrokeWidthEnabled = true
            dataSource.isItemTransitionEnabled = false
            dataSource.isSelectedAnimable = true
            dataSource.titles = titles
            dataSource.selectedImageInfos = ["monkey", nil, "dog", nil, "sheep", "chicken", "horse", nil, nil, "dragon"]
            dataSource.loadImageClosure = {(imageView, normalImageInfo) in
                //如果normalImageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: normalImageInfo)
            }
            vc.segmentedDataSource = dataSource
        case "多行文字(自己添加换行符)":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.titleNumberOfLines = 2
            dataSource.titles = ["猴哥\nmonkey", "青蛙王子\nfrog", "旺财\ndot", "粉红猪\npig", "喜羊羊\nsheep", "黄焖鸡\nchicken", "小马哥\nhorse", "牛魔王\ncow", "大象先生\nelepant", "神龙\ndragon"]
            vc.segmentedDataSource = dataSource
        case "多行文字(固定宽度自动换行)":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.titleNumberOfLines = 2
            dataSource.itemWidth = 60
            dataSource.titles = ["猴哥 monkey", "青蛙王子 frog", "旺财 dot", "粉红猪 pig", "喜羊羊 sheep", "黄焖鸡 chicken", "小马哥 horse", "牛魔王 cow", "大象先生 elepant", "神龙 dragon"]
            vc.segmentedDataSource = dataSource
        case "多行富文本":
            //配置数据源
            let dataSource = JXSegmentedTitleAttributeDataSource()
            func formatNormal(attriText: NSMutableAttributedString) {
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)], range: NSRange(location: 2, length: attriText.string.count - 2))
            }
            func formatSelected(attriText: NSMutableAttributedString) {
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: 2))
                attriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], range: NSRange(location: 2, length: attriText.string.count - 2))
            }
            let mondayAttriText = NSMutableAttributedString(string: "周一\n1月7号")
            formatNormal(attriText: mondayAttriText)
            let tuesdayAttriText = NSMutableAttributedString(string: "周二\n1月8号")
            formatNormal(attriText: tuesdayAttriText)
            let wednesdayAttriText = NSMutableAttributedString(string: "周三\n1月9号")
            formatNormal(attriText: wednesdayAttriText)
            dataSource.attributedTitles = [mondayAttriText.copy(), tuesdayAttriText.copy(), wednesdayAttriText.copy()] as! [NSAttributedString]

            formatSelected(attriText: mondayAttriText)
            formatSelected(attriText: tuesdayAttriText)
            formatSelected(attriText: wednesdayAttriText)
            dataSource.selectedAttributedTitles = [mondayAttriText.copy(), tuesdayAttriText.copy(), wednesdayAttriText.copy()] as? [NSAttributedString]
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.indicatorHeight = 40
            indicator.indicatorCornerRadius = 5
            vc.segmentedView.indicators = [indicator]
        case "多种cell":
            let dataSource = JXSegmentedMixcellDataSource()
            vc.segmentedDataSource = dataSource
        case "Title Configuration":
            let vc = TitleConfigurationViewController()
            navigationController?.pushViewController(vc, animated: true)
            return
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }


}
