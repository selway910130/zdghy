//
//  PWLoadMoreTableFooter.m
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "PWLoadMoreTableFooterView.h"

@interface PWLoadMoreTableFooterView (Private)
- (void)setState:(PWLoadMoreState)aState;
@end

@implementation PWLoadMoreTableFooterView

@synthesize delegate=_delegate;

- (id)init {
    NSLog(@"init");
    if (self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
		UILabel *label = nil;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(12, 12, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:PWLoadMoreLoading];      //wait for the data source to tell me he has loaded all data
    }
    return self;
}

- (void)setState:(PWLoadMoreState)aState{
	NSLog(@"setState");
	switch (aState) {
		case PWLoadMoreNormal:
            [self addTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = @"载入更多";
			[_activityView stopAnimating];
			
			break;
		case PWLoadMoreLoading:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = @"载入中...";
			[_activityView startAnimating];
			
			break;
		case PWLoadMoreDone:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = @"没有更多信息";
			[_activityView stopAnimating];
            [_delegate deleteLoadMore];
            break;
        case PWLoadMoreProblem:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = @"网络连接错误";
            [_activityView startAnimating];
            break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)upDate{
    NSLog(@"3s passed");
    [self setState:PWLoadMoreNormal];
}

- (void)pwLoadMoreTableDataSourceDidFinishedLoading {
    NSLog(@"pwLoadMoreTableDataSourceDidFinishedLoading");
    if ([_delegate networkProblem]) {
        [self setState:PWLoadMoreProblem];
        NSLog(@"START");
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(upDate) userInfo:nil repeats:NO];
    }
    else {
        if ([self delegateIsAllLoaded]) {
            [self noMore];
        }
        else {
            [self canLoadMore];
        }
    }
}

- (BOOL)delegateIsAllLoaded {
    NSLog(@"delegateIsAllLoaded");
    BOOL _allLoaded = NO;
    if ([_delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceAllLoaded)]) {
        _allLoaded = [_delegate pwLoadMoreTableDataSourceAllLoaded];
    }
    return _allLoaded;
}

- (void)noMore {
    NSLog(@"noMore");
    [self setState:PWLoadMoreDone];
}

- (void)canLoadMore {
    NSLog(@"canLoadMore");
    [self setState:PWLoadMoreNormal];
}

- (void)realCallDelegateToLoadMore { 
    NSLog(@"realCallDelegateToLoadMore");
    if ([_delegate respondsToSelector:@selector(loadingData)]) {
        [self setState:PWLoadMoreLoading];
        [NSThread detachNewThreadSelector:@selector(loadingData) toTarget:_delegate withObject:nil];
    }
}

- (void)callDelegateToLoadMore {
    NSLog(@"callDelegateToLoadMore");
    if (_state == PWLoadMoreNormal) {
        [self realCallDelegateToLoadMore];
    }
    else {
        
    }
}
#pragma mark -
#pragma mark Dealloc
- (void)dealloc {
	
	_delegate=nil;
}
@end
