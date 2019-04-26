//
//  ViewController.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/9.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "ViewController.h"
#import "ZKCycleScrollView.h"
#import "LocalImageCell.h"
#import "RemoteImageCell.h"
#import "TextCell.h"
#import <CHIPageControl/CHIPageControl-Swift.h>

#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define FIT_WIDTH(w) w * SCREEN_WIDTH / 375.f

static NSString *kLocalCellId = @"LocalImageCell";
static NSString *kRemoteCellId = @"RemoteImageCell";
static NSString *kTextCellId = @"TextCell";

@interface ViewController () <ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>

@property (nonatomic, strong) NSArray *localPathGroup;
@property (nonatomic, strong) NSArray *remotePathGroup;
@property (nonatomic, strong) NSArray *textGroup;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ZKCycleScrollView *cycleScrollView1;
@property (nonatomic, strong) ZKCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) ZKCycleScrollView *cycleScrollView3;
@property (nonatomic, strong) ZKCycleScrollView *cycleScrollView4;
@property (nonatomic, strong) ZKCycleScrollView *cycleScrollView5;

@property (nonatomic, strong) CHIPageControlJaloro *pageControlJaloro;
@property (nonatomic, strong) CHIPageControlPuya *pageControlPuya;
@property (nonatomic, strong) CHIPageControlChimayo *pageControlChimayo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:12];
    for (NSInteger i = 1; i < 13; i++) {
        [mutArray addObject:@(i).stringValue];
    }
    _localPathGroup = mutArray;
    
    _remotePathGroup = @[@"http://static1.pezy.cn/img/2019-02-01/5932241902444072231.jpg", @"http://static1.pezy.cn/img/2019-03-01/1206059142424414231.jpg"];
    
    _textGroup = @[@"~如果有一天~", @"~我回到从前~", @"~我会带着笑脸~", @"~和你说再见~"];
    
    [self.view addSubview:({
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 750.f);
        _scrollView;
    })];
    
    [self addCycleScrollView1];
    [self addCycleScrollView2];
    [self addCycleScrollView3];
    [self addCycleScrollView4];
    [self addCycleScrollView5];
}

// 默认就是这种效果
- (void)addCycleScrollView1
{
    [_scrollView addSubview:({
        _cycleScrollView1 = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, FIT_WIDTH(65.f))];
        _cycleScrollView1.delegate = self;
        _cycleScrollView1.dataSource = self;
        [_cycleScrollView1 registerCellClass:[RemoteImageCell class] forCellWithReuseIdentifier:kRemoteCellId];
        _cycleScrollView1;
    })];
}

/**
 如果内置的 pageControl 不能满足需求，你可以隐藏默认的 pageControl，然后通过 -addSubview: 的方式添加你自定义的 pageControl，并在相应的代理方法中将 pageControl 进行联动，这种方式应该更显灵活些。。。
 推荐一个很好很强大的自定义的 PageControl 轮子：https://github.com/ChiliLabs/CHIPageControl
 本 Demo 中用的就是这个，但遗憾的是貌似目前只有 Swift 版本。。。
 */

// 实现这种效果的关键是：itemSize.width = cycleScrollView.bounds.size.width - itemSpacing * 2
- (void)addCycleScrollView2
{
    [_scrollView addSubview:({
        _cycleScrollView2 = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_cycleScrollView1.frame) + 20.f, SCREEN_WIDTH, FIT_WIDTH(150.f))];
        _cycleScrollView2.delegate = self;
        _cycleScrollView2.dataSource = self;
        _cycleScrollView2.hidesPageControl = YES;
        _cycleScrollView2.itemSpacing = 12.f;
        _cycleScrollView2.itemSize = CGSizeMake(SCREEN_WIDTH - 24.f, _cycleScrollView2.bounds.size.height);
        [_cycleScrollView2 registerCellNib:[UINib nibWithNibName:@"LocalImageCell" bundle:nil] forCellWithReuseIdentifier:kLocalCellId];
        _cycleScrollView2;
    })];
    
    [_cycleScrollView2 addSubview:({
        _pageControlJaloro = [[CHIPageControlJaloro alloc] initWithFrame:CGRectMake(0.f, _cycleScrollView2.bounds.size.height - 15.f, _cycleScrollView2.bounds.size.width, 15.f)];
        _pageControlJaloro.radius = 3.f;
        _pageControlJaloro.padding = 8.f;
        _pageControlJaloro.inactiveTransparency = 0.8; // 未命中点的不透明度
        _pageControlJaloro.tintColor = [UIColor purpleColor];
        _pageControlJaloro.currentPageTintColor = [UIColor blueColor];
        _pageControlJaloro.numberOfPages = _localPathGroup.count;
        _pageControlJaloro.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _pageControlJaloro;
    })];
}

