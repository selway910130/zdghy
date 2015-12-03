//
//  alcxViewController.h
//  test
//
//  Created by selway on 2013-07-03.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWLoadMoreTableFooterView.h"

@interface CaseViewController : UITableViewController <PWLoadMoreTableFooterDelegate, UISearchBarDelegate> {
    PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _datasourceIsLoading;
    bool _allLoaded;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
