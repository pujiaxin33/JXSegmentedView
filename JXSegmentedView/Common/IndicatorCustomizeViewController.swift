//
//  IndicatorCustomizeViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class IndicatorCustomizeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var title: String?
        for subview in cell!.contentView.subviews {
            if let label = subview as? UILabel {
                title = label.text
                break
            }
        }

        let titles = ["猴哥", "黄焖鸡", "旺财", "粉红猪", "喜羊羊", "青蛙王子", "小马哥", "牛魔王", "大象先生", "神龙"]
        let vc = ContentBaseViewController()
        vc.title = title

        switch title! {
        case "ss":
            print("22")
        default:
            break
        }

        switch indexPath.row {
        case 0:
            //固定宽度
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = 20
            vc.segmentedView.indicators = [indicator]
        case 1:
            //与cell等宽
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            vc.segmentedView.indicators = [indicator]
        case 2:
            //lineView延长
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.lineStyle = .lengthen
            vc.segmentedView.indicators = [indicator]
        case 3:
            //lineView延长+偏移
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.lineStyle = .lengthenOffset
            vc.segmentedView.indicators = [indicator]
        case 4:
            //lineView延长+偏移+🌈彩虹效果
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorRainbowLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.lineStyle = .lengthenOffset
            indicator.indicatorColors = [.red, .yellow, .blue, .orange, .purple, .cyan, .gray, .red, .yellow, .blue]
            vc.segmentedView.indicators = [indicator]
        case 5:
            //三角形
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorTriangleView()
            vc.segmentedView.indicators = [indicator]
        case 6:
            //椭圆形
            //配置数据源
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.isTitleColorGradientEnabled = false
            dataSource.isTitleMaskEnabled = true
            dataSource.titles = titles
            dataSource.reloadData(selectedIndex: 0)
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = JXSegmentedIndicatorBackgroundView()
            indicator.alpha = 0
            indicator.isIndicatorConvertToItemFrameEnabled = true
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        default:
            break
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    if (indexPath.row == 12) {
//    //IndicatorImageView底部
//    IndicatorImageViewViewController *indicatorImageViewVC = [[IndicatorImageViewViewController alloc] init];
//    indicatorImageViewVC.title = title;
//    [self.navigationController pushViewController:indicatorImageViewVC animated:YES];
//    return;
//    }else if (indexPath.row == 13) {
//    //IndicatorImageView cell背景
//    BackgroundImageViewController *backgroundImageVC = [[BackgroundImageViewController alloc] init];
//    backgroundImageVC.title = title;
//    [self.navigationController pushViewController:backgroundImageVC animated:YES];
//    return;
//    }else if (indexPath.row == 14) {
//    //足球滚动
//    FootballViewController *footballVC = [[FootballViewController alloc] init];
//    footballVC.title = title;
//    [self.navigationController pushViewController:footballVC animated:YES];
//    return;
//    }

//{
//    //qq红点
//    testVC.isNeedIndicatorPositionChangeItem = YES;
//    titleCategoryView.titleColorGradientEnabled = YES;
//    JXCategoryIndicatorBallView *ballView = [[JXCategoryIndicatorBallView alloc] init];
//    titleCategoryView.indicators = @[ballView];
//    }
//    break;
//    case 5:
//{

//    case 6:
//{
//    //椭圆形
//    titleCategoryView.titleColorGradientEnabled = YES;
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    JXGradientView *gradientView = [JXGradientView new];
//    gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
//    gradientView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:90.0/255 green:215.0/255 blue:202.0/255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:122.0/255 green:232.0/255 blue:169.0/255 alpha:1].CGColor,];
//    //设置gradientView的渐变色
//    //用约束gradientView与backgroundView一样的大小
//    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [backgroundView addSubview:gradientView];
//    backgroundView.backgroundViewHeight = 20;
//    backgroundView.backgroundViewCornerRadius = JXCategoryViewAutomaticDimension;
//    titleCategoryView.indicators = @[backgroundView];
//    }
//    break;
//    case 7:
//{
//    //阴影
//    titleCategoryView.titleColorGradientEnabled = YES;
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    backgroundView.backgroundViewHeight = 20;
//    backgroundView.backgroundViewCornerRadius = JXCategoryViewAutomaticDimension;
//    backgroundView.layer.shadowColor = [UIColor redColor].CGColor;
//    backgroundView.layer.shadowRadius = 3;
//    backgroundView.layer.shadowOffset = CGSizeMake(3, 4);
//    backgroundView.layer.shadowOpacity = 0.6;
//    titleCategoryView.indicators = @[backgroundView];
//    }
//    break;
//    case 8:
//{
//    //长方形
//    titleCategoryView.titleColorGradientEnabled = YES;
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    backgroundView.backgroundViewHeight = JXCategoryViewAutomaticDimension;
//    backgroundView.backgroundViewCornerRadius = 0;
//    titleCategoryView.indicators = @[backgroundView];
//    }
//    break;
//    case 9:
//{
//    //文字遮罩有背景
//    titleCategoryView.titleColorGradientEnabled = NO;
//    titleCategoryView.titleLabelMaskEnabled = YES;
//
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    backgroundView.backgroundViewWidthIncrement = 10;
//    backgroundView.backgroundViewHeight = 20;
//    titleCategoryView.indicators = @[backgroundView];
//    }
//    break;
//    case 10:
//{
//    //文字遮罩无背景
//    titleCategoryView.titleColorGradientEnabled = NO;
//    titleCategoryView.titleLabelMaskEnabled = YES;
//
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    backgroundView.backgroundViewWidthIncrement = 10;
//    backgroundView.backgroundViewHeight = 20;
//    backgroundView.alpha = 0;
//    titleCategoryView.indicators = @[backgroundView];
//    }
//    break;
//    case 11:
//{
//    //渐变色
//    titleCategoryView.titleColorGradientEnabled = YES;
//    titleCategoryView.titleSelectedColor = [UIColor whiteColor];
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//
//    //相当于把JXCategoryIndicatorBackgroundView当做视图容器，你可以在上面添加任何想要的效果
//    JXGradientView *gradientView = [JXGradientView new];
//    gradientView.gradientLayer.endPoint = CGPointMake(1, 0);
//    gradientView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:90.0/255 green:215.0/255 blue:202.0/255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:122.0/255 green:232.0/255 blue:169.0/255 alpha:1].CGColor,];
//    //设置gradientView布局和JXCategoryIndicatorBackgroundView一样
//    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [backgroundView addSubview:gradientView];
//
//    backgroundView.backgroundViewHeight = 20;
//    backgroundView.backgroundViewCornerRadius = 0;
//    titleCategoryView.indicators = @[backgroundView];
//    break;
//    }
//    case 15:
//{
//    //混合使用
//    titleCategoryView.titleColorGradientEnabled = NO;
//    titleCategoryView.titleLabelMaskEnabled = YES;
//
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    backgroundView.backgroundViewHeight = 20;
//
//    titleCategoryView.indicators = @[backgroundView, lineView];
//    }
//    break;
//    case 16:
//{
//    //indicator自定义-点线效果
//    testVC.isNeedIndicatorPositionChangeItem = YES;
//    titleCategoryView.titleColorGradientEnabled = YES;
//    JXCategoryIndicatorDotLineView *lineView = [[JXCategoryIndicatorDotLineView alloc] init];
//    titleCategoryView.indicators = @[lineView];
//    }
//    break;
//    case 17:
//{
//    //indicatorLineView-🌈彩虹效果
//    testVC.isNeedIndicatorPositionChangeItem = YES;
//    JXCategoryIndicatorRainbowLineView *lineView = [[JXCategoryIndicatorRainbowLineView alloc] init];
//    NSArray *colors = @[[UIColor redColor],
//    [UIColor yellowColor],
//    [UIColor blueColor],
//    [UIColor orangeColor],
//    [UIColor purpleColor],
//    [UIColor cyanColor],
//    [UIColor magentaColor],
//    [UIColor grayColor],
//    [UIColor redColor],
//    [UIColor yellowColor],
//    [UIColor blueColor],];
//    lineView.indicatorColors = colors;
//    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
//    titleCategoryView.indicators = @[lineView];
//    }
//    break;
//
//    default:
//    break;
//    }
//    [self.navigationController pushViewController:testVC animated:YES];
//    }

}
