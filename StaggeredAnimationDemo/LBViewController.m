//
//  LBViewController.m
//  StaggeredAnimationDemo
//
//  Created by Louis Basile on 5/21/14.
//  Copyright (c) 2014 Louis Basile. All rights reserved.
//

#import "LBViewController.h"

@interface LBViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"StaggeredAnimationDemo";
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollView.bounds.size.width;
    
    self.pager.currentPage = x/width;
}

@end
