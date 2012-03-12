//
//  CreativeMenuBar.m
//  CreativeMenu
//
//  Created by 达峰 金 on 12-3-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreativeMenuBar.h"
#import <QuartzCore/QuartzCore.h>

#define REVEALCENTER CGPointMake(26, 450)
#define STARTPOINT CGPointMake(-22, 26)
#define TIMEOFFSET 0.036f
#define TIMEDELAY 0.15f

@interface CreativeMenuBar (private)
- (void)expandMenu;
- (void)closeMenu;
@end

@implementation CreativeMenuBar

@synthesize expanded = _expanded;
@synthesize delegate = _delegate;
@synthesize menuItemsArray = _menuItemsArray;

- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _revealerButton = [[CreativeMenuRevealer alloc] initWithImage:[UIImage imageNamed:@"reveal_button.png"]
                                                     highlightedImage:[UIImage imageNamed:@"reveal_button_highlight.png"] 
                                                         ContentImage:[UIImage imageNamed:@"reveal_arrow.png"] 
                                              highlightedContentImage:[UIImage imageNamed:@"reveal_arrow.png"]];
        _revealerButton.center = REVEALCENTER;
        [self addSubview:_revealerButton];
        [_revealerButton release];
        
        _menuBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.bounds.size.height - 4.0, self.bounds.size.width, 52.0f)];
        _menuBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bar_background.png"]];
        [self addSubview:_menuBarView];
        [_menuBarView release];
        
        self.menuItemsArray = menuItemsArray;
    }
    return self;
}

- (void)dealloc {
    [_menuItemsArray release];
    [super dealloc];
}

#pragma mark - UIView's Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_expanded) 
    {
        return YES;
    }
    else
    {
        return CGRectContainsPoint(_revealerButton.frame, point);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if(CGRectContainsPoint(_revealerButton.frame, location))
        _revealerButton.highlighted = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if(!CGRectContainsPoint(_revealerButton.frame, location))
        _revealerButton.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _revealerButton.highlighted = NO;
    if (_expanded) {
        self.expanded = !self.isExpanded;
    } else {
        CGPoint location = [[touches anyObject] locationInView:self];
        if(CGRectContainsPoint(_revealerButton.frame, location))
            self.expanded = !self.isExpanded;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
#pragma mark - Setter & Getter Methods

- (void)setMenuItemsArray:(NSArray *)menuItemsArray
{
    if (menuItemsArray == _menuItemsArray)
    {
        return;
    }
    
    [_menuItemsArray release];
    _menuItemsArray = [menuItemsArray retain];
    
    for (UIView *menuItemView in _menuBarView.subviews) {
        [menuItemView removeFromSuperview];
    }
    
    NSInteger count = [_menuItemsArray count];
    for (int i = 0; i < count; i++) {
        CreativeMenuItem *item = [_menuItemsArray objectAtIndex:i];
        item.tag = 1000 + i;
        item.startPoint = STARTPOINT;
        CGPoint endPoint = CGPointMake(((float)i * 2 + 1) / (count * 2) * _menuBarView.bounds.size.width, STARTPOINT.y);
        item.endPoint = endPoint;
        CGPoint farPoint = CGPointMake(endPoint.x + 20.0, endPoint.y);
        item.farPoint = farPoint;
        CGPoint nearPoint = CGPointMake(endPoint.x - 10.0, endPoint.y);
        item.nearPoint = nearPoint;
        item.center = item.startPoint;
        item.delegate = self;
        [_menuBarView addSubview:item];
    }
}

- (BOOL)isExpanded
{
    return _expanded;
}

- (void)setExpanded:(BOOL)expanded
{
    _expanded = expanded;    
    
    float angle = self.isExpanded ? -M_PI : 0.0f;
    float translation = self.isExpanded ? -48.0f : 0.0f;
    float delay = self.isExpanded ? 0.0f : TIMEDELAY * [_menuItemsArray count];
    
    [UIView animateWithDuration:0.2f delay:delay options:UIViewAnimationCurveLinear animations:^{
        _revealerButton.transform = CGAffineTransformMakeTranslation(0, translation);
        _revealerButton.contentImageView.transform = CGAffineTransformMakeRotation(angle);
        _menuBarView.transform = CGAffineTransformMakeTranslation(0, translation);
    }completion:nil];
    
    if (!_timer) 
    {
        _flag = self.isExpanded ? 0 : ([_menuItemsArray count] - 1);
        SEL selector = self.isExpanded ? @selector(expandMenu) : @selector(closeMenu);
        _timer = [[NSTimer scheduledTimerWithTimeInterval:TIMEOFFSET target:self selector:selector userInfo:nil repeats:YES] retain];
    }
}

#pragma mark - Private Methods

- (void)expandMenu
{
    if (_flag == [_menuItemsArray count]) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
    CreativeMenuItem *item = (CreativeMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.3], 
                                [NSNumber numberWithFloat:.4], nil]; 
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    _flag ++;
    
}

- (void)closeMenu
{
    if (_flag == -1)
    {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
    CreativeMenuItem *item = (CreativeMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0], 
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil]; 
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y); 
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    _flag --;
}

#pragma mark - CreativeMenuItem Delegate Methods

- (void)creativeMenuItemTouchesEnd:(CreativeMenuItem *)item
{
    self.expanded = NO;
    
    if ([_delegate respondsToSelector:@selector(creativeMenu:didSelectIndex:)])
    {
        
        [_delegate creativeMenu:self didSelectIndex:item.tag - 1000];
    }
}

@end
