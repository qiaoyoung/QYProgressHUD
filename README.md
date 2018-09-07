# QYProgressHUD

## 使用方法:
#### 直接调用类方法 `[QYProgressHUD show]` 来展示加载动画, 调用类方法 `[QYProgressHUD dismiss]` 隐藏动画.    
* 展示和隐藏动画的时候无需关心线程问题，内部已经做了相关处理；
* 支持旋转屏幕，动画视图会跟随屏幕旋转；
* 加载动画期间 `userInteractionEnabled = NO` ，默认禁止交互;
* 因为在工程中使用频繁，该类是一个单例；
* 相对于其他加载动画的库，此类没有拓展其他功能，实现简单，只用于加载动画；
* 加载动画相关参数都在.m文件头部宏定义处，并未开放出来（有需要可自行修改）。
```
/**
show loading request animation.
*/
+ (void)show;

/**
dismiss loading animation.
*/
+ (void)dismiss;
```

## Example:
```
// 显示加载动画
[QYProgressHUD show];
// 隐藏加载动画
[QYProgressHUD dismiss];
```
## 效果:
![](https://github.com/qiaoyoung/QYProgressHUD/blob/master/QYProgressHUD.gif)

## 浅析QYProgressHUD：
* QYProgressHUD继承自UIWindow ，整个视图设计分为3层，`backgroundView` 全屏背景，`foregroundView` HUD动画背景，`activityIndicator` 小菊花动画。
* `backgroundView` 全屏背景：因为背景修改了alpha，直接把self当做背景的话，会影响其子视图透明度；
* `foregroundView`HUD动画背景：设计这一层是为了以后项目有新需求，可以直接在该视图层进行拓展；
* `activityIndicator`小菊花动画：采用的系统视图。

#### 当调用类方法 `show` 展现动画时，先执行单例方法，返回单例对象；然后调用实例方法 `qy_startAnimating` 添加加载动画。
```
+ (void)show {
    [[self sharedInstance] qy_startAnimating];
}
```
#### 因为实例方法 `qy_startAnimating` 中要进行视图添加、动画等操作，所以包裹在主线程中执行的。
```
    dispatch_async(dispatch_get_main_queue(), ^{
        ...
    });
```

#### 单例新建一个Window,  无需`addSubview`，默认创建是被添加到屏幕最上层的。只需要设置对应的 `hidden = NO` 即可显示出来。

#### 调用类方法 `dismiss` 移除动画，先执行单例方法，返回单例对象；然后调用实例方法 `qy_stopAnimating` 移除加载动画；该方法主要做了移除视图等操作。
```
+ (void)dismiss {
    [[self sharedInstance] qy_stopAnimating];
}
```
#### 如果我们创建出的UIWindow需要处理键盘事件, 可以将其设置为KeyWindow。KeyWindow是被系统设计用来接收键盘和其他非触摸事件的UIWindow。可以通过 `makeKeyWindow` 和 `resignKeyWindow` 用来设置。

#### 具体的实现细节请查看源码，如有不足，欢迎指正！


## Requirements

## Installation

QYProgressHUD is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QYProgressHUD'
```

## Author

qiaoyoung, 393098486@qq.com

## License

QYProgressHUD is available under the MIT license. See the LICENSE file for more info.
