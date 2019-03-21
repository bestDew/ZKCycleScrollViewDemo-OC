//
//  LocalImageCell.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/21.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "LocalImageCell.h"

@implementation LocalImageCell

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(_imageView.frame, point)) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

@end
