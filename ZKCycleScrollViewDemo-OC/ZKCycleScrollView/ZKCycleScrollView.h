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

@class ZKCycleScrollView;

NS_ASSUME_NONNULL_BEGIN

@compatibility_alias ZKCycleScrollViewCell UICollectionViewCell;

typedef NS_ENUM(NSInteger, ZKScrollDirection) {
    ZKScrollDirectionHorizontal  = 0,
    ZKScrollDirectionVertical
};

@protocol ZKCycleScrollViewDataSource <NSObject>

- (NSInteger)cycleScrollView:(ZKCycleScrollView *)cycleScrollView numberOfItemsInSection:(NSInteger)section;
- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ZKCycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView;
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollToIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZKCycleScrollView : UIView

@property (nullable, nonatomic, weak) id<ZKCycleScrollViewDelegate> delegate;
@property (nullable, nonatomic, weak) id<ZKCycleScrollViewDataSource> dataSource;

@property (nonatomic, assign) ZKScrollDirection scrollDirection; // default horizontal
@property (nonatomic, assign, getter=isAutoScroll) BOOL autoScroll; // default YES
@property (nonatomic, assign, getter=isDragEnabled) BOOL dragEnabled; // default YES
@property (nonatomic, assign) CGFloat autoScrollDuration; // default 3.f

@property (nonatomic, readonly, assign) CGPoint contentOffset;
@property (nonatomic, readonly, strong) UIPageControl *pageControl;

- (void)registerCellClass:(nullable Class)cellClass;
- (void)registerCellNib:(nullable UINib *)nib;

- (__kindof ZKCycleScrollViewCell *)dequeueReusableCellForIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)currentIndexPath;

- (void)reloadData;
- (void)adjustWhenViewWillAppear;

@end

NS_ASSUME_NONNULL_END
