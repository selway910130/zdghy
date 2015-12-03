//
//  FourthViewController.h
//  test
//
//  Created by selway on 2013-06-09.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagerView.h"
#import "AppDelegate.h"

@interface ContractViewController : UIViewController <UIScrollViewDelegate, PagerViewDelegate> {
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet PagerView *pagerView;
}

@end
