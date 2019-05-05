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
#import "ZKCycleScrollViewFlowLayout.h"

@interface ZKCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) ZKCycleScrollViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger fromIndex;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) BOOL itemSizeFlag;
@property (nonatomic, assign) NSInteger indexOffset;

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    _autoScroll = YES;
    _itemZoomScale = 1.f;
    _allowsDragging = YES;
    _autoScrollInterval = 3.f;
    _pageIndicatorTintColor = [UIColor grayColor];
    _currentPageIndicatorTintColor = [UIColor whiteColor];
    
    _flowLayout = [[ZKCycleScrollViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0.f;
    _flowLayout.minimumInteritemSpacing = 0.f;
    _flowLayout.headerReferenceSize = CGSizeZero;
    _flowLayout.footerReferenceSize = CGSizeZero;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = nil;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.enabled = NO;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    [self addSubview:_pageControl];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configuration];
        if (_loadCompletion) _loadCompletion();
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = _itemSizeFlag ? _itemSize : self.bounds.size;
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
        [_collectionView reloadData];
    }];
    [_collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        [self configuration];
        if (_loadCompletion) _loadCompletion();
    }];
}

- (void)adjustWhenViewWillAppear
{
    if (_numberOfItems < 2) return;
    
    NSInteger index = [self currentIndex];
    UICollectionViewScrollPosition position = [self scrollPosition];
    if (index == 1) {
        index = _numberOfItems - 3;
    } else if (index == _numberOfItems - 2) {
        index = 2;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
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
            index = _numberOfItems - 6;
        } else if (index == 1) {
            index = _numberOfItems - 5;
        } else if (index == _numberOfItems - 2) {
            index = 0;
        } else if (index == _numberOfItems - 1) {
            index = 1;
        } else {
            index -= 2;
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
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
    _pageControl.numberOfPages = MAX(0, _numberOfItems - 4);
    _pageControl.hidden = (_hidesPageControl || _pageControl.numberOfPages < 2);
}

#pragma mark -- UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInCycleScrollView:)]) {
        _numberOfItems = [_dataSource numberOfItemsInCycleScrollView:self];
        if (_numberOfItems > 1) _numberOfItems += 4;
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
            total = (_numberOfItems - 5) * (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing);
            offset = fmod([self contentOffset].y, (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing) * (_numberOfItems - 4));
            break;
        default:
            total = (_numberOfItems - 5) * (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing);
            offset = fmod([self contentOffset].x, (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing) * (_numberOfItems - 4));
            break;
    }
    CGFloat percent = offset / total;
    CGFloat progress = percent * (_numberOfItems - 5);
    
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = [self currentIndex];
    if (index == 1) {
        UICollectionViewScrollPosition position = [self scrollPosition];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_numberOfItems - 3 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    } else if (index == _numberOfItems - 2) {
        UICollectionViewScrollPosition position = [self scrollPosition];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    }
    NSInteger toIndex = [self changeIndex:index];
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didScrollFromIndex:toIndex:)]) {
        [_delegate cycleScrollView:self didScrollFromIndex:_fromIndex toIndex:toIndex];
    }
    _fromIndex = toIndex;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self pageIndex] != _fromIndex) return;
    
    CGFloat sum = velocity.x + velocity.y;
    if (sum > 0) {
        _indexOffset = 1;
    } else if (sum < 0) {
        _indexOffset = -1;
    } else {
        _indexOffset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [self currentIndex] + _indexOffset;
    UICollectionViewScrollPosition position = [self scrollPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:YES];
    _indexOffset = 0;
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
            index = (_collectionView.contentOffset.y + (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing) / 2) / (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing);
            break;
        default:
            index = (_collectionView.contentOffset.x + (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing) / 2) / (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing);
            break;
    }
    return MIN(_numberOfItems - 1, MAX(0, index));
}

- (NSInteger)pageIndex
{
    return [self changeIndex:[self currentIndex]];
}

- (CGPoint)contentOffset
{
    switch (_scrollDirection) {
        case ZKScrollDirectionVertical:
            return CGPointMake(0.f, MAX(0.f, _collectionView.contentOffset.y - (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing) * 2));
        default:
            return CGPointMake(MAX(0.f, (_collectionView.contentOffset.x - (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing) * 2)), 0.f);
    }
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

- (void)setAllowsDragging:(BOOL)allowsDragging
{
    _allowsDragging = allowsDragging;
    _collectionView.scrollEnabled = allowsDragging;
}

- (void)setAutoScrollInterval:(CGFloat)autoScrollInterval
{
    _autoScrollInterval = autoScrollInterval;
    [self addTimer];
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSizeFlag = YES;
    _itemSize = itemSize;
    _flowLayout.itemSize = itemSize;
    _flowLayout.headerReferenceSize = CGSizeMake((self.bounds.size.width - itemSize.width) / 2, (self.bounds.size.height - itemSize.height) / 2);
    _flowLayout.footerReferenceSize = CGSizeMake((self.bounds.size.width - itemSize.width) / 2, (self.bounds.size.height - itemSize.height) / 2);
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
    _itemSpacing = itemSpacing;
    _flowLayout.minimumLineSpacing = itemSpacing;
}

- (void)setItemZoomScale:(CGFloat)itemZoomScale
{
    _itemZoomScale = itemZoomScale;
    _flowLayout.zoomScale = itemZoomScale;
}

- (void)setHidesPageControl:(BOOL)hidesPageControl
{
    _hidesPageControl = hidesPageControl;
    _pageControl.hidden = hidesPageControl;
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

@end
