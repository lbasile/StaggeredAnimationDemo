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
    
    CGPoint offsetInWindow = [self offsetInWindow];
    NSLog(@"(%0f, %0f)", offsetInWindow.x, offsetInWindow.y);
}

#pragma mark Private

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
