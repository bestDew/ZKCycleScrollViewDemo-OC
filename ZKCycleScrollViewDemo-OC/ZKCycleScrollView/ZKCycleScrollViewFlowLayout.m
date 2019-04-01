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

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical: {
            CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.bounds.size.height / 2;
            
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat distance = ABS(attr.center.y - centerY);
                CGFloat scale = 1 / (1 + distance * _zoomFactor);
                attr.transform = CGAffineTransformMakeScale(scale, scale);
            }
            break;
        }
        default: {
            CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2;
            
            for (UICollectionViewLayoutAttributes *attr in attributes) {
                CGFloat distance = ABS(attr.center.x - centerX);
                CGFloat scale = 1 / (1 + distance * _zoomFactor);
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
