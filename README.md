#### 关于手势返回 #
由于组件隐藏了导航栏,无法支持手势返回，解决办法有如下两种:
1. 显示导航栏，将组件的segementView设置为navigationItem.titleView，注意iOS11以后的适配问题，包括titleView的起始x不为0，UIScrollview的contentInset自适应导致subViewController页面出现偏移。
2. 隐藏导航栏，使用开源项目来进行手势支持扩展。

冲突问题:UIScrollview在contentSize大于Bounds.size时候，UIScrollview上会添加一个滑动手势，该手势会与侧滑手势冲突
冲突解决:通过设置UIScrollview的滑动手势的识别优先级大于滑动手势，在处于非第一个子控制器时关闭滑动手势。
