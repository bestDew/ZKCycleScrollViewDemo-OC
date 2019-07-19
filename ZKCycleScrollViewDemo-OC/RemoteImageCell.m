//
//  RemoteImageCell.m
//  ZKCycleScrollViewDemo-OC
//
//  Created by bestdew on 2019/3/9.
//  Copyright © 2019 bestdew. All rights reserved.
//

#import "RemoteImageCell.h"
#import <YYWebImage/YYWebImage.h>

@interface RemoteImageCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation RemoteImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.contentView.bounds;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_imageView yy_setImageWithURL:imageURL options:YYWebImageOptionSetImageWithFadeAnimation];
}

@end
