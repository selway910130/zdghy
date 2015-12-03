//
//  PagerView.h
//  test
//
//  Created by selway on 2013-06-17.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PagerViewDelegate;

@interface PagerView : UIView

- (void)setImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage forKey:(NSString *)key;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,readonly) NSInteger numberOfPages;
@property (nonatomic,copy) NSString *pattern;
@property (nonatomic,assign) id<PagerViewDelegate>delegate;

@end

@protocol PagerViewDelegate <NSObject>

@optional
- (BOOL)pageView:(PagerView *)pageView shouldUpdateToPage:(NSInteger)newPage;
- (void)pageView:(PagerView *)pageView didUpdateToPage:(NSInteger)newPage;

@end
