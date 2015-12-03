//
//  ImageViewController.h
//  test
//
//  Created by selway on 2013-07-22.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate>{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIPageControl *pageControl;
}

@property (strong, nonatomic) NSArray *sendImageLst;

@end
