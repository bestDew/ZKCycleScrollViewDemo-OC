//
//  ZKCycleScrollView.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZKCycleScrollView;

@compatibility_alias ZKCycleScrollViewCell UICollectionViewCell;

typedef NS_ENUM(NSInteger, ZKScrollDirection) {
    ZKScrollDirectionHorizontal = 0,
    ZKScrollDirectionVertical
};

@protocol ZKCycleScrollViewDataSource <NSObject>

// Return number of pages
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView;
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndex:
- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index;

@end

@protocol ZKCycleScrollViewDelegate <NSObject>

@optional
// Called when the cell is clicked
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
// Called when the offset changes. The progress range is from 0 to the maximum index value, which means the progress value for a round of scrolling
- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress;
// Called when scrolling to a new index page
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

IB_DESIGNABLE
@interface  ZKCycleScrollView : UIView

@property (nullable, nonatomic, weak) IBOutlet id<ZKCycleScrollViewDelegate> delegate;
@property (nullable, nonatomic, weak) IBOutlet id<ZKCycleScrollViewDataSource> dataSource;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger scrollDirection;
@property (nonatomic, assign) IBInspectable double autoScrollInterval; 
#else
@property (nonatomic, assign) ZKScrollDirection scrollDirection; // default horizontal. scroll direction
@property (nonatomic, assign) NSTimeInterval autoScrollInterval; // default 3.f. automatic scroll time interval
#endif

@property (nonatomic, assign) IBInspectable BOOL autoScroll; // default YES
@property (nonatomic, assign) IBInspectable BOOL allowsDragging; // default YES. turn off any dragging temporarily

@property (nonatomic, assign) IBInspectable CGSize  itemSize; // default the view size
@property (nonatomic, assign) IBInspectable CGFloat itemSpacing; // default 0.f
@property (nonatomic, assign) IBInspectable CGFloat itemZoomScale; // default 1.f(no scaling), it ranges from 0.f to 1.f

@property (nonatomic, assign) IBInspectable BOOL hidesPageControl; // default NO
@property (nullable, nonatomic, strong) IBInspectable UIColor *pageIndicatorTintColor; // default gray
@property (nullable, nonatomic, strong) IBInspectable UIColor *currentPageIndicatorTintColor; // default white

@property (nonatomic, readonly, assign) NSInteger pageIndex; // current page index
@property (nonatomic, readonly, assign) CGPoint contentOffset;  // current content offset

@property (nullable, nonatomic, copy) dispatch_block_t loadCompletion; // load completed callback

- (void)registerCellClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerCellNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof ZKCycleScrollViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)reloadData;
// If the cell gets stuck in half the time when you push or present a new view controller, you can call this method in the -viewWillAppear: method of the view controller where the cyclescrollView is located.
- (void)adjustWhenViewWillAppear;

@end

NS_ASSUME_NONNULL_END
