//
//  ZKCycleScrollViewFlowLayout.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/21.
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

#import "ZKCycleScrollViewFlowLayout.h"

@implementation ZKCycleScrollViewFlowLayout

- (instancetype)init
{
    if (self = [super init]) {
        
        _zoomScale = 1.f;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        _zoomScale = 1.f;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical: {
            CGFloat offset = CGRectGetMidY(self.collectionView.bounds);
            CGFloat distanceForScale = self.itemSize.height + self.minimumLineSpacing;
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat scale = 0.f;
                CGFloat distance = ABS(offset - attr.center.y);
                if (distance >= distanceForScale) {
                    scale = _zoomScale;
                } else if (distance == 0.f) {
                    scale = 1.f;
                    attr.zIndex = 1;
                } else {
                    scale = _zoomScale + (distanceForScale - distance) * (1.f - _zoomScale) / distanceForScale;
                }
                attr.transform = CGAffineTransformMakeScale(scale, scale);
            }
            break;
        }
        default: {
            CGFloat offset = CGRectGetMidX(self.collectionView.bounds);
            CGFloat distanceForScale = self.itemSize.width + self.minimumLineSpacing;
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat scale = 0.f;
                CGFloat distance = ABS(offset - attr.center.x);
                if (distance >= distanceForScale) {
                    scale = _zoomScale;
                } else if (distance == 0.f) {
                    scale = 1.f;
                    attr.zIndex = 1;
                } else {
                    scale = _zoomScale + (distanceForScale - distance) * (1.f - _zoomScale) / distanceForScale;
                }
                attr.transform = CGAffineTransformMakeScale(scale, scale);
            }
            break;
        }
    }

    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return true;
}

@end
