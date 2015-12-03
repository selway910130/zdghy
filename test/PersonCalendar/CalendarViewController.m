//
//  SecondViewController.m
//  test
//
//  Created by selway on 2013-05-31.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "CalendarViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ScheduleListViewController.h"

@interface CalendarViewController ()

@property NSArray *allDaysInMonth;
@property NSMutableArray *eventDays;
@property VRGCalendarView *calView;
@property NSArray *lists;
@property NSDate *currentMonth;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CustomNavBar;
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.view addSubview:calendar];
    newEvent = NO;
}

// refresh calendar if any change made
- (void)viewDidAppear:(BOOL)animated{
    if (newEvent) {
        NSLog(@"refresh");
        [self calendarView:self.calView switchedToMonth:self.currentMonth targetHeight:0.0f animated:YES];
        newEvent = NO;
    }
}

#pragma mark - calendar select month

// get date which have event
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSDate *)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    self.currentMonth = month;
    NSLog(@"current date %@", self.currentMonth);
    id tempDate = month;
    self.allDaysInMonth = @[];
    NSString *post = [[NSString alloc]initWithFormat:@"yearMonth=%d/%d", [tempDate year], [tempDate month]];
    self.calView = calendarView;
    [SVProgressHUD showWithStatus:@"加载中"];
    [NSThread detachNewThreadSelector:@selector(logToServer:) toTarget:self withObject:post];
}

- (void)logToServer:(NSString *)post{
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:[main_url stringByAppendingFormat:@"ad03/ad0301/index"]];
        NSDictionary *tempDic = [AppDelegate connectToServer:post :url];
        if (tempDic != nil) {
            NSInteger success = [(NSNumber *) [tempDic objectForKey:@"success"] integerValue];
            if (success == 1){
                self.allDaysInMonth =  [tempDic objectForKey:@"message"];
                [SVProgressHUD dismiss];
            }
            else{
                [SVProgressHUD show];
                [SVProgressHUD dismissWithError:@"请重新登陆"];
            }
        }
        [self performSelectorOnMainThread:@selector(addMark) withObject:nil waitUntilDone:NO];
    }
}

// add underline of the day which have event
- (void)addMark{
    self.eventDays = [[NSMutableArray alloc]init];
    int days = 0;    
    for (NSString *numOfEvents in self.allDaysInMonth){
        days ++;
        int events = [numOfEvents intValue];
        if (events != 0) {
            [self.eventDays addObject:[NSNumber numberWithInt:days]];
        }
    }
    NSLog(@"event days %@", self.eventDays);
    
    [self.calView markDates:self.eventDays];
}

#pragma mark - select day

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd MMMM"];
    NSLog(@"Selected date = %@",[dateFormatter stringFromDate:date]);
    
    id tempTime = date;
    selectedDate = [NSString stringWithFormat:@"%d/%d/%d", [tempTime year], [tempTime month], [tempTime day]];

    if (![self.eventDays containsObject:[NSNumber numberWithInt:[tempTime day]]]){
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"该日没有日程"];
        self.lists = [[NSArray alloc]init];
        [self performSegueWithIdentifier:@"scheduleList" sender:self];
    }
    else{
        [SVProgressHUD showWithStatus:@"载入中"];
        NSString *post = [@"cond.cond.endTime=" stringByAppendingString:selectedDate];
        [NSThread detachNewThreadSelector:@selector(getEvent:) toTarget:self withObject:post];
    }
}

// get all event for the day user selected
- (void)getEvent:(NSString *)post{
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:[main_url stringByAppendingFormat:@"ad03/ad0301/search"]];
        NSDictionary *tempDic = [AppDelegate connectToServer:post :url];
        if (tempDic != nil) {
            NSInteger success = [(NSNumber *) [tempDic objectForKey:@"success"] integerValue];
            if (success == 1){
                self.lists = [tempDic objectForKey:@"message"];
                NSLog(@"%@", tempDic);
                [self performSegueWithIdentifier:@"scheduleList" sender:self];
                [SVProgressHUD dismiss];
            }
            else{
                [SVProgressHUD show];
                [SVProgressHUD dismissWithError:@"请重新登陆"];
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scheduleList"]) {
        ScheduleListViewController *dvc = segue.destinationViewController;
        dvc.sendLists = self.lists;
        return;
    }
}
@end
