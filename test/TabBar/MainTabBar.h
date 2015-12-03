//
//  MainTabBar.h
//  CalenderTest
//
//  Created by selway on 2013-06-20.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollTabBar.h"

@interface MainTabBar : UIViewController {
	ScrollTabBar *tabBar;
}

@property (nonatomic, retain) ScrollTabBar *tabBar;
@property (strong, nonatomic) IBOutlet UIView *viewToShow;

@end