// 前后两个 cell 暴露出来的部分之和 + itemSpacing * 2 = cycleScrollView.bounds.size.width
- (void)addCycleScrollView3
{
    [_scrollView addSubview:({
        _cycleScrollView3 = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_cycleScrollView2.frame) + 20.f, SCREEN_WIDTH, FIT_WIDTH(150.f))];
        _cycleScrollView3.delegate = self;
        _cycleScrollView3.dataSource = self;
        _cycleScrollView3.hidesPageControl = YES;
        _cycleScrollView3.itemSpacing = 12.f;
        _cycleScrollView3.itemSize = CGSizeMake(SCREEN_WIDTH - 50.f, _cycleScrollView3.bounds.size.height);
        [_cycleScrollView3 registerCellNib:[UINib nibWithNibName:@"LocalImageCell" bundle:nil] forCellWithReuseIdentifier:kLocalCellId];
        _cycleScrollView3;
    })];
    
    [_cycleScrollView3 addSubview:({
        _pageControlPuya = [[CHIPageControlPuya alloc] initWithFrame:CGRectMake(0.f, _cycleScrollView3.bounds.size.height - 15.f, _cycleScrollView3.bounds.size.width, 15.f)];
        _pageControlPuya.padding = 8.f;
        _pageControlPuya.inactiveTransparency = 0.8; // 未命中点的不透明度
        _pageControlPuya.tintColor = [UIColor purpleColor];
        _pageControlPuya.currentPageTintColor = [UIColor blueColor];
        _pageControlPuya.numberOfPages = _localPathGroup.count;
        _pageControlPuya.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _pageControlPuya;
    })];
}

// 实现这种效果的关键是：itemZoomScale，范围是：0.f ~ 1.f，默认是 1.f，没有缩放效果
- (void)addCycleScrollView4
{
    [_scrollView addSubview:({
        _cycleScrollView4 = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_cycleScrollView3.frame) + 20.f, SCREEN_WIDTH, FIT_WIDTH(150.f))];
        _cycleScrollView4.delegate = self;
        _cycleScrollView4.dataSource = self;
        _cycleScrollView4.hidesPageControl = YES;
        _cycleScrollView4.itemSpacing = -10.f;
        _cycleScrollView4.itemZoomScale = 0.85;
        _cycleScrollView4.itemSize = CGSizeMake(SCREEN_WIDTH - 80.f, _cycleScrollView4.bounds.size.height);
        [_cycleScrollView4 registerCellNib:[UINib nibWithNibName:@"LocalImageCell" bundle:nil] forCellWithReuseIdentifier:kLocalCellId];
        _cycleScrollView4;
    })];
    
    [_cycleScrollView4 addSubview:({
        _pageControlChimayo = [[CHIPageControlChimayo alloc] initWithFrame:CGRectMake(0.f, _cycleScrollView4.bounds.size.height - 15.f, _cycleScrollView4.bounds.size.width, 15.f)];
        _pageControlChimayo.padding = 8.f;
        _pageControlChimayo.tintColor = [UIColor blueColor];
        _pageControlChimayo.numberOfPages = _localPathGroup.count;
        _pageControlChimayo.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _pageControlChimayo;
    })];
}

// 纯文本轮播...
- (void)addCycleScrollView5
{
    [_scrollView addSubview:({
        _cycleScrollView5 = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(_cycleScrollView4.frame) + 20.f, SCREEN_WIDTH, 30.f)];
        _cycleScrollView5.delegate = self;
        _cycleScrollView5.dataSource = self;
        _cycleScrollView5.allowsDragging = NO;
        _cycleScrollView5.hidesPageControl = YES;
        _cycleScrollView5.scrollDirection = ZKScrollDirectionVertical;
        [_cycleScrollView5 registerCellNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellWithReuseIdentifier:kTextCellId];
        _cycleScrollView5;
    })];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 这里最好调用一下这个方法，防止界面跳转时，轮播图卡在一半。。。
    [_cycleScrollView1 adjustWhenViewWillAppear];
    [_cycleScrollView2 adjustWhenViewWillAppear];
    [_cycleScrollView3 adjustWhenViewWillAppear];
    [_cycleScrollView4 adjustWhenViewWillAppear];
    [_cycleScrollView5 adjustWhenViewWillAppear];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView
{
    if (cycleScrollView == _cycleScrollView1) {
        return _remotePathGroup.count;
    } else if (cycleScrollView == _cycleScrollView5) {
        return _textGroup.count;
    } else {
        return _localPathGroup.count;
    }
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == _cycleScrollView1) {
        RemoteImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kRemoteCellId forIndex:index];
        cell.imageURL = [NSURL URLWithString:_remotePathGroup[index]];
        return cell;
    } else if (cycleScrollView == _cycleScrollView5) {
        TextCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kTextCellId forIndex:index];
        cell.textLabel.text = _textGroup[index];
        return cell;
    } else {
        LocalImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kLocalCellId forIndex:index];
        cell.imageView.image = [UIImage imageNamed:_localPathGroup[index]];
        return cell;
    }
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"selected index: %zd", index);
}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress
{
    if (cycleScrollView == _cycleScrollView1) {
        NSLog(@"content offset-x: %f", cycleScrollView.contentOffset.x);
    } else if (cycleScrollView == _cycleScrollView2) {
        _pageControlJaloro.progress = progress;
    } else if (cycleScrollView == _cycleScrollView3) {
        _pageControlPuya.progress = progress;
    } else if (cycleScrollView == _cycleScrollView4) {
        _pageControlChimayo.progress = progress;
    }
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (cycleScrollView != _cycleScrollView2) return;
    NSLog(@"from %zd to %zd", fromIndex, toIndex);
}

@end
