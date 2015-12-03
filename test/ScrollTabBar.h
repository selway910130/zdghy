//
//  ScrollTabBar.h
//  CalenderTest
//
//  Created by selway on 2013-06-20.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollTabBarDelegate;

@interface ScrollTabBar : UIScrollView <UIScrollViewDelegate, UITabBarDelegate> {
	__unsafe_unretained id <ScrollTabBarDelegate> scrollTabBarDelegate;
	NSMutableArray *tabBars;
}

@property (nonatomic, assign) id scrollTabBarDelegate;
@property (nonatomic, retain) NSMutableArray *tabBars;
@property int old_tag;


- (id)initWithItems:(NSArray *)items;
@end

@protocol ScrollTabBarDelegate <NSObject>
- (void)scrollTabBar:(ScrollTabBar *)tabBar didSelectItemWithTag:(int)tag;

- (void)showRightArrow;
- (void)showLeftArrow;
- (void)dismissRightArrow;
- (void)dismissLeftArrow;
@end