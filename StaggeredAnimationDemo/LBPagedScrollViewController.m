//
//  LBPagedScrollViewController.m
//  StaggeredAnimationDemo
//
//  Created by Louis Basile on 5/21/14.
//  Copyright (c) 2014 Louis Basile. All rights reserved.
//

#import "LBPagedScrollViewController.h"

#import "LBStaggeredViewController.h"

@interface LBPagedScrollViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;

@property (copy, nonatomic) NSArray *staggeredViewControllers;
@end

@implementation LBPagedScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"StaggeredAnimationDemo";
    
    [self setupStaggeredViewControllers];
    
    NSLog(@"%@", self.staggeredViewControllers);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (IBAction)userDidPage:(id)sender
{
    NSInteger page = self.pager.currentPage;
    CGFloat width = self.scrollView.bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(page*width, 0) animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (LBStaggeredViewController *vc in self.staggeredViewControllers) {
        [vc viewDidScrollWithOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width;
    
    self.pager.currentPage = x/width;
}

#pragma mark Private

- (void)setupStaggeredViewControllers
{
    NSMutableArray *vcs = [NSMutableArray array];
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[LBStaggeredViewController class]]) {
            LBStaggeredViewController *vc = obj;
            [vcs addObject:vc];
        }
    }];
    
    self.staggeredViewControllers = vcs;
}

@end
