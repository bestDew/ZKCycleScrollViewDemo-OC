# ZKCycleScrollView

ZKCycleScrollView是的一个功能强大的轮播视图。有 [Objective-C](https://github.com/bestDew/ZKCycleScrollViewDemo-OC) 和 [Swift](https://github.com/bestDew/ZKCycleScrollViewDemo) 两个版本。

## 演示效果图

![image](https://github.com/bestDew/ZKCycleScrollViewDemo-OC/blob/master/ZKCycleScrollViewDemo-OC/Untitled.gif)

## 特性

-   高度可定制化
-   支持 Xib 方式创建
-   支持 CocoaPods 方式导入

## 代码示例

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
