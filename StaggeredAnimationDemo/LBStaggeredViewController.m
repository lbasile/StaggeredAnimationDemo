//
//  LBStaggeredViewController.m
//  StaggeredAnimationDemo
//
//  Created by Louis Basile on 5/25/14.
//  Copyright (c) 2014 Louis Basile. All rights reserved.
//

#import "LBStaggeredViewController.h"

@interface LBStaggeredViewController ()
@property (nonatomic, copy) NSMapTable *subviewsWithVelocities;
@end

@implementation LBStaggeredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupSubviewsWithVelocities];
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
    [self staggerViewPositions];
    
    CGPoint offsetInWindow = [self offsetInWindow];
    NSLog(@"(%0f, %0f)", offsetInWindow.x, offsetInWindow.y);
}

#pragma mark Private

- (void)setupSubviewsWithVelocities
{
    self.subviewsWithVelocities = [NSMapTable strongToStrongObjectsMapTable];
    
    for (UIView *view in [self.view subviews]) {
        CGFloat velocity = [self velocityForView:view];
        [self.subviewsWithVelocities setObject:@(velocity) forKey:view];
    }
}

// Animates subviews in based on the scroll direction, but does it "staggered".
// The closer to the top, the less distance the view will travel. A view at the
// very top will travel 1x the distance/speed it normally would.
//
// The closer to the bottom, the more distance the view will travel. A view at
// the very bottom will travel 3x the distance/speed as it normally would.
- (void)staggerViewPositions
{
    // TODO: CRAZY MAGIC.
    for (UIView *view in [self.view subviews]) {
        CGRect frame = view.frame;
        NSNumber *velocity = [self.subviewsWithVelocities objectForKey:view];
        frame.origin.x *= [velocity floatValue];
        view.frame = frame;
    }
}

- (CGFloat)velocityForView:(UIView *)view
{
    // 0..yMaxHeight to 0%..100%: y/height
    CGFloat yPercent = view.frame.origin.y/[self height];
    
    // yPercent Range = (0..1)
    // velocity Range = (1..3)
    // Conversion formula:
    // ** OldRange = (OldMax - OldMin)
    // ** NewRange = (NewMax - NewMin)
    // ** NewValue = (((OldValue - OldMin) * NewRange) / OldRange) + NewMin
    //
    // Velocity = ((OldValue - 0) * NewRange / 1) + NewMin
    // Simplifying: Velocity = OldValue * NewRange + 1
    NSInteger velocityMin = 1;
    NSInteger velocityMax = 3;
    CGFloat velocityRange = velocityMax-velocityMin;
    CGFloat velocity = yPercent * velocityRange + velocityMin;
    
    return velocity;
}

// The farther away being centered on screen, the more transparent the view
// should be. This way transitioning "in" (from either side) goes from transparent
// to opaque.
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

- (CGFloat)height
{
    return self.view.bounds.size.height;
}

@end
