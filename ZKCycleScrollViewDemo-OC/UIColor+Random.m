//
//  UIColor+Random.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/11/11.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randomColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    
    return randomColor;
}

@end
