//
//  ContractListViewController.h
//  test
//
//  Created by selway on 2013-07-16.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWLoadMoreTableFooterView.h"

@interface ContractListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,PWLoadMoreTableFooterDelegate> {
    PWLoadMoreTableFooterView *_loadMoreFooterView;
	BOOL _datasourceIsLoading;
    bool _allLoaded;
}

@property (weak, nonatomic) IBOutlet UITableView *lst;

@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;
- (IBAction)backButton:(id)sender;

@end
