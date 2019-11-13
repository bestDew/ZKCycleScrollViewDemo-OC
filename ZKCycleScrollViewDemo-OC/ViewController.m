//
//  ViewController.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/9.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "ViewController.h"
#import "TextCell.h"
#import "ImageCell.h"
#import "SubViewController.h"
#import "UIColor+Random.h"
#import <ZKCycleScrollView/ZKCycleScrollView.h>
#import <CHIPageControl/CHIPageControl-Swift.h>

static NSString * const kTextCellId = @"TextCell";
static NSString * const kImageCellId = @"ImageCell";
static NSString * const kColorCellId = @"ColorCell";

@interface ViewController () <ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>

@property (nonatomic, assign) BOOL didUpdates;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSArray *imageNamesArray;
@property (nonatomic, strong) CHIPageControlJaloro *pageControl;
@property (nonatomic, strong) ZKCycleScrollView *colorCycleScrollView;
@property (weak, nonatomic) IBOutlet ZKCycleScrollView *imageCycleScrollView;
@property (weak, nonatomic) IBOutlet ZKCycleScrollView *textCycleScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _textArray = @[@"~这是一个强大好用的轮播图~", @"~如果你也觉得不错的话~", @"~给我点个赞吧:）~"];
    
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 1; i < 6; i++) {
        [mutArray addObject:@(i).stringValue];
    }
    _imageNamesArray = mutArray;
    
    // 1.xib方式创建纯文字轮播
    [_textCycleScrollView registerCellNib:[UINib nibWithNibName:kTextCellId bundle:nil] forCellWithReuseIdentifier:kTextCellId];
    
    // 2.xib方式创建图片轮播
    _imageCycleScrollView.itemSize = CGSizeMake(_imageCycleScrollView.bounds.size.width - 80.f, _imageCycleScrollView.bounds.size.height);
    [_imageCycleScrollView registerCellNib:[UINib nibWithNibName:kImageCellId bundle:nil] forCellWithReuseIdentifier:kImageCellId];
    // 如果需要设置默认显示页，可以像下面这样做
    __weak typeof(self) weakSelf = self;
    _imageCycleScrollView.loadCompletion = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.imageCycleScrollView scrollToItemAtIndex:3 animated:NO];
    };
    
    // 3.纯代码方式创建有限轮播
    _colorCycleScrollView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, _textCycleScrollView.frame.origin.y - 200.f, self.view.bounds.size.width, 50.f) shouldInfiniteLoop:NO]; // 这个初始化方法中第二个参数 shouldInfiniteLoop 意思是是否开启无线轮播；如果你使用其它初始化方法，例如 -initWithFrame：，默认是开启的，并且后续不能再更改
    _colorCycleScrollView.delegate = self;
    _colorCycleScrollView.dataSource = self;
    _colorCycleScrollView.hidesPageControl = YES; // 隐藏默认的 pageControl，如果有需要你可以通过 -addSubView: 的方式添加自定义的 pageControl，然后在代理方法中进行联动
    _colorCycleScrollView.autoScroll = NO; // 关闭自动滚动
    _colorCycleScrollView.itemSpacing = 10.f; // 设置 cell 间距
    _colorCycleScrollView.itemSize = CGSizeMake(_colorCycleScrollView.bounds.size.width - 50.f, _colorCycleScrollView.bounds.size.height); // 设置 cell 大小
    [_colorCycleScrollView registerCellClass:[ZKCycleScrollViewCell class] forCellWithReuseIdentifier:kColorCellId]; // 注册自定义 cell
    [self.view addSubview:_colorCycleScrollView];
    // 自定义 PageControl
    _pageControl = [[CHIPageControlJaloro alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_colorCycleScrollView.frame) + 10.f, _colorCycleScrollView.bounds.size.width, 15.f)];
    _pageControl.radius = 3.f;
    _pageControl.padding = 8.f;
    _pageControl.inactiveTransparency = 0.8; // 未命中点的不透明度
    _pageControl.tintColor = [UIColor blueColor];
    _pageControl.currentPageTintColor = [UIColor redColor];
    _pageControl.numberOfPages = 3;
    _pageControl.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.view addSubview:_pageControl];
}

- (IBAction)updateLayout:(id)sender {
    
    _didUpdates = !_didUpdates;
    
    // 如果需要更新当前布局，必须先调用 -beginUpdates
    [_imageCycleScrollView beginUpdates];
    // 在这里可以更新以下单个或多个属性值
    if (_didUpdates) {
        _imageCycleScrollView.itemSpacing = 10.f;
        _imageCycleScrollView.itemZoomScale = 1.f;
        _imageCycleScrollView.scrollDirection = ZKScrollDirectionVertical;
        _imageCycleScrollView.itemSize = CGSizeMake(_imageCycleScrollView.bounds.size.width, _imageCycleScrollView.bounds.size.height - 80.f);
    } else {
        _imageCycleScrollView.itemSpacing = -10.f;
        _imageCycleScrollView.itemZoomScale = 0.85;
        _imageCycleScrollView.scrollDirection = ZKScrollDirectionHorizontal;
        _imageCycleScrollView.itemSize = CGSizeMake(_imageCycleScrollView.bounds.size.width - 80.f, _imageCycleScrollView.bounds.size.height);
    }
    // 更改后，必须调用 -endUpdates，更新当前布局
    [_imageCycleScrollView endUpdates];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    if (cycleScrollView == _imageCycleScrollView) {
        return _imageNamesArray.count;
    } else if (cycleScrollView == _textCycleScrollView) {
        return _textArray.count;
    } else {
        return 3;
    }
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    if (cycleScrollView == _imageCycleScrollView) {
        ImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kImageCellId forIndex:index];
        cell.imageView.image = [UIImage imageNamed:_imageNamesArray[index]];
        return cell;
    } else if (cycleScrollView == _textCycleScrollView) {
        TextCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kTextCellId forIndex:index];
        cell.textLabel.text = _textArray[index];
        return cell;
    } else {
        ZKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kColorCellId forIndex:index];
        cell.contentView.backgroundColor = [UIColor randomColor];
        return cell;
    }
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (cycleScrollView == _imageCycleScrollView) {
        SubViewController *vc = [[SubViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (cycleScrollView == _colorCycleScrollView) {
        [cycleScrollView scrollToItemAtIndex:cycleScrollView.pageIndex + 1 animated:YES];
    } else {
        // TODO:
    }
}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress {
    if (cycleScrollView != _colorCycleScrollView) return;
     _pageControl.progress = progress;
    NSLog(@"progress = %f", progress);
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (cycleScrollView != _colorCycleScrollView) return;
    NSLog(@"from %zd to %zd", fromIndex, toIndex);
}

@end
