//
//  FirstViewController.h
//  test
//
//  Created by selway on 2013-06-04.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonCustomCell.h"
#import "PWLoadMoreTableFooterView.h"

@interface NoticeViewController : UITableViewController <PWLoadMoreTableFooterDelegate, UISearchBarDelegate> {
    PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _datasourceIsLoading;
    bool _allLoaded;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
