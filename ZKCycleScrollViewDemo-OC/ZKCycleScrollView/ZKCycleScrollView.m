//
//  ZKCycleScrollView.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/9.
//  Copyright © 2019 bestdew. All rights reserved.
//
//                      d*##$.
// zP"""""$e.           $"    $o
//4$       '$          $"      $
//'$        '$        J$       $F
// 'b        $k       $>       $
//  $k        $r     J$       d$
//  '$         $     $"       $~
//   '$        "$   '$E       $
//    $         $L   $"      $F ...
//     $.       4B   $      $$$*"""*b
//     '$        $.  $$     $$      $F
//      "$       R$  $F     $"      $
//       $k      ?$ u*     dF      .$
//       ^$.      $$"     z$      u$$$$e
//        #$b             $E.dW@e$"    ?$
//         #$           .o$$# d$$$$c    ?F
//          $      .d$$#" . zo$>   #$r .uF
//          $L .u$*"      $&$$$k   .$$d$$F
//           $$"            ""^"$$$P"$P9$
//          JP              .o$$$$u:$P $$
//          $          ..ue$"      ""  $"
//         d$          $F              $
//         $$     ....udE             4B
//          #$    """"` $r            @$
//           ^$L        '$            $F
//             RN        4N           $
//              *$b                  d$
//               $$k                 $F
//               $$b                $F
//                 $""               $F
//                 '$                $
//                  $L               $
//                  '$               $
//                   $               $

#import "ZKCycleScrollView.h"

static const NSInteger kNumberOfSections = 100;
static NSString * const kCellReuseId = @"ZKCycleScrollViewCell";

@interface ZKCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ZKCycleScrollView

#pragma mark -- Init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialization];
}

- (void)initialization
{
    _autoScroll = YES;
    _dragEnabled = YES;
    _showsPageControl = YES;
    _autoScrollDuration = 3.f;
    _pageControlTransform = CGAffineTransformIdentity;
    _pageIndicatorTintColor = [UIColor grayColor];
    _currentPageIndicatorTintColor = [UIColor whiteColor];
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0.f;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout.headerReferenceSize = CGSizeZero;
    _flowLayout.footerReferenceSize = CGSizeZero;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self configuration];
    }];
}

- (void)configuration
{
    [self addTimer];
    [self addPageControl];
    
    UICollectionViewScrollPosition position;
    switch (_scrollDirection) {
        case ZKScrollDirectionHorizontal:
            position = UICollectionViewScrollPositionLeft;
            break;
        case ZKScrollDirectionVertical:
            position = UICollectionViewScrollPositionTop;
            break;
    }
    NSInteger section = kNumberOfSections / 2;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section] atScrollPosition:position animated:NO];
    _collectionView.scrollEnabled = (_count > 1 && _dragEnabled);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.bounds.size;
    _collectionView.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) [self removeTimer];
}

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark -- Public Methods
- (void)registerCellClass:(nullable Class)cellClass
{
    [_collectionView registerClass:cellClass forCellWithReuseIdentifier:kCellReuseId];
}

- (void)registerCellNib:(UINib *)nib
{
    [_collectionView registerNib:nib forCellWithReuseIdentifier:kCellReuseId];
}

- (__kindof ZKCycleScrollViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath
{
    return [_collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId forIndexPath:indexPath];
}

- (void)reloadData
{
    [_collectionView reloadData];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self configuration];
    }];
}

- (void)adjustWhenViewWillAppear
{
    if (_count <= 0) return;
    
    NSIndexPath *indexPath = [self currentIndexPath];
    if (indexPath.section >= kNumberOfSections || indexPath.item >= _count) return;
    
    UICollectionViewScrollPosition position;
    switch (_scrollDirection) {
        case ZKScrollDirectionHorizontal:
            position = UICollectionViewScrollPositionLeft;
            break;
        case ZKScrollDirectionVertical:
            position = UICollectionViewScrollPositionTop;
            break;
    }
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
}

