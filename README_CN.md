# ZKCycleScrollView

一款简单实用的轮播图控件，支持 Objective-C 和 Swift。

## 效果图

![效果图](https://github.com/bestDew/ZKCycleScrollViewDemo-OC/blob/master/ZKCycleScrollViewDemo-OC/Untitled.gif)

## 特性

-   支持横向和竖向滚动
-   支持 cell 和 pageControl 自定制
-   支持 xib 和 storyBoard

## 使用

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
   // TODO...
   return cell;
}

#pragma mark -- ZKCycleScrollView Dlegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // TODO...
}

@end

```

## 链接

-   [English document](./README.md)
-   [Swift 版本](https://github.com/bestDew/ZKCycleScrollViewDemo)

## 感谢

如果对你有帮助, 赏颗星吧😘。
