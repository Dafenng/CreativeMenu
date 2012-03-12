//
//  CreativeMenuRevealer.h
//  CreativeMenu
//
//  Created by 达峰 金 on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreativeMenuRevealer : UIImageView

@property (retain, nonatomic) UIImageView *contentImageView;
- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       ContentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg;

@end
