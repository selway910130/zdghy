//
//  ScheduleDetailViewController.m
//  test
//
//  Created by selway on 2013-07-26.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "AppDelegate.h"
#import "CustomTwoLabelsCell.h"

@interface ScheduleDetailViewController ()

@property NSArray *lstOfTitles;
@property NSArray *lstOfContents;

@end

@implementation ScheduleDetailViewController

@synthesize titleBar;
@synthesize tableView;

@synthesize scrollView_title;
@synthesize label_title;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    self.label_title.text = self.sendScheduleName;
    
    NSString *newTime = [NSString stringWithFormat:@"%@ -\n%@", self.sendStartTime, self.sendEndTime];

    if ([self.sendShowGroup intValue] == 0) {
        self.lstOfTitles = @[@"日程内容", @"起止时间", @"日程级别", @"公开范围", @"提醒方式", @"提醒时间", @"备注"];
        self.lstOfContents = @[self.sendScheduleContent, newTime, self.sendScheduleLevelName, self.sendScheduleRangeName, self.sendRemindMode, self.sendRemindTimeName, self.sendRemark];
    }
    else if ([self.sendShowGroup intValue] == 1){
        self.lstOfTitles = @[@"安排人员", @"日程内容", @"起止时间", @"日程级别", @"公开范围", @"提醒方式", @"提醒时间", @"备注"];
        self.lstOfContents = @[self.sendPersonNames, self.sendScheduleContent, newTime, self.sendScheduleLevelName, self.sendScheduleRangeName, self.sendRemindMode, self.sendRemindTimeName, self.sendRemark];
    }
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
}

- (void)viewDidAppear:(BOOL)animated{
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    CGSize titleLabelSize = [self.sendScheduleName sizeWithFont:self.label_title.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:self.label_title.lineBreakMode];
    if (titleLabelSize.height > 21.0f) {
        [self.label_title setFrame:CGRectMake(20, 1, self.label_title.frame.size.width, self.label_title.frame.size.height)];
    }
}

#pragma mark - table view date source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lstOfTitles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *forCal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 195, 21)];
    CGSize maximumLabelSize = CGSizeMake(195,99999);
    CGSize titleLabelSize = [[self.lstOfContents objectAtIndex:indexPath.row] sizeWithFont:forCal.font
                                                                         constrainedToSize:maximumLabelSize
                                                                             lineBreakMode:forCal.lineBreakMode];
    if (titleLabelSize.height == 0) {
        return 35;
    }
    return titleLabelSize.height + 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"scheduleDetail";
    CustomTwoLabelsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.title.text = [self.lstOfTitles objectAtIndex:indexPath.row];
    cell.content.text = [self.lstOfContents objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
