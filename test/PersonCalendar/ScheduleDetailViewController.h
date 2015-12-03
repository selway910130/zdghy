//
//  ScheduleDetailViewController.h
//  test
//
//  Created by selway on 2013-07-26.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_title;
@property (weak, nonatomic) IBOutlet UILabel *label_title;


@property (strong, nonatomic) NSString *sendScheduleName;
@property (strong, nonatomic) NSString *sendScheduleContent;
@property (strong, nonatomic) NSString *sendStartTime;
@property (strong, nonatomic) NSString *sendEndTime;
@property (strong, nonatomic) NSString *sendScheduleLevelName;
@property (strong, nonatomic) NSString *sendScheduleRangeName;
@property (strong, nonatomic) NSString *sendRemindMode;
@property (strong, nonatomic) NSString *sendRemindTimeName;
@property (strong, nonatomic) NSString *sendRemark;
@property (strong, nonatomic) NSString *sendShowGroup;
@property (strong, nonatomic) NSString *sendPersonNames;

@end
