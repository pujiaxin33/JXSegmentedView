//
//  JXSegmentedIndicatorParamsModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit
/**
 指示器不同情况处理时传递的数据模型，不同情况会对不同的属性赋值，根据不同情况的api说明确认。
 为什么会通过model传递数据，因为指示器处理逻辑以后会扩展不同的使用场景，会新增参数，如果不通过model传递，就会在api新增参数，一旦修改api该的地方就特别多了，而且会影响到之前自定义实现的开发者。
 */
open class JXSegmentedIndicatorParamsModel {
    open var currentSelectedIndex: Int = 0                      //当前选中的index
    open var currentSelectedItemFrame: CGRect = CGRect.zero     //当前选中的cellFrame
    open var leftIndex: Int = 0                                 //正在过渡中的两个cell，相对位置在左边的cell的index
    open var leftItemFrame: CGRect = CGRect.zero                //正在过渡中的两个cell，相对位置在左边的cell的frame
    open var rightIndex: Int = 0                                //正在过渡中的两个cell，相对位置在右边的cell的index
    open var rightItemFrame: CGRect = CGRect.zero               //正在过渡中的两个cell，相对位置在右边的cell的frame
    open var percent: Double = 0                                //正在过渡中的两个cell，从左到右的百分比
    open var lastSelectedIndex: Int = 0                         //之前选中的index
    open var isClicked: Bool = false                            //YES:通过点击选中；NO:通过滚动选中
}
