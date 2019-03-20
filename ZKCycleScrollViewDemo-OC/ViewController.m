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

#define SCREEN_WIDTH UIScreen.mainScreen.bounds.size.width
#define FIT_WIDTH(w) w * SCREEN_WIDTH / 375.f

static NSString *kLocalCellId = @"LocalImageCell";
static NSString *kRemoteCellId = @"RemoteImageCell";
static NSString *kTextCellId = @"TextCell";

@interface ViewController () <ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>

@property (nonatomic, strong) NSMutableArray *localPathGroup;
@property (nonatomic, strong) NSMutableArray *remotePathGroup;
@property (nonatomic, strong) NSMutableArray *textPathGroup;
@property (nonatomic, strong) ZKCycleScrollView *localBannerView;
@property (nonatomic, strong) ZKCycleScrollView *remoteBannerView;
@property (nonatomic, strong) ZKCycleScrollView *textBannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 本地图片轮播
    [self addLocalBannerView];
    
    // 网络图片轮播
    [self addRemoteBannerView];
    
    // 纯文字轮播
    [self addTextBannerView];
}

- (void)addLocalBannerView
{
    _localPathGroup = [NSMutableArray arrayWithCapacity:12];
    for (NSInteger i = 1; i < 13; i++) {
        [_localPathGroup addObject:@(i).stringValue];
    }
    
    _localBannerView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 100.f, SCREEN_WIDTH, FIT_WIDTH(200.f))];
    _localBannerView.delegate = self;
    _localBannerView.dataSource = self;
    _localBannerView.backgroundColor = [UIColor whiteColor];
    _localBannerView.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    _localBannerView.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [_localBannerView registerCellClass:[LocalImageCell class] forCellWithReuseIdentifier:kLocalCellId];
    [self.view addSubview:_localBannerView];
}

- (void)addRemoteBannerView
{
    _remotePathGroup = [NSMutableArray arrayWithObjects:@"http://static1.pezy.cn/img/2019-02-01/5932241902444072231.jpg", @"http://static1.pezy.cn/img/2019-03-01/1206059142424414231.jpg", nil];
    
    _remoteBannerView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 350.f, SCREEN_WIDTH, FIT_WIDTH(65.f))];
    _remoteBannerView.delegate = self;
    _remoteBannerView.dataSource = self;
    _remoteBannerView.autoScrollInterval = 4.f;
    _remoteBannerView.backgroundColor = [UIColor whiteColor];
    [_remoteBannerView registerCellClass:[RemoteImageCell class] forCellWithReuseIdentifier:kRemoteCellId];
    [self.view addSubview:_remoteBannerView];
}

- (void)addTextBannerView
{
    _textPathGroup = [NSMutableArray arrayWithObjects:@"~如果有一天~", @"~我回到从前~", @"~我会带着笑脸~", @"~和你说再见~", nil];
    
    _textBannerView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 480.f, SCREEN_WIDTH, 30.f)];
    _textBannerView.delegate = self;
    _textBannerView.dataSource = self;
    _textBannerView.scrollEnabled = NO;
    _textBannerView.pageControl.hidden = YES;
    _textBannerView.scrollDirection = ZKScrollDirectionVertical;
    _textBannerView.backgroundColor = [UIColor whiteColor];
    [_textBannerView registerCellClass:[TextCell class] forCellWithReuseIdentifier:kTextCellId];
    [self.view addSubview:_textBannerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_localBannerView adjustWhenViewWillAppear];
    [_remoteBannerView adjustWhenViewWillAppear];
    [_textBannerView adjustWhenViewWillAppear];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView
{
    if (cycleScrollView == _localBannerView) {
        return _localPathGroup.count;
    } else if (cycleScrollView == _remoteBannerView) {
        return _remotePathGroup.count;
    } else {
        return _textPathGroup.count;
    }
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == _localBannerView) {
        LocalImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kLocalCellId forIndex:index];
        cell.imageView.image = [UIImage imageNamed:_localPathGroup[index]];
        return cell;
    } else if (cycleScrollView == _remoteBannerView) {
        RemoteImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kRemoteCellId forIndex:index];
        cell.imageURL = [NSURL URLWithString:_remotePathGroup[index]];
        return cell;
    } else {
        TextCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kTextCellId forIndex:index];
        cell.textLabel.text = _textPathGroup[index];
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
    if (cycleScrollView != _localBannerView) return;
    NSLog(@"progress: %f", progress);
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (cycleScrollView != _localBannerView) return;
    NSLog(@"from %zd to %zd", fromIndex, toIndex);
}

@end
