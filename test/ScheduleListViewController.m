//
//  ScheduleListViewController.m
//  test
//
//  Created by selway on 2013-07-26.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ScheduleListViewController.h"
#import "ScheduleCell.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "ScheduleDetailViewController.h"
#import "ScheduleEditViewController.h"

@interface ScheduleListViewController ()

@property NSDictionary *viewDic;
@property NSDictionary *editDic;

@property NSString *scheduleId;

@end

@implementation ScheduleListViewController

@synthesize titleBar;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"schedule %@", self.sendLists);
    self.navigationItem.hidesBackButton = YES;
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = selectedDate;
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = [UIColor colorWithRed:(119/255.0) green:(72/255.0) blue:(34/255.0) alpha:1];
    title.frame = CGRectMake(0, 0, 320, 44);
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    self.titleBar.topItem.titleView = title;
    needRefresh = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    if (needRefresh) {
        NSLog(@"refresh");
        needRefresh = NO;
        [SVProgressHUD showWithStatus:@"载入中"];
        NSString *post = [@"cond.cond.endTime=" stringByAppendingString:selectedDate];
        NSLog(@"post: %@", post);
        [NSThread detachNewThreadSelector:@selector(getEvent:) toTarget:self withObject:post];
    }
}

- (void)getEvent:(NSString *)post{
    NSURL *url = [NSURL URLWithString:[main_url stringByAppendingFormat:@"ad03/ad0301/search"]];
    
    NSDictionary *tempDic = [AppDelegate connectToServer:post :url];
    if (tempDic != nil) {
        NSLog(@"tempDic %@", tempDic);
        NSInteger success = [(NSNumber *) [tempDic objectForKey:@"success"] integerValue];
        if (success == 1){
            self.sendLists = [tempDic objectForKey:@"message"];
            [SVProgressHUD dismiss];
        }
        else{
            self.sendLists = @[];
            [SVProgressHUD show];
            [SVProgressHUD dismissWithError:@"该日没有日程"];
        }
    }
    [self.tableView reloadData];
    [NSThread exit];
}

#pragma - table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sendLists count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *forCal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 21)];
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    NSDictionary *tempEvent = [self.sendLists objectAtIndex:indexPath.row];
    CGSize titleLabelSize = [[tempEvent objectForKey:@"scheduleName"] sizeWithFont:forCal.font
                                                           constrainedToSize:maximumLabelSize
                                                               lineBreakMode:forCal.lineBreakMode];
    return titleLabelSize.height + 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"listCell";
    ScheduleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *event = [self.sendLists objectAtIndex:indexPath.row];
    NSInteger level = [[event objectForKey:@"scheduleLevel"] intValue];
    
    cell.title.text = [event objectForKey:@"scheduleName"];
    if (level == 1) {
        cell.title.textColor = [UIColor redColor];
    }
    else if (level == 2) {
        cell.title.textColor = [UIColor blueColor];
    }
    else cell.title.textColor = [UIColor blackColor];
    
    cell.content.text = [event objectForKey:@"scheduleContent"];
    cell.type.text = [event objectForKey:@"scheduleRange"];
    cell.startTime.text = [event objectForKey:@"startTime"];
    cell.endTime.text = [event objectForKey:@"endTime"];
    cell.editButton.tag = [[event objectForKey:@"scheduleId"] intValue];
    [cell.editButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor orangeColor]];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

#pragma select row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *event = [self.sendLists objectAtIndex:indexPath.row];
    NSString *scheduleId = [event objectForKey:@"scheduleId"];
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingDetail:) toTarget:self withObject:scheduleId];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) loadingDetail:(NSString *)scheduleId{
    NSString *tempStr = [main_url stringByAppendingString:@"ad03/ad0301/detail?scheduleId=%@"];
    NSString *urlStr = [[NSString alloc] initWithFormat:tempStr, scheduleId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@", url);
    
    NSDictionary *msgData = [AppDelegate connectToServer:nil :url];
    if (msgData != nil) {
        NSInteger success = [(NSNumber *) [msgData objectForKey:@"success"] integerValue];
        if(success == 1){
            NSLog(@"detail : %@", [msgData objectForKey:@"message"]);
            self.viewDic = [msgData objectForKey:@"message"];
            [self performSegueWithIdentifier:@"scheduleDetail" sender:self];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD show];
            [SVProgressHUD dismissWithError:@"请重新登陆"];
        }
    }
    [NSThread exit];
}

#pragma edit button

