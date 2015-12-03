//
//  ThirdViewController.h
//  test
//
//  Created by selway on 2013-05-31.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellForContact.h"
#import "PWLoadMoreTableFooterView.h"

@interface ContactViewController : UITableViewController <PWLoadMoreTableFooterDelegate, UISearchBarDelegate> {
    PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _datasourceIsLoading;
    bool _allLoaded;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
