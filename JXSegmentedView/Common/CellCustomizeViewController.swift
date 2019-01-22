//
//  CellCustomizeViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

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

        let titles = ["猴哥", "黄焖鸡", "旺财", "粉红猪", "喜羊羊", "青蛙王子", "小马哥", "牛魔王", "大象先生", "神龙"]
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
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        case "大小缩放":
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titleSelectedColor = UIColor.red
            dataSource.isTitleZoomEnabled = true
            dataSource.titleZoomScale = 1.3
            dataSource.isTitleStrokeWidthEnabled = true
            dataSource.isClickedAnimable = true
            dataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        case "数字":
            //配置数据源
            let dataSource = JXSegmentedNumberDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.numbers = numbers
            dataSource.numberStringFormatterClosure = {(number) -> String in
                if number > 999 {
                    return "999+"
                }
                return "\(number)"
            }
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        case "红点":
            //配置数据源
            let dataSource = JXSegmentedDotDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.dotStates = dotStates
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        case "文字和图片":
            //配置数据源
            let dataSource = JXSegmentedTitleImageDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.titleImageType = .rightImage
            dataSource.isImageZoomEnabled = true
            dataSource.imageInfos = ["monkey", "chicken", "dog", "pig", "sheep", "frog", "horse", "cow", "elephant", "dragon"]
            dataSource.loadImageClosure = {(imageView, imageInfo) in
                //如果imageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: imageInfo)
            }
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        case "文字或者图片":
            //配置数据源
            let dataSource = JXSegmentedTitleOrImageDataSource()
            dataSource.titles = titles
            dataSource.selectedImageInfos = ["monkey", "", "dog", "", "sheep", "frog", "horse", "cow", "elephant", "dragon"]
            dataSource.loadImageClosure = {(imageView, imageInfo) in
                //如果imageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: imageInfo)
            }
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        case "多行富文本":
            //配置数据源
            let dataSource = JXSegmentedTitleAttributeDataSource()
            let mondayAttriText = NSMutableAttributedString(string: "周一\n1月7号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
            mondayAttriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))

            let tuesdayAttriText = NSMutableAttributedString(string: "周二\n1月8号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
            tuesdayAttriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))

            let wednesdayAttriText = NSMutableAttributedString(string: "周三\n1月9号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)])
            wednesdayAttriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))
            dataSource.attributeTitles = [mondayAttriText.copy(), tuesdayAttriText.copy(), wednesdayAttriText.copy()] as! [NSAttributedString]

            mondayAttriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))
            tuesdayAttriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))
            wednesdayAttriText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))

            dataSource.selectedAttributeTitles = [mondayAttriText.copy(), tuesdayAttriText.copy(), wednesdayAttriText.copy()] as! [NSAttributedString]
            //reloadData(selectedIndex:)一定要调用
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        case "多种cell":
            let dataSource = JXSegmentedMixcellDataSource()
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
        default:
            break
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
