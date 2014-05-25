//
//  LBStaggeredViewController.m
//  StaggeredAnimationDemo
//
//  Created by Louis Basile on 5/25/14.
//  Copyright (c) 2014 Louis Basile. All rights reserved.
//

#import "LBStaggeredViewController.h"

@interface LBStaggeredViewController ()

@end

@implementation LBStaggeredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Public

- (void)viewDidScrollWithOffset:(CGPoint)contentOffset
{
    
    if (![self isOnScreen]) {
        return;
    }
    
    [self changeOpacity];
    
    CGPoint offsetInWindow = [self offsetInWindow];
    NSLog(@"(%0f, %0f)", offsetInWindow.x, offsetInWindow.y);
}

#pragma mark Private

// When transitioning to become the visible VC on screen, the
// main view should transition in from transparent to opaque.
// Regardless if coming from the right or the left.
- (void)changeOpacity
{
    CGPoint offsetInWindow = [self offsetInWindow];
    
    // From the right side: an offset.x of 320 (width of an iphone) means the alpha
    // should be completely transparent (0). More values:
    // Offset = 240, alpha = 0.25
    // Offset = 160, alpha = 0.5
    // Offset = 80, alpha = 0.75
    // Offset = 0, alpha = 1
    // Same is true from the left side: offset = -320, alpha = 0
    // Since the effect is mirrored we can take abs(offset).
    //
    // Converting 320..0 to 0..1 can use this formula:
    // s..e to 0..1: (value-s)/(e-s)
    CGFloat alpha = (abs(offsetInWindow.x) - [self width]) / (0 - [self width]);
    
    self.view.alpha = alpha;
}

- (CGPoint)offsetInWindow
{
    return [self.view convertPoint:self.view.frame.origin toView:nil];
}

- (BOOL)isOnScreen
{
    CGPoint offsetInWindow = [self offsetInWindow];
    
    NSInteger max = [self width];
    NSInteger min = -max;
    
    return (offsetInWindow.x >= min) && (offsetInWindow.x <= max);
}

- (CGFloat)width
{
    return self.view.bounds.size.width;
}

@end
