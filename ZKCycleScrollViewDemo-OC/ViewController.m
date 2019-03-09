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
    _localPathGroup = [NSMutableArray arrayWithCapacity:6];
    for (NSInteger i = 1; i < 7; i++) {
        [_localPathGroup addObject:[@"ad_" stringByAppendingString:@(i).stringValue]];
    }
    
    _localBannerView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 100.f, SCREEN_WIDTH, FIT_WIDTH(188.f))];
    _localBannerView.delegate = self;
    _localBannerView.dataSource = self;
    _localBannerView.backgroundColor = [UIColor whiteColor];
    _localBannerView.pageIndicatorTintColor = [UIColor blueColor];
    _localBannerView.currentPageIndicatorTintColor = [UIColor redColor];
    [_localBannerView registerCellClass:[LocalImageCell class]];
    [self.view addSubview:_localBannerView];
    
    
    // 网路图片轮播
    _remotePathGroup = [NSMutableArray arrayWithObjects:@"http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg", @"http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg", @"http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png", nil];
    
    _remoteBannerView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 350.f, SCREEN_WIDTH, FIT_WIDTH(80.f))];
    _remoteBannerView.delegate = self;
    _remoteBannerView.dataSource = self;
    _remoteBannerView.autoScrollDuration = 5.f;
    _remoteBannerView.backgroundColor = [UIColor whiteColor];
    [_remoteBannerView registerCellClass:[RemoteImageCell class]];
    [self.view addSubview:_remoteBannerView];
    
    
    // 纯文字轮播
    _textPathGroup = [NSMutableArray arrayWithObjects:@"~如果有一天~", @"~我回到从前~", @"~我会带着笑脸~", @"~和你说再见~", nil];
    
    _textBannerView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0.f, 480.f, SCREEN_WIDTH, 30.f)];
    _textBannerView.delegate = self;
    _textBannerView.dataSource = self;
    _textBannerView.dragEnabled = NO;
    _textBannerView.showsPageControl = NO;
    _textBannerView.scrollDirection = ZKScrollDirectionVertical;
    _textBannerView.backgroundColor = [UIColor whiteColor];
    [_textBannerView registerCellClass:[TextCell class]];
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
- (NSInteger)cycleScrollView:(ZKCycleScrollView *)cycleScrollView numberOfItemsInSection:(NSInteger)section
{
    if (cycleScrollView == _localBannerView) {
        return _localPathGroup.count;
    } else if (cycleScrollView == _remoteBannerView) {
        return _remotePathGroup.count;
    } else {
        return _textPathGroup.count;
    }
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (cycleScrollView == _localBannerView) {
        LocalImageCell *cell = [cycleScrollView dequeueReusableCellForIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:_localPathGroup[indexPath.item]];
        return cell;
    } else if (cycleScrollView == _remoteBannerView) {
        RemoteImageCell *cell = [cycleScrollView dequeueReusableCellForIndexPath:indexPath];
        cell.imageURL = [NSURL URLWithString:_remotePathGroup[indexPath.item]];
        return cell;
    } else {
        TextCell *cell = [cycleScrollView dequeueReusableCellForIndexPath:indexPath];
        cell.textLabel.text = _textPathGroup[indexPath.item];
        return cell;
    }
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了：%zd", indexPath.item);
}

@end
