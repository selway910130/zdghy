//
//  MainTabBar.m
//  CalenderTest
//
//  Created by selway on 2013-06-20.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "MainTabBar.h"

@interface MainTabBar ()

@end

@implementation MainTabBar

@synthesize tabBar;
@synthesize viewToShow;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // the views to show
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"tz"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"grrc"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"txl"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"alcx"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"htcx"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"xtsz"]];
    
	// Creat items on tab bar
	UITabBarItem *tz = [[UITabBarItem alloc] init];
    UIImage *tz_ico = [UIImage imageNamed:@"menu_ico_tz.png"];
    tz.tag = 0;
    tz.title = @"通知";
    [tz setFinishedSelectedImage:tz_ico withFinishedUnselectedImage:tz_ico];
    
	UITabBarItem *grrc = [[UITabBarItem alloc] init];
    UIImage *grrc_ico = [UIImage imageNamed:@"menu_ico_grrc.png"];
    grrc.tag = 1;
    grrc.title = @"个人日程";
    [grrc setFinishedSelectedImage:grrc_ico withFinishedUnselectedImage:grrc_ico];
    
    UITabBarItem *txl = [[UITabBarItem alloc] init];
    UIImage *txl_ico = [UIImage imageNamed:@"menu_ico_txl.png"];
    txl.tag = 2;
    txl.title = @"通讯录";
    [txl setFinishedSelectedImage:txl_ico withFinishedUnselectedImage:txl_ico];
    
    UITabBarItem *alcx = [[UITabBarItem alloc] init];
    UIImage *alcx_ico = [UIImage imageNamed:@"menu_ico_alcx.png"];
    alcx.tag = 3;
    alcx.title = @"案例查询";
    [alcx setFinishedSelectedImage:alcx_ico withFinishedUnselectedImage:alcx_ico];
    
    UITabBarItem *htcx = [[UITabBarItem alloc] init];
    UIImage *htcx_ico = [UIImage imageNamed:@"menu_ico_htcx.png"];
    htcx.tag = 4;
    htcx.title = @"合同查询";
    [htcx setFinishedSelectedImage:htcx_ico withFinishedUnselectedImage:htcx_ico];
    
    UITabBarItem *xtsz = [[UITabBarItem alloc] init];
    UIImage *xtsz_ico = [UIImage imageNamed:@"menu_ico_xtsz.png"];
    xtsz.tag = 5;
    xtsz.title = @"系统设置";
    [xtsz setFinishedSelectedImage:xtsz_ico withFinishedUnselectedImage:xtsz_ico];
	
	// Tab bar
	self.tabBar = [[ScrollTabBar alloc] initWithItems:[NSArray arrayWithObjects:tz, grrc, txl, alcx, htcx, xtsz,nil]];
	
	// Don't show scroll indicator
	self.tabBar.showsHorizontalScrollIndicator = NO;
    self.tabBar.scrollTabBarDelegate = self;
	self.tabBar.bounces = NO;
    self.tabBar.tag = 3;
    
    [self.view addSubview:self.tabBar];

    // show views
    UIViewController *views = [self.childViewControllers objectAtIndex:0];
    views.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
    viewToShow = views.view;
    [self.view addSubview:self.viewToShow];
    [self showRightArrow];
}

// select views
- (void)scrollTabBar:(ScrollTabBar *)tabBar didSelectItemWithTag:(int)tag {
    viewToShow = [[UIView alloc] init];
    NSLog(@"tag no.%d", tag);
    UIViewController *views = [self.childViewControllers objectAtIndex:tag];
    views.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
    viewToShow = views.view;
    [self.view addSubview:self.viewToShow];
}

- (void)showRightArrow{
    UIImageView *arrow_right = [[UIImageView alloc]initWithFrame:CGRectMake(307, self.view.frame.size.height-33, 10, 10)];
    arrow_right.image = [UIImage imageNamed:@"arrow_next.png"];
    arrow_right.tag = 10;
    [self.view addSubview:arrow_right];
}

- (void)showLeftArrow{
    UIImageView *arrow_left = [[UIImageView alloc]initWithFrame:CGRectMake(3, self.view.frame.size.height-33, 10, 10)];
    arrow_left.image = [UIImage imageNamed:@"arrow_previous.png"];
    arrow_left.tag = 20;
    [self.view addSubview:arrow_left];
}

- (void)dismissRightArrow{
    for (UIView *subview in self.view.subviews){
        if (subview.tag == 10) {
            [subview removeFromSuperview];
        }
    }
}

- (void)dismissLeftArrow{
    for (UIView *subview in self.view.subviews){
        if (subview.tag == 20) {
            [subview removeFromSuperview];
        }
    }
}
@end