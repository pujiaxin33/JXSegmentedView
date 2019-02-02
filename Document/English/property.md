# Common Property Description

## JXSegmentedView Common Property

Property     | Description           |
--------------|---------------|
Indicators | elements must be UIView and its subclasses that follow the JXSegmentedIndicatorProtocol protocol |
defaultSelectedIndex | Initialize or reloadData before setting to specify the default index |
selectedIndex | Read-only property, get the currently selected index |
contentEdgeInsetLeft | Left margin of the overall content |
contentEdgeInsetRight | Right margin of the overall content |
isContentScrollViewClickTransitionAnimationEnabled | Whether to switch between contentScrollView needs to be animated when clicking switch |

## JXSegmentedViewDataSource Protocol Series Common Property

### JXSegmentedBaseDataSource Common Property

Property     | Description           |
--------------|---------------|
dataSource | The data source array that is ultimately passed to JXSegmentedView |
itemContentWidth | The content width of the cell is JXSegmentedViewAutomaticDimension, which is based on the width of the content calculation. Otherwise, the specific value of itemContentWidth is used. |
itemWidthIncrement | true item width = itemContentWidth + itemWidthIncrement. |
itemSpacing | spacing before item |
isItemSpacingAverageEnabled | Whether itemSpacing is evenly divided when collectionView.contentSize.width is less than the width of JXSegmentedView. |
isItemTransitionEnabled | whether the gradient is allowed when the item scrolls left and right. For example, JXSegmentedTitleDataSource's titleZoom, titleNormalColor, titleStrokeWidth and other gradients. |
isSelectedAnimable | Whether an animation transition is required when selected. Custom cells need to handle animation transition logic themselves, animation processing logic reference `JXSegmentedTitleCell` |
selectedAnimationDuration | Select the duration of the animation |
isItemWidthZoomEnabled | Whether to allow item width scaling |
itemWidthSelectedZoomScale | item width when selected scale |

### JXSegmentedTitleDataSource Common Property

Property     | Description           |
--------------|---------------|
Titles | title array |
titleNumberOfLines | label numberOfLines |
titleNormalColor | title textColor for normal state |
titleSelectedColor | title selected textColor |
titleNormalFont | title font in normal state |
titleSelectedFont | The font of the title when it is selected. If you don't assign a value, it's the same as titleNormalFont by default |
isTitleColorGradientEnabled | Whether the color of the title is gradual transition |
isTitleZoomEnabled | Whether the title is scaled. When using this effect, be sure to ensure that the titleNormalFont and titleSelectedFont values ​​are the same. |
titleSelectedZoomScale | isTitleZoomEnabled to true to take effect. It is the scaling of the font size. For example, the pointSize of titleNormalFont is 10, and the font size is 10*1.2=12 after zooming in. |
isTitleStrokeWidthEnabled | Whether the line width of the title allows thickness. When using this effect, be sure to ensure that the titleNormalFont and titleSelectedFont values ​​are the same. |
titleSelectedStrokeWidth | Used to control the thickness of the font (the bottom layer is implemented by NSStrokeWidthAttributeName). The smaller the negative number, the thicker the font. |
isTitleMaskEnabled | title Whether to use mask transitions |

### JXSegmentedTitleImageDataSource Common Property

Property     | Description           |
--------------|---------------|
titleImageType | JXSegmentedTitleImageType type, set the text image display type |
normalImageInfos | The number needs to be the same as the number of items. Can be ImageName or image address |
selectedImageInfos | The number needs to be the same as the number of items. Can be ImageName or image network address. If no value is assigned, the image switch will not be processed when selected. |
loadImageClosure | Internally, the image is loaded via UIImage(named:). If you pass the image network address or want to handle the image loading logic yourself, you can use this closure. |
imageSize | Image size |
titleImageSpacing | The gap between title and image |
isImageZoomEnabled | Whether to enable image scaling |
imageSelectedZoomScale | Scale when the image is zoomed |

### JXSegmentedTitleOrImageDataSource Common Property

Property     | Description           |
--------------|---------------|
selectedImageInfos | The number needs to be the same as the number of items. Can be ImageName or image address. Fill in nil without displaying the image when selected
loadImageClosure | Internally, the image is loaded via UIImage(named:). If you pass the image address or want to handle the image loading logic yourself, you can use this closure. |
imageSize | Image Size |

### JXSegmentedTitleGradientDataSource Common Property

Property     | Description           |
--------------|---------------|
titleNormalGradientColors | title Gradient colors in normal state |
titleSelectedGradientColors | title Gradient colors in the selected state |
titleGradientStartPoint | title gradient StartPoint |
titleGradientEndPoint | title gradient EndPoint |

### JXSegmentedTitleAttributeDataSource Common Property

