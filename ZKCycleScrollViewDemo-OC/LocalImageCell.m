//
//  LocalImageCell.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/9.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "LocalImageCell.h"

@implementation LocalImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 8.f;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(12.f, 0.f, self.contentView.bounds.size.width - 24.f, self.contentView.bounds.size.height - 20.f);
}

@end
