//
//  AppDelegate.h
//  test
//
//  Created by selway on 2013-05-29.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

// custom the navigation bar background and back buttom on it.
#define CustomNavBar UIImage *imageNavBar = [UIImage imageNamed:@"titlepic.png"];[self.navigationController.navigationBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];UIImage *backButtonImage = [[UIImage imageNamed:@"btn_return_0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];UIImage *higlightedbackButtonImage = [[UIImage imageNamed:@"btn_return_1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];[[UIBarButtonItem appearance] setBackButtonBackgroundImage:higlightedbackButtonImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];[[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor darkGrayColor],UITextAttributeTextColor,[UIColor lightGrayColor],                                         UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, -1)],UITextAttributeTextShadowOffset,nil] forState:UIControlStateNormal];

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

NSString *main_url;
NSInteger pageOfContract;
NSString *selectedDate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSDictionary*) connectToServer:(NSString *)post :(NSURL *)url;

@end