Property     | Description           |
--------------|---------------|
attributedTitles | rich text title array |
selectedAttributedTitles | Rich text when selected, optional. If you want to use make sure the count is consistent with the attributeTitles. |
titleNumberOfLines | title numberOfLines |

### JXSegmentedNumberDataSource Common Property

Property     | Description           |
--------------|---------------|
Numbers | Need to match the number of titles arrays, fill in 0 with no number items! ! ! |
numberWidthIncrement | numberLabel width compensation, the true width of numberLabel is the width of the text content plus the width of the compensation |
numberBackgroundColor | background color of numberLabel |
numberTextColor | numberLabel's textColor |
numberFont | numberLabel's font |
numberOffset | The default position of numberLabel is center in the upper right corner of titleLabel, which can control the offset of X and Y axes by numberOffset |
numberStringFormatterClosure | If the business needs to process more than 999 as if it were 999+, it can be implemented through this closure. The default display does not process the number |


### JXSegmentedDotDataSource Common Property

Property     | Description           |
--------------|---------------|
dotStates | quantity needs to be consistent with titles, control whether red dot is displayed |
dotSize | Red dot size |
dotCornerRadius | Red dot fillet value, JXSegmentedViewAutomaticDimension equals dotSize.height/2 |
dotColor | Red dot color |
dotOffset | The default position of dotView is center in the upper right corner of titleLabel. You can control the offset of X and Y axis by dotOffset.

## JXSegmentedIndicatorProtocol Series Common Property

### JXSegmentedIndicatorBaseView Common Property

Property     | Description           |
--------------|---------------|
indicatorWidth | Default JXSegmentedViewAutomaticDimension (equal to the width of the cell). Internally get the actual value via the getIndicatorWidth method |
indicatorHeight | Default JXSegmentedViewAutomaticDimension (equal to the height of the cell). Internally get the actual value via the getIndicatorHeight method |
indicatorCornerRadius | Default JXSegmentedViewAutomaticDimension (equal to indicatorHeight/2). Internally get the actual value via the getIndicatorCornerRadius method |
indicatorColor | indicator color |
indicatorPosition | position of the indicator, top or bottom |
verticalOffset | Vertical offset, the indicator defaults to the bottom or top, and the larger the verticalOffset, the closer to the center. |
isScrollEnabled | Whether to allow scrolling when the gesture scrolls or clicks. |
scrollAnimationDuration | Click on the scrolling animation duration when selected |
isIndicatorConvertToItemFrameEnabled | Whether to convert the current indicator's frame to cell. The use of the isTitleMaskEnabled property of the auxiliary JXSegmentedTitleDataSourced. |


### JXSegmentedIndicatorLineView Common Property

Property     | Description           |
--------------|---------------|
lineStyle | JXSegmentedIndicatorLineStyle Style |
lineScrollOffsetX | lineStyle is used for lengthenOffset, the offset of x when scrolling |


### JXSegmentedIndicatorRainbowLineView Common Property

Property     | Description           |
--------------|---------------|
indicatorColors | The number needs to be equal to the number of items. The default empty array must be assigned this property. When segmentedView is in reloadData, it should also update the property together, otherwise the array will be out of bounds. |


### JXSegmentedIndicatorDotLineView Common Property

Property     | Description           |
--------------|---------------|
lineMaxWidth | maximum width of the line |

### JXSegmentedIndicatorDoubleLineView Common Property

Property     | Description           |
--------------|---------------|
minLineWidthPercent | Line shrinks to the smallest percentage |

### JXSegmentedIndicatorBackgroundView Common Property

Property     | Description           |
--------------|---------------|
backgroundWidthIncrement | width increment, background indicator is generally wider than cell |

### JXSegmentedIndicatorTriangleView Common Property

Use the attribute inherited from `JXSegmentedIndicatorBaseView`

### JXSegmentedIndicatorImageView Common Property

Property     | Description           |
--------------|---------------|
Image | Set indicator picture |

### JXSegmentedIndicatorGradientView Common Property

Property     | Description           |
--------------|---------------|
gradientColors | Gradient colors |
gradientViewWidthIncrement | width increment, background indicator is generally wider than cell |
gradientLayer | gradient CAGradientLayer, through which to set startPoint, endPoint and other properties |

## JXSegmentedListContainerView Common Property

Property     | Description           |
--------------|---------------|
didAppearPercent | When scrolling, the scrolling distance exceeds the percentage of a page, and the page is considered to be switched. The default is 0.5 (that is, scrolling over half a screen, it is considered to turn pages). Range 0~1, open interval does not include 0 and 1 |
defaultSelectedIndex | needs to be consistent with segmentedView.defaultSelectedIndex to trigger the loading of the default index list |
validListDict | The list dictionary that has been loaded. Key is index, value is the corresponding list |
dataSource | JXSegmentedListContainerViewDataSource class |
scrollView | read-only property, internally held UIScrollView |












