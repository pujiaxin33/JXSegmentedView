# Screen Edge Guesture Process

**Import Point**：
The result of the side-slip gesture processing is that the side-slip gesture is allowed to return to the previous page when the current page is on the first page. When you are on another page, sliding on the edge of the screen will only scroll left and right in response to the list page. The goal of doing this is to facilitate the user to stay on the current page and to switch the list.

If the product manager doesn't need such a feature and wants the side-slip gesture to respond in any situation, you don't need to refer to this tutorial and do nothing.

## `UIViewController` lifecycle method processing

```Swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //Allow screen edge gestures to return when in the first item
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.segmentedView.selectedIndex == 0)
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    //When you leave the page, you need to restore the screen edge gesture, can not affect other pages
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
}
```

## `JXSegmentedViewDelegate` selected proxy method processing

```Swift
func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.segmentedView.selectedIndex == 0)
}
```

## Custom navigation bar returns Item, in addition to adding the above code, you need the following additional processing

- Set delegate：
```Swift
self.navigationController?.interactivePopGestureRecognizer?.delegate = self
```

- Set gesture delegate method
```Swift
func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
}
```
