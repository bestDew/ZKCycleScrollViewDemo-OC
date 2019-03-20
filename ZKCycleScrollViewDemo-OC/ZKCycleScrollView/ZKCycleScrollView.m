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

@interface ZKCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger fromIndex;

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
    _scrollEnabled = YES;
    _autoScrollInterval = 3.f;
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0.f;
    _flowLayout.minimumInteritemSpacing = 0.f;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configuration];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.bounds.size;
    _collectionView.frame = self.bounds;
    _pageControl.frame = CGRectMake(0.f, self.bounds.size.height - 15.f, self.bounds.size.width, 15.f);
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
- (void)registerCellClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [_collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerCellNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [_collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (__kindof ZKCycleScrollViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index
{
    index = [self changeIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData
{
    [self removeTimer];
    [UIView performWithoutAnimation:^{
        [_collectionView performBatchUpdates:^{
            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } completion:^(BOOL finished) {
            [self configuration];
        }];
    }];
}

- (void)adjustWhenViewWillAppear
{
    if (_numberOfItems < 2) return;
    
    NSInteger index = [self currentIndex];
    UICollectionViewScrollPosition position = [self scrollPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    
    if (index == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_numberOfItems - 2 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    } else if (index == _numberOfItems - 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    }
}

#pragma mark -- Private Methods
- (UICollectionViewScrollPosition)scrollPosition
{
    switch (_scrollDirection) {
        case ZKScrollDirectionVertical:
            return UICollectionViewScrollPositionCenteredVertically;
        default:
            return UICollectionViewScrollPositionCenteredHorizontally;
    }
}

- (NSInteger)changeIndex:(NSInteger)index
{
    if (_numberOfItems > 1) {
        if (index == 0) {
            index = _numberOfItems - 3;
        } else if (index == _numberOfItems - 1) {
            index = 0;
        } else {
            index -= 1;
        }
    }
    return index;
}

- (void)configuration
{
    [self addTimer];
    [self updatePageControl];
    if (_numberOfItems < 2) return;
    
    UICollectionViewScrollPosition position = [self scrollPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
}

- (void)addTimer
{
    [self removeTimer];
    
    if (_numberOfItems < 2 || !_autoScroll || _autoScrollInterval <= 0.f) return;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll
{
    NSInteger index = [self currentIndex] + 1;
    UICollectionViewScrollPosition position = [self scrollPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:YES];
}

- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)updatePageControl
{
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = MAX(0, _numberOfItems - 2);
}

#pragma mark -- UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInCycleScrollView:)]) {
        _numberOfItems = [_dataSource numberOfItemsInCycleScrollView:self];
        if (_numberOfItems > 1) _numberOfItems += 2;
    }
    return _numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self changeIndex:indexPath.item];
    return [_dataSource cycleScrollView:self cellForItemAtIndex:index];
}

#pragma mark -- UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        NSInteger index = [self changeIndex:indexPath.item];
        [_delegate cycleScrollView:self didSelectItemAtIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = [self pageIndex];
    
    CGFloat total = 0.f, offset = 0.f;
    switch (_scrollDirection) {
        case ZKScrollDirectionVertical:
            total = (_numberOfItems - 3) * self.bounds.size.height;
            offset = fmod([self contentOffset].y, self.bounds.size.height * (_numberOfItems - 2));
            break;
        default:
            total = (_numberOfItems - 3) * self.bounds.size.width;
            offset = fmod([self contentOffset].x, self.bounds.size.width * (_numberOfItems - 2));
            break;
    }
    CGFloat percent = offset / total;
    CGFloat progress = percent * (_numberOfItems - 3);
    
    if ([_delegate respondsToSelector:@selector(cycleScrollViewDidScroll:progress:)]) {
        [_delegate cycleScrollViewDidScroll:self progress:progress];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView.delegate scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = [self currentIndex];
    if (index == 0) {
        UICollectionViewScrollPosition position = [self scrollPosition];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_numberOfItems - 2 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    } else if (index == _numberOfItems - 1) {
        UICollectionViewScrollPosition position = [self scrollPosition];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    }
    NSInteger toIndex = [self changeIndex:index];
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didScrollFromIndex:toIndex:)]) {
        [_delegate cycleScrollView:self didScrollFromIndex:_fromIndex toIndex:toIndex];
    }
    _fromIndex = toIndex;
}

#pragma mark -- Getter & Setter
- (NSInteger)currentIndex
{
    if (_numberOfItems <= 0 ||
        self.bounds.size.width <= 0.f ||
        self.bounds.size.height <= 0.f) {
        return 0;
    }
    
    NSInteger index = 0;
    switch (_scrollDirection) {
        case ZKScrollDirectionVertical:
            index = (_collectionView.contentOffset.y + _flowLayout.itemSize.height / 2) / _flowLayout.itemSize.height;
            break;
        default:
            index = (_collectionView.contentOffset.x + _flowLayout.itemSize.width / 2) / _flowLayout.itemSize.width;
            break;
    }
    return MAX(0, index);
}

- (NSInteger)pageIndex
{
    return [self changeIndex:[self currentIndex]];
}

- (CGPoint)contentOffset
{
    switch (_scrollDirection) {
        case ZKScrollDirectionVertical:
            return CGPointMake(0.f, MAX(0.f, _collectionView.contentOffset.y - _collectionView.bounds.size.height));
        default:
            return CGPointMake(MAX(0.f, (_collectionView.contentOffset.x - _collectionView.bounds.size.width)), 0.f);
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _collectionView.backgroundColor = backgroundColor;
}

- (void)setScrollDirection:(ZKScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    switch (scrollDirection) {
        case ZKScrollDirectionVertical:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            break;
        default:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            break;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    [self addTimer];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    _collectionView.scrollEnabled = scrollEnabled;
}

- (void)setAutoScrollInterval:(CGFloat)autoScrollInterval
{
    _autoScrollInterval = autoScrollInterval;
    [self addTimer];
}

@end
