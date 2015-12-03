//
//  FourthViewController.m
//  test
//
//  Created by selway on 2013-06-09.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ContractViewController.h"

@interface ContractViewController ()
@end

@implementation ContractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CustomNavBar;
    
    // Scroll view
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View1"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View1"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View1"]];
    
    NSInteger numberOfViews = [self.childViewControllers count];
    for (int i = 0; i < numberOfViews; i++)
    {
        UIViewController *abc = [self.childViewControllers objectAtIndex:i];
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIView *awesomeView = abc.view;
        abc.view.frame = CGRectMake(xOrigin,0,self.view.frame.size.width, self.view.frame.size.height - 44 - 49 - 40);
        [scrollView addSubview:awesomeView];
        scrollView.contentSize = CGSizeMake((self.view.frame.size.width * numberOfViews), self.view.frame.size.height - 44 - 49 - 40);
        
    } 
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    
    // Pager
    [pagerView setImage:[UIImage imageNamed:@"contract_bar.png"]
       highlightedImage:[UIImage imageNamed:@"contract_bar1.png"]
                 forKey:@"a"];
    
    [pagerView setPattern:@"aaa"];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 107, 44)];
    title1.text = @"规划合同";
    title1.textColor = [UIColor colorWithRed:(119/255.0) green:(72/255.0) blue:(34/255.0) alpha:1];
    title1.font = [UIFont boldSystemFontOfSize:20];
    title1.textAlignment = NSTextAlignmentCenter;
    title1.backgroundColor = [UIColor clearColor];
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(107, 0, 107, 44)];
    title2.text = @"招投标";
    title2.textColor = [UIColor colorWithRed:(119/255.0) green:(72/255.0) blue:(34/255.0) alpha:1];
    title2.font = [UIFont boldSystemFontOfSize:20];
    title2.textAlignment = NSTextAlignmentCenter;
    title2.backgroundColor = [UIColor clearColor];
    
    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(214, 0, 107, 44)];
    title3.text = @"建筑、园林";
    title3.textColor = [UIColor colorWithRed:(119/255.0) green:(72/255.0) blue:(34/255.0) alpha:1];
    title3.font = [UIFont boldSystemFontOfSize:20];
    title3.textAlignment = NSTextAlignmentCenter;
    title3.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:title1];
    [self.view addSubview:title2];
    [self.view addSubview:title3];
    
    pagerView.delegate = self;
}

- (void)updatePager
{
    NSLog(@"%f", scrollView.contentOffset.x);
    pagerView.page = floorf(scrollView.contentOffset.x / scrollView.frame.size.width);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePager];
    }
}

- (void)pageView:(PagerView *)pageView didUpdateToPage:(NSInteger)newPage
{
    CGPoint offset = CGPointMake(scrollView.frame.size.width * pagerView.page, 0);
    [scrollView setContentOffset:offset animated:YES];
}

- (void)viewDidUnload
{
    pagerView = nil;
    scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

