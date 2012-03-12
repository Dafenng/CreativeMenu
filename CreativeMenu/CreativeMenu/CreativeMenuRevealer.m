//
//  CreativeMenuRevealer.m
//  CreativeMenu
//
//  Created by 达峰 金 on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreativeMenuRevealer.h"

@implementation CreativeMenuRevealer

@synthesize contentImageView = _contentImageView;

- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       ContentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg;
{
    if (self = [super init]) 
    {
        self.image = img;
        self.highlightedImage = himg;
        self.userInteractionEnabled = YES;
        _contentImageView = [[UIImageView alloc] initWithImage:cimg];
        _contentImageView.highlightedImage = hcimg;
        [self addSubview:_contentImageView];
        [_contentImageView release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    float width = _contentImageView.image.size.width;
    float height = _contentImageView.image.size.height;
    _contentImageView.frame = CGRectMake(15, 26, width, height);
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [_contentImageView setHighlighted:highlighted];
}

@end
