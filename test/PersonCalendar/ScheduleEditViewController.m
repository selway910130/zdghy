//
//  ScheduleEditViewController.m
//  test
//
//  Created by selway on 2013-07-26.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ScheduleEditViewController.h"
#import "AppDelegate.h"
#import "labelTextViewCell.h"
#import "labelButtonCell.h"
#import "labelCheckBoxCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "CustomTwoLabelsCell.h"
#import "ScheduleListViewController.h"
#import "CalendarViewController.h"

@interface ScheduleEditViewController ()

@property UIButton *checkBox1;
@property UIButton *checkBox2;
@property UIDatePicker *datePicker;

@property NSMutableArray *selectMenuList;

@property UITextView *titleTextView;
@property UITextView *contentTextView;
@property UITextView *remarkTextView;

@property BOOL check1;
@property BOOL check2;
@property BOOL keyboardOpen;
@property BOOL datePickerHidden;

@property CGFloat height1;
@property CGFloat height2;

@property int tempInt;
@property int addRow;

@property NSArray *lstOfTitles;
@property NSArray *lstOfContents;

@property NSDate *startDate;
@property NSDate *endDate;
@property NSDateFormatter *dateFormat;

@property NSString *currentDatePicker;

@property NSURL *url;

@end

@implementation ScheduleEditViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    // default some variable
    self.url = [NSURL URLWithString:[main_url stringByAppendingString:@"oa03/oa0301/save"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 218)];
    [self.datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.parentViewController.parentViewController.view addSubview:self.datePicker];
    self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    self.keyboardOpen = NO;
    self.selectMenuList = [[NSMutableArray alloc]init];
    self.currentDatePicker = @"";
    self.tempInt = 0;
    self.datePickerHidden = YES;
    self.datePicker.hidden = self.datePickerHidden;
    self.addRow = [self.sendShowGroup intValue];

    // if show group, there will be one more line, the height will add one cell height
    if (self.addRow == 0) {
        self.height1 = 0.0;
        self.height2 = 0.0;
    }
    else{
        self.height1 = 35;
        self.height2 = 35;
    }

    // if no starttime and endtime, set datepicker to current date
    if ([self.sendStartTime isEqualToString:@""] && [self.sendEndTime isEqualToString:@""]) {
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
    }
    else if ([self.sendStartTime isEqualToString:@""]) {
        self.startDate = [NSDate date];
        self.sendEndTime = [self.sendEndTime substringToIndex:[self.sendEndTime length] - 3];
        self.endDate = [self.dateFormat dateFromString:self.sendEndTime];
    }
    else if ([self.sendEndTime isEqualToString:@""]) {
        self.endDate = [NSDate date];
        self.sendStartTime = [self.sendStartTime substringToIndex:[self.sendStartTime length] - 3];
        self.startDate = [self.dateFormat dateFromString:self.sendStartTime];
    }
    else{
        self.sendStartTime = [self.sendStartTime substringToIndex:[self.sendStartTime length] - 3];
        self.sendEndTime = [self.sendEndTime substringToIndex:[self.sendEndTime length] - 3];
        self.startDate = [self.dateFormat dateFromString:self.sendStartTime];
        self.endDate = [self.dateFormat dateFromString:self.sendEndTime];
    }
    
    // set check box for message and mail
    NSArray *remindMode = [self.sendRemindMode componentsSeparatedByString:@","];
    if ([remindMode count] == 0) {
        self.check1 = NO;
        self.check2 = NO;
    }
    else if ([remindMode count] == 2){
        self.check1 = YES;
        self.check2 = YES;
    }
    else if ([remindMode[0] isEqualToString:@"短信"]){
        self.check1 = YES;
        self.check2 = NO;
    }
    else if ([remindMode[0] isEqualToString:@"邮件"]){
        self.check1 = NO;
        self.check2 = YES;
    }
    
    // show group = 1, will one more cell for 安排人员
    if (self.addRow == 0) {
        self.lstOfTitles = @[@"日程标题", @"日程内容", @"开始时间", @"结束时间", @"日程级别", @"公开范围", @"提醒方式", @"提醒时间", @"备注", @"保存"];
    }
    else{
        self.lstOfTitles = @[@"安排人员", @"日程标题", @"日程内容", @"开始时间", @"结束时间", @"日程级别", @"公开范围", @"提醒方式", @"提醒时间", @"备注", @"保存"];
    }
    
    // gesture to hide keyboard and date picker
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:singleTap];
}