#pragma mark -- Private Methods
- (void)addTimer
{
    [self removeTimer];
    if (_count < 2 || !_autoScroll) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDuration target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll
{
    NSIndexPath *indexPath = [self currentIndexPath];
    
    UICollectionViewScrollPosition position;
    switch (_scrollDirection) {
        case ZKScrollDirectionHorizontal:
            position = UICollectionViewScrollPositionLeft;
            break;
        case ZKScrollDirectionVertical:
            position = UICollectionViewScrollPositionTop;
            break;
    }
    
    NSIndexPath *targetIndexPath;
    BOOL animated;
    if (indexPath.section < kNumberOfSections - 1) {
        if (indexPath.item < _count - 1) {
            targetIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
        } else {
            targetIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section + 1];
        }
        animated = YES;
    } else {
        if (indexPath.item < _count - 1) {
            targetIndexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            animated = YES;
        } else {
            targetIndexPath = [NSIndexPath indexPathForItem:0 inSection:kNumberOfSections / 2];
            animated = NO;
        }
    }
    [_collectionView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:position animated:animated];
}

- (NSIndexPath *)currentIndexPath
{
    if (self.bounds.size.width <= 0.f || self.bounds.size.height <= 0.f) {
        return [NSIndexPath indexPathForItem:0 inSection:0];
    }
    NSInteger index = 0;
    switch (_scrollDirection) {
        case ZKScrollDirectionHorizontal:
            index = (_collectionView.contentOffset.x + _flowLayout.itemSize.width / 2) / _flowLayout.itemSize.width;
            break;
        case ZKScrollDirectionVertical:
            index = (_collectionView.contentOffset.y + _flowLayout.itemSize.height / 2) / _flowLayout.itemSize.height;
            break;
    }
    index = MAX(0, index);
    NSInteger section = index / _count;
    NSInteger item = index % _count;
    return [NSIndexPath indexPathForItem:item inSection:section];
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)addPageControl
{
    [_pageControl removeFromSuperview];
    [_customPageControl removeFromSuperview];
    
    if (_customPageControl) {
        _customPageControl.frame = [self pageControlFrame];
        _customPageControl.hidden = !_showsPageControl;
        _customPageControl.transform = _pageControlTransform;
        [self addSubview:_customPageControl];
    } else {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = [self pageControlFrame];
        _pageControl.numberOfPages = _count;
        _pageControl.hidden = !_showsPageControl;
        _pageControl.transform = _pageControlTransform;
        _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
        [self addSubview:_pageControl];
    }
}

- (CGRect)pageControlFrame
{
    CGFloat height = 15.f;
    CGFloat width = _count * 15.f;
    CGFloat x = (self.bounds.size.width - width) / 2;
    CGFloat y = self.bounds.size.height - height;
    return CGRectMake(x, y, width, height);
}

#pragma mark -- UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(cycleScrollView:numberOfItemsInSection:)]) {
        _count = [_dataSource cycleScrollView:self numberOfItemsInSection:section];
    }
    return _count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource cycleScrollView:self cellForItemAtIndexPath:indexPath];
}

#pragma mark -- UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndexPath:)]) {
        [_delegate cycleScrollView:self didSelectItemAtIndexPath:indexPath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(cycleScrollViewDidScroll:)]) {
        [_delegate cycleScrollViewDidScroll:self];
    }
    
    if (_count <= 0) return;
    NSIndexPath *indexPath = [self currentIndexPath];
    _pageControl.currentPage = indexPath.item;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_autoScroll) [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_autoScroll) [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView.delegate scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_count <= 0) return;
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndexPath:)]) {
        [_delegate cycleScrollView:self didScrollToIndexPath:[self currentIndexPath]];
    }
}

#pragma mark -- Setter & Getter
- (void)setScrollDirection:(ZKScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    switch (scrollDirection) {
        case ZKScrollDirectionHorizontal:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            break;
        case ZKScrollDirectionVertical:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            break;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    autoScroll ? [self addTimer] : [self removeTimer];
}

- (void)setDragEnabled:(BOOL)dragEnabled
{
    _dragEnabled = dragEnabled;
    _collectionView.scrollEnabled = dragEnabled;
}

- (void)setShowsPageControl:(BOOL)showsPageControl
{
    _showsPageControl = showsPageControl;
    _pageControl.hidden = !showsPageControl;
    _customPageControl.hidden = !showsPageControl;
}

- (void)setAutoScrollDuration:(CGFloat)autoScrollDuration
{
    _autoScrollDuration = autoScrollDuration;
    if (_autoScroll) [self addTimer];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageControlTransform:(CGAffineTransform)pageControlTransform
{
    _pageControlTransform = pageControlTransform;
    _pageControl.transform = pageControlTransform;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _collectionView.backgroundColor = backgroundColor;
}

- (CGPoint)contentOffset
{
    return _collectionView.contentOffset;
}

@end
