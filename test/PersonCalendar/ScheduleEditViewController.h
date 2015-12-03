//
//  ScheduleEditViewController.h
//  test
//
//  Created by selway on 2013-07-26.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectMenu.h"

@interface ScheduleEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, SelectMenuDelegate>{
    SelectMenu *selectMenu;
}

- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *sendScheduleId;
@property (strong, nonatomic) NSString *sendScheduleName;
@property (strong, nonatomic) NSString *sendScheduleContent;
@property (strong, nonatomic) NSString *sendStartTime;
@property (strong, nonatomic) NSString *sendEndTime;
@property (strong, nonatomic) NSString *sendScheduleLevel;
@property (strong, nonatomic) NSString *sendScheduleLevelName;
@property (strong, nonatomic) NSArray *sendScheduleLevelList;
@property (strong, nonatomic) NSString *sendScheduleRange;
@property (strong, nonatomic) NSString *sendScheduleRangeName;
@property (strong, nonatomic) NSArray *sendScheduleRangeList;
@property (strong, nonatomic) NSString *sendRemindMode;
@property (strong, nonatomic) NSString *sendRemindTime;
@property (strong, nonatomic) NSString *sendRemindTimeName;
@property (strong, nonatomic) NSArray *sendRemindTimeList;
@property (strong, nonatomic) NSString *sendRemark;
@property (strong, nonatomic) NSString *sendCreateUser;
@property (strong, nonatomic) NSString *sendShowGroup;
@property (strong, nonatomic) NSString *sendPersonNames;


@end