// enlarge the view so that when move the view, there will no empty space between view and keyboard
- (void)viewDidAppear:(BOOL)animated{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 49)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize maximumLabelSize = CGSizeMake(178,99999);
    // 通知人员 cell
    if (self.addRow == 1) {
        if (indexPath.row == 0) {
            return 35;
        }
    }
    // first textview cell
    if (indexPath.row == 0 + self.addRow) {
        CGSize titleLabelSize = [self.sendScheduleName sizeWithFont:[UIFont systemFontOfSize:17]
                                               constrainedToSize:maximumLabelSize];
        if (titleLabelSize.height == 0){
            self.height1 = self.height1 + 59;
            self.height2 = self.height2 + 59;
            return 59;
        }
        self.height1 = self.height1 + titleLabelSize.height + 38;
        self.height2 = self.height2 + titleLabelSize.height + 38;
        return titleLabelSize.height + 38;
    }
    // second textview cell
    else if (indexPath.row == 1 + self.addRow) {
        CGSize titleLabelSize = [self.sendScheduleContent sizeWithFont:[UIFont systemFontOfSize:17]
                                                  constrainedToSize:maximumLabelSize];
        if (titleLabelSize.height == 0){
            self.height2 = self.height2 + 59;
            return 59;
        }
        self.height2 = self.height2 + titleLabelSize.height + 38;
        return titleLabelSize.height + 38;
    }
    // third textview cell
    else if (indexPath.row == 8 + self.addRow) {
        CGSize titleLabelSize = [self.sendRemark sizeWithFont:[UIFont systemFontOfSize:17]
                                                  constrainedToSize:maximumLabelSize];
        if (titleLabelSize.height == 0) return 59;
        return titleLabelSize.height + 38;
    }
    else if (indexPath.row == 9 + self.addRow) {
        return 133;
    }
    // button cell and checkbox cell have same height
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // text view
    if (self.addRow == 1) {
        // 通知人员 cell
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"twoLabels";
            CustomTwoLabelsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.title.text = @"安排人员";
            cell.content.text = self.sendPersonNames;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    // cell for textview
    if (indexPath.row == 0 + self.addRow || indexPath.row == 1 + self.addRow || indexPath.row == 8 + self.addRow) { 
        static NSString *CellIdentifier = @"labelTextView";
        labelTextViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [self.lstOfTitles objectAtIndex:indexPath.row];
        cell.textView.layer.cornerRadius = 5;
        cell.textView.clipsToBounds = YES;

        cell.textView.delegate = self;
        cell.textView.tag = indexPath.row - self.addRow;
        
        if (indexPath.row == 0 + self.addRow) {
            cell.textView.layer.borderWidth = 1.0f;
            cell.textView.layer.borderColor = [[UIColor orangeColor] CGColor];
            cell.textView.text = self.sendScheduleName;
        }
        else if (indexPath.row == 1 + self.addRow) {
            cell.textView.layer.borderWidth = 1.0f;
            cell.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            cell.textView.text = self.sendScheduleContent;
        }
        else if (indexPath.row == 8 + self.addRow) {
            cell.textView.layer.borderWidth = 1.0f;
            cell.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            cell.textView.text = self.sendRemark;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // check box
    else if (indexPath.row == 6 + self.addRow){
        static NSString *CellIdentifier = @"labelCheckBox";
        labelCheckBoxCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [self.lstOfTitles objectAtIndex:indexPath.row];
        self.checkBox1 = cell.check1;
        self.checkBox2 = cell.check2;
        
        if (self.check1 && self.check2) {
            [self.checkBox1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
            [self.checkBox2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        }
        else if (self.check1) {
            [self.checkBox1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        }
        else if (self.check2) {
            [self.checkBox2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        }
        
        [self.checkBox1 addTarget:self action:@selector(checkBox1Button) forControlEvents:UIControlEventTouchUpInside];
        [self.checkBox2 addTarget:self action:@selector(checkBox2Button) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;    
    }
    // grey button
    else if (indexPath.row == 7 + self.addRow){
        static NSString *CellIdentifier = @"labelButton";
        labelButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [self.lstOfTitles objectAtIndex:indexPath.row];
        cell.button.tag = indexPath.row - self.addRow;
        cell.button.titleLabel.font = [UIFont systemFontOfSize:16];
        [cell.button setTitle:[@" " stringByAppendingString:self.sendRemindTimeName] forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(selectMenu:) forControlEvents:UIControlEventTouchUpInside];
        if (![self.selectMenuList containsObject:cell.button]) {
            [self.selectMenuList addObject:cell.button];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // save button
    else if (indexPath.row == 9 + self.addRow){
        static NSString *CellIdentifier = @"labelButton3";
        labelButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.button addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{ // orange button
        static NSString *CellIdentifier = @"labelButton2";
        labelButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [self.lstOfTitles objectAtIndex:indexPath.row];
        cell.button.tag = indexPath.row - self.addRow;
        cell.button.titleLabel.font = [UIFont systemFontOfSize:16];
        if (indexPath.row == 2 + self.addRow) {
            [cell.button setTitle:[@" " stringByAppendingString:self.sendStartTime] forState:UIControlStateNormal];
        }
        else if (indexPath.row == 3 + self.addRow) {
            [cell.button setTitle:[@" " stringByAppendingString:self.sendEndTime] forState:UIControlStateNormal];
        }
        else if (indexPath.row == 4 + self.addRow) {
            [cell.button setTitle:[@" " stringByAppendingString:self.sendScheduleLevelName] forState:UIControlStateNormal];
        }
        else if (indexPath.row == 5 + self.addRow) {
            [cell.button setTitle:[@" " stringByAppendingString:self.sendScheduleRangeName] forState:UIControlStateNormal];
        }
        
        [cell.button addTarget:self action:@selector(selectMenu:) forControlEvents:UIControlEventTouchUpInside];
        if (![self.selectMenuList containsObject:cell.button]) {
            [self.selectMenuList addObject:cell.button];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - textview delegate

// move view when edit in textview
-(void)textViewDidChangeSelection:(UITextView *)textView{
    self.tempInt ++;
    if (self.tempInt%2 == 0 || self.keyboardOpen) {
        if (self.keyboardOpen) {
            self.tempInt ++;
        }
        self.keyboardOpen = YES;

        CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
        NSLog(@"position of cursor %f", cursorPosition.x);
        if (textView.tag == 0) {
            [self moveView:44 + 10 + cursorPosition.y + 21 - self.tableView.contentOffset.y];
        }
        else if (textView.tag == 1) {
            NSLog(@"upper cell height %f", self.height1);
            [self moveView:44 + self.height1 + 10 + cursorPosition.y + 21 - self.tableView.contentOffset.y];
        }
        else if (textView.tag == 8) {
            [self moveView:44 + self.height2 + 300 + 10 + cursorPosition.y + 21 - self.tableView.contentOffset.y];
        }
    }
}

// save content user just typed
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 0) {
        self.sendScheduleName = textView.text;
    }
    else if (textView.tag == 1) {
        self.sendScheduleContent = textView.text;
    }
    else if (textView.tag == 8) {
        self.sendRemark = textView.text;
    }
}

#pragma mark - check box

- (void)checkBox1Button{
    if (self.check1) {
        [self.checkBox1 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        self.check1 = NO;
    }
    else{
        [self.checkBox1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        self.check1 = YES;
    }
}

- (void)checkBox2Button{
    if (self.check2) {
        [self.checkBox2 setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        self.check2 = NO;
    }
    else{
        [self.checkBox2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        self.check2 = YES;
    }
}

#pragma mark - button on cell

- (void)selectMenu:(id)sender {
    // 3 buttons used for select menu
    if ([sender tag] == 4) {
        [self creatSelectMenu:self.sendScheduleLevelList :self.sendScheduleLevel :@"level"];
    }
    else if ([sender tag] == 5){
        [self creatSelectMenu:self.sendScheduleRangeList :self.sendScheduleRange :@"range"];
    }
    else if ([sender tag] == 7){
        [self creatSelectMenu:self.sendRemindTimeList :self.sendRemindTime :@"reminder"];
    }
    // 2 buttons used for date picker
    else if ([sender tag] == 2){
        if ([self.currentDatePicker isEqualToString:@""]) {
            self.datePickerHidden = NO;
            self.datePicker.hidden = self.datePickerHidden;
            [self datePickerAnimant:216];
            [self moveView:44 + self.height2 + 50 - self.tableView.contentOffset.y];
            [self.datePicker setDate:self.startDate];
            self.currentDatePicker = @"startTime";
        }
        else if ([self.currentDatePicker isEqualToString:@"startTime"]){
            NSString *stringFromDate = [self.dateFormat stringFromDate:self.datePicker.date];
            UIButton *tempButton = [self.selectMenuList objectAtIndex:0];
            [tempButton setTitle:[@" " stringByAppendingString:stringFromDate] forState:UIControlStateNormal];
            self.sendStartTime = stringFromDate;
            self.startDate = self.datePicker.date;
            self.currentDatePicker = @"";
            self.datePickerHidden = YES;
            [self datePickerAnimant:0];
            [self moveBackView];
            [self performSelector:@selector(hidePicker) withObject:nil afterDelay:0.30f];
        }
        else{
            self.currentDatePicker = @"startTime";
            [self.datePicker setDate:self.startDate];
            [self moveView:44 + self.height2 + 50 - self.tableView.contentOffset.y];
        }
    }
    else if ([sender tag] == 3){
        if ([self.currentDatePicker isEqualToString:@""]) {
            self.datePickerHidden = NO;
            self.datePicker.hidden = self.datePickerHidden;
            [self datePickerAnimant:216];
            [self moveView:44 + self.height2 + 50 + 50 - self.tableView.contentOffset.y];
            [self.datePicker setDate:self.endDate];
            self.currentDatePicker = @"endTime";
        }
        else if ([self.currentDatePicker isEqualToString:@"endTime"]){
            NSString *stringFromDate = [self.dateFormat stringFromDate:self.datePicker.date];
            UIButton *tempButton = [self.selectMenuList objectAtIndex:1];
            [tempButton setTitle:[@" " stringByAppendingString:stringFromDate] forState:UIControlStateNormal];
            self.sendEndTime = stringFromDate;
            self.endDate = self.datePicker.date;
            self.currentDatePicker = @"";
            self.datePickerHidden = YES;
            [self datePickerAnimant:0];
            [self moveBackView];
            [self performSelector:@selector(hidePicker) withObject:nil afterDelay:0.30f];
        }
        else{
            self.currentDatePicker = @"endTime";
            [self.datePicker setDate:self.endDate];
            [self moveView:44 + self.height2 + 50 + 50 - self.tableView.contentOffset.y];
        }
    }
}

#pragma mark - date picker

// show date pick like keyboard
- (void)datePickerAnimant:(CGFloat)y{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0, self.parentViewController.parentViewController.view.frame.size.height - y, 320, 216);
    self.datePicker.frame = rect;
    [UIView commitAnimations];
}

- (void)hidePicker{
    self.datePicker.hidden = YES;
}

// when the date in datepicker is changed, update date to button
- (void)dateIsChanged:(id)sender{
    NSLog(@"current date picker %@", self.currentDatePicker);
    NSString *stringFromDate = [self.dateFormat stringFromDate:self.datePicker.date];
    if ([self.currentDatePicker isEqualToString:@"startTime"]) {
        UIButton *tempButton = [self.selectMenuList objectAtIndex:0];
        [tempButton setTitle:[@" " stringByAppendingString:stringFromDate] forState:UIControlStateNormal];
        self.sendStartTime = stringFromDate;
        self.startDate = self.datePicker.date;
    }
    else if ([self.currentDatePicker isEqualToString:@"endTime"]){
        UIButton *tempButton = [self.selectMenuList objectAtIndex:1];
        [tempButton setTitle:[@" " stringByAppendingString:stringFromDate] forState:UIControlStateNormal];
        self.sendEndTime = stringFromDate;
        self.endDate = self.datePicker.date;
    }
}

#pragma mark - select menu

- (void)creatSelectMenu:(NSArray *)lst :(NSString *)key :(NSString *)typeOfButton{
    UIViewController *rootController = self.parentViewController.parentViewController;
    UIView *full = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    full.backgroundColor = [UIColor blackColor];
    full.alpha = 0.5f;
    full.tag = 1;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured2:)];
    [full addGestureRecognizer:singleTap];
    [rootController.view addSubview:full];
    selectMenu = [[SelectMenu alloc] initWithItems:lst :key :typeOfButton];
    selectMenu.SelectMenuDelegate = self;
    [selectMenu show];
    [rootController.view addSubview:selectMenu];
}

// dismiss select menu
- (void)singleTapGestureCaptured2:(UITapGestureRecognizer *)gesture
{
    NSLog(@"disappear");
    [selectMenu dismiss];
}

- (void)dismissDarkenView{
    for (UIView *subview in [self.parentViewController.parentViewController.view subviews]) {
        if (subview.tag == 1) {
            [subview removeFromSuperview];
        }
    }
}

- (void)selectedItem:(NSDictionary *)item :(NSString *)typeOfButton{
    UIButton *tempButton;
    if ([typeOfButton isEqual:@"level"]) {
        self.sendScheduleLevel = [item objectForKey:@"key"];
        tempButton = self.selectMenuList[2];
        [tempButton setTitle:[@" " stringByAppendingString: [item objectForKey:@"value"]] forState:UIControlStateNormal];
        self.sendScheduleLevelName = [item objectForKey:@"value"];
    }
    else if ([typeOfButton isEqual:@"range"]) {
        self.sendScheduleRange = [item objectForKey:@"key"];
        tempButton = self.selectMenuList[3];
        [tempButton setTitle:[@" " stringByAppendingString: [item objectForKey:@"value"]] forState:UIControlStateNormal];
        self.sendScheduleRangeName = [item objectForKey:@"value"];
    }
    else if ([typeOfButton isEqual:@"reminder"]) {
        self.sendRemindTime = [item objectForKey:@"key"];
        tempButton = self.selectMenuList[4];
        [tempButton setTitle:[@" " stringByAppendingString: [item objectForKey:@"value"]] forState:UIControlStateNormal];
        self.sendRemindTimeName = [item objectForKey:@"value"];
    }
}

#pragma mark - hide keyboard

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (self.keyboardOpen) {
        if (self.addRow == 0) {
            self.height1 = 0.0;
            self.height2 = 0.0;
        }
        else{
            self.height1 = 35;
            self.height2 = 35;
        }

        [self.tableView reloadData];
        self.keyboardOpen = NO;
        [self moveBackView];
    }
    if (!self.datePickerHidden) {
        [self datePickerAnimant:0];
        [self performSelector:@selector(hidePicker) withObject:nil afterDelay:0.30f];    
        self.currentDatePicker = @"";
        self.datePickerHidden = YES;
        [self moveBackView];        
    }
}

#pragma mark - move view

- (void)moveView:(int)yCoordinate{
    int offset = 216 - (self.view.frame.size.height - yCoordinate) + 44;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset, width, height);
        self.view.frame = rect;
    }
    else{
        CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

- (void)moveBackView{    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma mark - save data;

- (void)saveData{
    [SVProgressHUD showWithStatus:@"上传中"];
    NSString *reminder = [[NSString alloc]init];
    if (self.check1 && self.check2) {
        reminder = @"短信,邮件";
    }
    else if (self.check1){
        reminder = @"短信";
    }
    else if (self.check2){
        reminder = @"邮件";
    }
    else{
        reminder = @"";
    }
    NSLog(@"\n日程ID %@\n发送日期 %@\n日程标题 %@\n日程内容 %@\n开始时间 %@\n结束时间 %@\n日程级别 %@\n公开范围 %@\n提醒方式 %@\n提醒时间 %@\n备注 %@", self.sendScheduleId, selectedDate,self.sendScheduleName, self.sendScheduleContent, self.sendStartTime, self.sendEndTime, self.sendScheduleLevel, self.sendScheduleRange, reminder, self.sendRemindTime, self.sendRemark);
    NSLog(@"create user %@", self.sendCreateUser);
    if ([self.sendCreateUser isEqualToString:@""]) {
        if ([self.sendScheduleName isEqualToString:@""] || [self.sendStartTime isEqualToString:@""] || [self.sendEndTime isEqualToString:@""] || [self.sendScheduleLevel isEqualToString:@""] || [self.sendScheduleRange isEqualToString:@""]) {
            [SVProgressHUD dismissWithError:@"请填写橙色部分内容"];
        }
        else if ([reminder isEqualToString:@""] && ![self.sendRemindTime isEqualToString:@""]){
            [SVProgressHUD dismissWithError:@"请选择提醒方式"];
        }
        else if (![reminder isEqualToString:@""] && [self.sendRemindTime isEqualToString:@""]){
            [SVProgressHUD dismissWithError:@"请选择提醒时间"];
        }
        else{
            NSString *post = [NSString stringWithFormat:@"schedule.thingTitle=%@&schedule.thingContent=%@&schedule.startTime=%@&schedule.endTime=%@&schedule.level=%@&schedule.thingRange=%@&schedule.remindMode=%@&schedule.remindTime=%@&schedule.note=%@&schedule.scheduleId=%@", self.sendScheduleName, self.sendScheduleContent, self.sendStartTime, self.sendEndTime, self.sendScheduleLevel, self.sendScheduleRange, reminder, self.sendRemindTime, self.sendRemark, self.sendScheduleId];
            [NSThread detachNewThreadSelector:@selector(uploadDate:) toTarget:self withObject:post];
        }
    }
    else{
        if ([self.sendScheduleName isEqualToString:@""] || [self.sendStartTime isEqualToString:@""] || [self.sendEndTime isEqualToString:@""] || [self.sendScheduleLevel isEqualToString:@""] || [self.sendScheduleRange isEqualToString:@""]) {
            [SVProgressHUD dismissWithError:@"请填写橙色部分内容"];
        }
        else if ([reminder isEqualToString:@""] && ![self.sendRemindTime isEqualToString:@""]){
            [SVProgressHUD dismissWithError:@"请选择提醒方式"];
        }
        else if (![reminder isEqualToString:@""] && [self.sendRemindTime isEqualToString:@""]){
            [SVProgressHUD dismissWithError:@"请选择提醒时间"];
        }
        else{
            NSString *post = [NSString stringWithFormat:@"schedule.thingTitle=%@&schedule.thingContent=%@&schedule.startTime=%@&schedule.endTime=%@&schedule.level=%@&schedule.thingRange=%@&schedule.remindMode=%@&schedule.remindTime=%@&schedule.note=%@&schedule.scheduleId=%@&schedule.createUser=%@", self.sendScheduleName, self.sendScheduleContent, self.sendStartTime, self.sendEndTime, self.sendScheduleLevel, self.sendScheduleRange, reminder, self.sendRemindTime, self.sendRemark, self.sendScheduleId, self.sendCreateUser];
            [NSThread detachNewThreadSelector:@selector(uploadDate:) toTarget:self withObject:post];
        }
    }
}

- (void)uploadDate:(NSString *)post{
    @autoreleasepool {
        NSLog(@"upload message");
        NSDictionary *tempDic = [AppDelegate connectToServer:post :self.url];
        NSInteger success = [(NSNumber *) [tempDic objectForKey:@"success"] integerValue];
        if (success == 1) {
            [SVProgressHUD dismissWithSuccess:@"上传成功"];
            needRefresh = YES;
            newEvent = YES;
            [self.navigationController popViewControllerAnimated:YES]; // go back
        }
        else{
            [SVProgressHUD dismissWithError:@"上传错误"];
        }
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
