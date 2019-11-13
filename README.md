# ZKCycleScrollView

ZKCycleScrollView是的一个功能强大的轮播视图。支持 [Objective-C](https://github.com/bestDew/ZKCycleScrollViewDemo-OC) 和 [Swift](https://github.com/bestDew/ZKCycleScrollViewDemo)。

### 提示：下载完 Demo 后，需执行下 ```pod install```才能运行。

## 特性

-   高度可定制化
-   支持 Xib 方式创建
-   支持 CocoaPods 方式导入

## 演示效果图

![image](https://github.com/bestDew/ZKCycleScrollViewDemo-OC/blob/master/ZKCycleScrollViewDemo-OC/Untitled.gif)

## 用法示例

```objc

@interface ViewController () <ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZKCycleScrollView *cycleScrollView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, 375.f, 65.f)];
    cycleScrollView.delegate = self;
    cycleScrollView.dataSource = self;
    [cycleScrollView registerCellClass:[CustomCell class] forCellWithReuseIdentifier:@"cellReuseId"];
    [self.view addSubview:cycleScrollView];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    return 5;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
   CustomCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:@"cellReuseId" forIndex:index];
   // TODO:
   return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // TODO:
}

@end

```

## 更新记录

### Version 2.0.1（2019/11/11）：

1.支持 CococaPods 导入：
  ```objc
  pod 'ZKCycleScrollView'
  ```
2.支持取消无限轮播：
  ```objc
  // 通过Xib 方式创建的，可直接在属性面板中直接设置 infiniteLoop 为 off
  // 通过纯代码方式创建的，需要使用下面这种初始化方法并设置 infiniteLoop 参数为 NO
  - (instancetype)initWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop NS_DESIGNATED_INITIALIZER;
  ```
3.支持设置默认显示页：
  ```objc
  // 设置默认从第三页开始显示
  __weak typeof(self) weakSelf = self;
    _cycleScrollView.loadCompletion = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.cycleScrollView scrollToIndex:3 animated:NO];
    };
  ```
 4.修复界面跳转时 cell 自动偏移的 bug；<br/>
 
 5.修复在加载时就回调代理方法的 bug；<br/>
 
 6.移除 -adjustWhenViewWillAppear 方法；<br/>
 
 7.新增 -beginUpdates、-endUpdates、-scrollToIndex:animated:、-cellForItemAtIndex: 等方法，具体使用见Demo；<br/>
 
 8.优化性能。
