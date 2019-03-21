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
@property (weak, nonatomic) IBOutlet ZKCycleScrollView *localBannerView;
@property (weak, nonatomic) IBOutlet ZKCycleScrollView *remoteBannerView;
@property (weak, nonatomic) IBOutlet ZKCycleScrollView *textBannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 本地图片轮播
    [self setupLocalBannerView];
    
    // 网络图片轮播
    [self setupRemoteBannerView];
    
    // 纯文字轮播
    [self setupTextBannerView];
}

- (void)setupLocalBannerView
{
    _localPathGroup = [NSMutableArray arrayWithCapacity:12];
    for (NSInteger i = 1; i < 13; i++) {
        [_localPathGroup addObject:@(i).stringValue];
    }
    [_localBannerView registerCellNib:[UINib nibWithNibName:@"LocalImageCell" bundle:nil] forCellWithReuseIdentifier:kLocalCellId];
}

- (void)setupRemoteBannerView
{
    _remotePathGroup = [NSMutableArray arrayWithObjects:@"http://static1.pezy.cn/img/2019-02-01/5932241902444072231.jpg", @"http://static1.pezy.cn/img/2019-03-01/1206059142424414231.jpg", nil];
    [_remoteBannerView registerCellClass:[RemoteImageCell class] forCellWithReuseIdentifier:kRemoteCellId];
}

- (void)setupTextBannerView
{
    _textPathGroup = [NSMutableArray arrayWithObjects:@"~如果有一天~", @"~我回到从前~", @"~我会带着笑脸~", @"~和你说再见~", nil];
    [_textBannerView registerCellNib:[UINib nibWithNibName:@"TextCell" bundle:nil] forCellWithReuseIdentifier:kTextCellId];
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
