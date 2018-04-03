# photoBrowser-swift
更好用的swift图片浏览器


### 使用
进入项目目录，pod install安装yywebimage，安装成功后即可运行
该图片浏览器的使用十分简单，支持单击退出，双击放大，双指缩放，长按保存图片等操作，满足一切常规需求
##### 简要说明：
1.初始化PhotoBrowserVC，设置数据源
```
// 1.创建控制器
let browserVC = PhotoBrowserController(indexPath: indexPath as NSIndexPath, imageArray: imageModels!)
// 2.设置modal样式
browserVC.modalPresentationStyle = .custom

// 3.设置转场的代理
browserVC.transitioningDelegate = modalAnimator

// 4.设置动画的代理和当前的indexPath
modalAnimator.indexPath = indexPath as NSIndexPath
modalAnimator.presentedDelegate = self as AnimatorPresentDelegate
modalAnimator.dismissDelegate = (browserVC as AnimatorDismissDelegate)

// 5.弹出图片浏览器
present(browserVC, animated: true, completion: nil)
```
2.遵守代理
```
func startRect(indexPath: NSIndexPath) -> CGRect
func endRect(indexPath: NSIndexPath) -> CGRect
func imageView(indexPath: NSIndexPath) -> UIImageView
```

# THANKS!
