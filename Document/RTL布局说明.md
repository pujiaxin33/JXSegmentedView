## RTL布局说明

JXSegmentedView内部会根据当前UIView的semanticContentAttribute属性值，自适应LTR布局/RTL布局

## RTL布局调试说明

以下两种方式可自行选择一种，项目默认使用第一种

1.请将手机系统语言设置为阿拉伯语，项目默认只添加了阿拉伯语的本地化

当然你也可以在Xcode中添加自己的的本地化语言JXSegmentedViewExample -> Project -> Localizations -> +

2.在applicationDidFinishLaunching代理里面根据自己所需的手机系统语言，手动设置界面布局方向

if Locale.preferredLanguages.first?.components(separatedBy: "-").first == "ar" {
    UIView.appearance().semanticContentAttribute = .forceRightToLeft
}

3.如果选择第一种方式，当你需要恢复LTR布局时，请在手机系统语言中删除阿拉伯语