- (void)buttonClicked:(id)sender {
    NSLog(@"Button pressed %d", [sender tag]);
    self.scheduleId = [NSString stringWithFormat:@"%d", [sender tag]];
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingDetailByButton:) toTarget:self withObject:self.scheduleId];
}

- (IBAction)createEvent:(id)sender {
    self.scheduleId = @"";
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingDetailByButton:) toTarget:self withObject:self.scheduleId];
}

- (void) loadingDetailByButton:(NSString *)sendId{
    NSString *tempStr = [main_url stringByAppendingString:@"ad03/ad0301/detail?scheduleId=%@&isEdit=true"];
    NSString *urlStr = [[NSString alloc] initWithFormat:tempStr, sendId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@", url);
    
    NSDictionary *msgData = [AppDelegate connectToServer:nil :url];
    if (msgData != nil) {
        NSInteger success = [(NSNumber *) [msgData objectForKey:@"success"] integerValue];
        if(success == 1){
            NSLog(@"detail : %@", [msgData objectForKey:@"message"]);
            self.viewDic = [msgData objectForKey:@"message"];
            [self performSelectorOnMainThread:@selector(jumpToEdit) withObject:nil waitUntilDone:NO];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD show];
            [SVProgressHUD dismissWithError:@"请重新登陆"];
        }
    }
    [NSThread exit];
}

- (void)jumpToEdit{
    [self performSegueWithIdentifier:@"editEvent" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scheduleDetail"]) {
        ScheduleDetailViewController *dvc = segue.destinationViewController;
        dvc.sendScheduleName = [self.viewDic objectForKey:@"scheduleName"];
        dvc.sendScheduleContent = [self.viewDic objectForKey:@"scheduleContent"];
        dvc.sendStartTime = [self.viewDic objectForKey:@"startTime"];
        dvc.sendEndTime = [self.viewDic objectForKey:@"endTime"];
        dvc.sendScheduleLevelName = [self.viewDic objectForKey:@"scheduleLevelName"];
        dvc.sendScheduleRangeName = [self.viewDic objectForKey:@"scheduleRangeName"];
        dvc.sendRemindMode = [self.viewDic objectForKey:@"remindMode"];
        dvc.sendRemindTimeName = [self.viewDic objectForKey:@"remindTimeName"];
        dvc.sendRemark = [self.viewDic objectForKey:@"remark"];
        dvc.sendShowGroup = [self.viewDic objectForKey:@"showGroup"];
        dvc.sendPersonNames = [self.viewDic objectForKey:@"personNames"];
        return;
    }
    else if ([segue.identifier isEqualToString:@"editEvent"]) {
        ScheduleEditViewController *dvc = segue.destinationViewController;
        dvc.sendScheduleId = self.scheduleId;
        dvc.sendScheduleName = [self.viewDic objectForKey:@"scheduleName"];
        dvc.sendScheduleContent = [self.viewDic objectForKey:@"scheduleContent"];
        dvc.sendStartTime = [self.viewDic objectForKey:@"startTime"];
        dvc.sendEndTime = [self.viewDic objectForKey:@"endTime"];
        
        dvc.sendScheduleLevelName = [self.viewDic objectForKey:@"scheduleLevelName"];
        dvc.sendScheduleLevel = [self.viewDic objectForKey:@"scheduleLevel"];
        dvc.sendScheduleLevelList = [self.viewDic objectForKey:@"scheduleLevelList"];
        dvc.sendScheduleRangeName = [self.viewDic objectForKey:@"scheduleRangeName"];
        dvc.sendScheduleRange = [self.viewDic objectForKey:@"scheduleRange"];
        
        dvc.sendScheduleRangeList = [self.viewDic objectForKey:@"scheduleRangeList"];
        dvc.sendRemindMode = [self.viewDic objectForKey:@"remindMode"];
        dvc.sendRemindTime = [self.viewDic objectForKey:@"remindTime"];
        dvc.sendRemindTimeName = [self.viewDic objectForKey:@"remindTimeName"];
        dvc.sendRemindTimeList = [self.viewDic objectForKey:@"remindTimeList"];
        
        dvc.sendRemark = [self.viewDic objectForKey:@"remark"];
        dvc.sendPersonNames = [self.viewDic objectForKey:@"personNames"];

        if ([self.scheduleId isEqualToString:@""]) {
            dvc.sendCreateUser = @"";
            dvc.sendShowGroup = @"";
        }
        else{
            dvc.sendCreateUser = [self.viewDic objectForKey:@"createUser"];
            dvc.sendShowGroup = [self.viewDic objectForKey:@"showGroup"];

        }
        return;
    }
}



- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
