//
//  ScheduleListViewController.h
//  test
//
//  Created by selway on 2013-07-26.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL needRefresh;

@interface ScheduleListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)backButton:(id)sender;
- (IBAction)createEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *sendLists;
@end
