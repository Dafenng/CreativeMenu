//
//  CreativeMenuBar.h
//  CreativeMenu
//
//  Created by 达峰 金 on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreativeMenuItem.h"
#import "CreativeMenuRevealer.h"

@protocol CreativeMenuBarDelegate;

@interface CreativeMenuBar : UIView <CreativeMenuItemDelegate>
{
    int _flag;
    NSTimer *_timer;
    CreativeMenuRevealer *_revealerButton;
    UIView *_menuBarView;
}

@property (retain, nonatomic) NSArray *menuItemsArray;
@property (getter = isExpanded, nonatomic) BOOL expanded;
@property (assign, nonatomic) id<CreativeMenuBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItemsArray;

@end

@protocol CreativeMenuBarDelegate <NSObject>

- (void)creativeMenu:(CreativeMenuBar *)menuBar didSelectIndex:(NSInteger)index;

@end