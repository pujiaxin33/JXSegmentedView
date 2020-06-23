## RTL布局说明

JXSegmentedView内部会根据当前UIView的semanticContentAttribute属性值，自适应LTR布局/RTL布局

## RTL布局调试说明

选择JXSegmentedViewRTLExpamle Scheme运行真机/模拟器，就可以调试RTL布局

RTL布局默认是使用阿拉伯语作为调试语言，你也可以添加自己的语言作为调试语言
步骤1：Xcode -> Project -> Localization -> +
步骤2：修改JXSegmentedViewRTLExpamle Scheme中的system language
