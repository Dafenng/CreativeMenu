//
//  CreativeMenuItem.h
//  CreativeMenu
//
//  Created by 达峰 金 on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreativeMenuItemDelegate;

@interface CreativeMenuItem : UIImageView
{
    UIImageView *_contentImageView;
}

@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint endPoint;
@property (assign, nonatomic) CGPoint nearPoint;
@property (assign, nonatomic) CGPoint farPoint;

@property (assign, nonatomic) id<CreativeMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       ContentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg;

@end

@protocol CreativeMenuItemDelegate <NSObject>

- (void)creativeMenuItemTouchesEnd:(CreativeMenuItem *)item;

@end