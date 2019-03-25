//
//  ZKCycleScrollViewFlowLayout.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/21.
//  Copyright © 2019 bestdew. All rights reserved.
//

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
