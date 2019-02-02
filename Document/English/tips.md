# Usage Tips  

## Screen Edge Guesture Process

[Screen Edge Guesture Process document address](https://github.com/pujiaxin33/JXSegmentedView/blob/master/Document/English/gesture.md)

## JXSegmentedView ReloadData

After the initialization, there are new data sources, property configuration changes (such as pulling data back from the server, re-assigning titles), you need to call the `reloadData` method to refresh the state.

## contentScrollView association description

There is no requirement for layout between them. You can put JXSegmentedView into the navigation bar, UITableViewSectionHeader and so on.

## ContentScrollView toggles effect after clicking Item

Controlled by the `isContentScrollViewClickTransitionAnimationEnabled` property. When you click to switch items: set to true, contentScrollView will scroll. Set to false, the contentScrollView toggles without scrolling animation.

## JXSegmentedView.collectionView.height floor

```Swift
open override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: floor(bounds.size.height))
}
```
In order to adapt to different mobile phone screen sizes, some users have the same aspect ratio requirements for JXSegmentedView. So its height will be different for screens of different widths. The calculated height, sometimes a long floating point number, will trigger an internal error if this height is set to UICollectionView. Therefore, in order to circumvent this problem, here we are rounded up to a high degree of uniformity.
If the rounding down causes your page to be abnormal, please reset the height of the JXSegmentedView yourself and make sure it is an integer.

## Set the parentally VC's automaticallyallyAdjustsScrollViewInsets property to false

Because the UICollectionView is used internally by JXSegmentedView, some systems will make incorrect adjustments to the internal UICollectionView. So, the internal will find the parent VC itself, and then set its automaticallyAdjustsScrollViewInsets property to false.
```SWift
open override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)

    var nextResponder: UIResponder? = newSuperview
    while nextResponder != nil {
        if let parentVC = nextResponder as? UIViewController  {
            parentVC.automaticallyAdjustsScrollViewInsets = false
            break
        }
        nextResponder = nextResponder?.next
    }
}
```
 
## Single cell refresh

Call the `func reloadItem(at index: Int)` method to refresh the specified index.
In some cases, you need to refresh the UI display of a certain cell, such as the red dot example.
 
## Custom suggestion

`JXSegmentedView` does not satisfy all situations even if flexible extensions are provided. In case of failure to meet special needs, it is recommended to implement special effects through the fork respository.
