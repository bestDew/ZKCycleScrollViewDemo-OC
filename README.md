# ZKCycleScrollView

A simple and useful automatic infinite scroll view, support for Objective-C and Swift.

## ScreenShot

![image](https://github.com/bestDew/ZKCycleScrollViewDemo-OC/blob/master/ZKCycleScrollViewDemo-OC/Untitled.gif)

## Features

-   Horizontal and vertical scrolling
-   Cell and pageControl customization
-   Interface Builder

## Usage

```objc

@interface ViewController () <ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {

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

## Link

[Swift version](https://github.com/bestDew/ZKCycleScrollViewDemo)
