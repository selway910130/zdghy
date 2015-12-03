//
//  NoticeDetailViewController.m
//  test
//
//  Created by selway on 2013-06-04.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "CustomTwoLabelsCell.h"
#import "CustomLabelCell.h"
#import "ReplyCell.h"
#import <QuartzCore/QuartzCore.h>

@interface NoticeDetailViewController ()

@property NSString *msg;
@property UITextView *textView;
@property UIButton *reply;

@property NSArray *lstOfTitle;
@property NSArray *lstOfContent;
@property NSString *target;

@property CGFloat heightOfTextView;
@property CGFloat heightOfTable;
@property CGFloat heightOfCell;

@property CGFloat widthOfTextViewContent;

@property int tempInt;
@property BOOL keyboardOpen;
@property BOOL expanded;

@end

@implementation NoticeDetailViewController
@synthesize notice_title;
@synthesize tableView;
@synthesize scrollView_title;

@synthesize selectedRange;

@synthesize titleBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"/////////////////////////通知明细/////////////////////////");
    
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    self.widthOfTextViewContent = 180.0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.notice_title.text = self.sendTitle;
    self.heightOfTextView = 0.0;
    self.heightOfTable = 0.0;
    
    self.navigationItem.hidesBackButton = YES;
    
    self.keyboardOpen = NO;
    self.tempInt = 0;
    
    self.expanded = NO;
    self.keyboardOpen = NO;
    self.heightOfTable = 0;
    self.heightOfTextView = 0;
    self.tempInt = 0;
    
    // different view by different msg.
    if ([self.sendState isEqualToString:@""]) {
        if ([self.sendReplySpecifyNotice isEqualToString:@""]) {
            // 4 rows.
            self.lstOfTitle = @[@"发布者", @"发布时间", @"通知类型", @""];
            self.lstOfContent = @[self.sendAuthor, self.sendDate, self.sendType, self.sendContent];
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
        }
        else{
            // 5 rows with notice target
            if ([self.sendTargetState intValue] == 0) self.sendTargetState = @"未读";
            else self.sendTargetState = @"已读";
            
            if ([self.sendTargetNote isEqualToString:@""]) {
                self.target = [[NSString alloc]initWithFormat:@"%@ (%@)", self.sendTargetPerson, self.sendTargetState];
            }
            else self.target = [[NSString alloc]initWithFormat:@"%@ (%@，备注：%@)", self.sendTargetPerson, self.sendTargetState, self.sendTargetNote];
            self.lstOfTitle = @[@"发布者", @"发布时间", @"发布类型", @"", @"通知对象"];
            self.lstOfContent = @[self.sendAuthor, self.sendDate, self.sendType, self.sendContent, self.target];
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
        }
    }
    else{
        // 5 rows with reply textview and reply button
        self.lstOfTitle = @[@"发布者", @"发布时间", @"发布类型", @"", @"", @""];
        self.lstOfContent = @[self.sendAuthor, self.sendDate, self.sendType, self.sendContent, @"", @""]; // add textView and reply button.
    }
    
    
    CGSize maximumLabelSize = CGSizeMake(184,99999);
    CGSize titleLabelSize = [self.sendReplyNote sizeWithFont:[UIFont systemFontOfSize:17]
                                          constrainedToSize:maximumLabelSize];
    
    if (titleLabelSize.height == 0) {
        self.heightOfCell = 59;
    }
    else{
        self.heightOfCell = titleLabelSize.height + 38;
    }
        
    // tap gesture reconizer to hide the keyboard
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void) viewDidAppear:(BOOL)animated{ // change the position of title
    [super viewDidAppear:animated];
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 49)];
    self.expanded = YES;

    CGSize maximumLabelSize = CGSizeMake(280,9999);
    CGSize titleLabelSize = [self.sendTitle sizeWithFont:self.notice_title.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:self.notice_title.lineBreakMode];
    if (titleLabelSize.height > 21.0f) {
        [notice_title setFrame:CGRectMake(20, 1, notice_title.frame.size.width, notice_title.frame.size.height)];
    }
    
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, 200, self.heightOfCell - 22);
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}



#pragma mark - table view date source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lstOfTitle count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"height");
    // height of content cell
    if (indexPath.row == 3) {
        CGSize maximumLabelSize = CGSizeMake(280,99999);
        CGSize titleLabelSize = [self.sendContent sizeWithFont:[UIFont systemFontOfSize:17]
                                             constrainedToSize:maximumLabelSize];
        // use to move view
        if (titleLabelSize.height == 0) {
            self.heightOfTextView = self.heightOfTextView + 41;
            self.heightOfTable = self.heightOfTable + 41;
            return 41;
        }
        self.heightOfTextView = self.heightOfTextView + titleLabelSize.height + 20;
        self.heightOfTable = self.heightOfTable + titleLabelSize.height + 20;
        return titleLabelSize.height + 20;
    }
    else if (indexPath.row == 5){
        if (self.heightOfTable < self.view.frame.size.height - 44) {
            if (self.expanded) {
                if (self.view.frame.size.height - self.heightOfTable - 49 < 49) {
                    return 49;
                }
                return (self.view.frame.size.height - self.heightOfTable - 49);
            }
            return (self.view.frame.size.height - self.heightOfTable);
        }
        return 49;
    }
    else{
        // height of reply cell
        if (![self.sendState isEqualToString:@""] && indexPath.row == 4) {
            self.heightOfTable = self.heightOfTable + self.heightOfCell;
            return self.heightOfCell;
        }
        // height for normal cell & target cell
        CGSize maximumLabelSize = CGSizeMake(195,99999);
        CGSize titleLabelSize;
        if (![self.sendReplySpecifyNotice isEqualToString:@""] && indexPath.row == 4) { // height for target cell
            titleLabelSize = [self.target sizeWithFont:[UIFont systemFontOfSize:17]
                                     constrainedToSize:maximumLabelSize];
        }
        else titleLabelSize = [[self.lstOfContent objectAtIndex:indexPath.row] sizeWithFont:[UIFont systemFontOfSize:17]
                                                                          constrainedToSize:maximumLabelSize]; // height for normal cell
        
        self.heightOfTextView = self.heightOfTextView + titleLabelSize.height + 20;
        self.heightOfTable = self.heightOfTable + titleLabelSize.height + 20;
        return titleLabelSize.height + 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSLog(@"cell");
    if (indexPath.row != 3 && indexPath.row != 5) { // expect content cell
        if (indexPath.row == 4 && ![self.sendState isEqualToString:@""]) { // content for reply cell
            static NSString *CellIdentifier = @"Cell3";
            ReplyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            self.textView =  cell.replyText;
            self.textView.delegate = self;
            
            cell.replyText.text = self.sendReplyNote;
            
            self.reply = cell.replyButton;
            [self.reply addTarget:self action:@selector(responsebutton) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        // content for other cells
        static NSString *CellIdentifier = @"Cell";
        CustomTwoLabelsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = [self.lstOfTitle objectAtIndex:indexPath.row];
        cell.content.text = [self.lstOfContent objectAtIndex:indexPath.row];
        if ([cell.title.text isEqualToString:@"通知对象"]) { // if table have notice target, add target info.
            cell.content.text = self.target;
        }
        return cell;
    }
    else{
        // content cell which only have 1 label
        static NSString *CellIdentifier = @"Cell2";
        CustomLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.content.text = self.sendContent;
        return cell;
    }
}

#pragma mark - hide keyboard & update msg
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (self.keyboardOpen){
        [self.textView resignFirstResponder];
        [self moveBackView];
    }
}

// reply button to upload the message
- (void)responsebutton{
    [self moveBackView];
    [self.textView resignFirstResponder];
    self.msg= self.textView.text;
    if ([self.msg isEqualToString:@""]) {
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"请输入回复内容"];
    }
    else{
        [SVProgressHUD showWithStatus:@"上传中"];
        [NSThread detachNewThreadSelector:@selector(uploadRpy) toTarget:self withObject:nil];
    }
}

- (void)uploadRpy{
    @autoreleasepool {
        NSURL *url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad01/ad0101/saveNote"]];
        NSString *post = [[NSString alloc]initWithFormat:@"noticeTarget.noticeId=%@&noticeTarget.note=%@", self.sendId, self.msg];
        NSDictionary *responseOfNote = [AppDelegate connectToServer:post :url];
        if (responseOfNote != nil) {
            NSInteger success = [(NSNumber *) [responseOfNote objectForKey:@"success"] integerValue];
            if (success == 1){
                [SVProgressHUD dismissWithSuccess:@"上传成功"];
            }
            else{
                [SVProgressHUD dismissWithError:@"上传失败"];
            }
        }
    }
}

#pragma mark - move the screen to avoid block the textView

// when textView begin editing, move the view to avoid kayboard block screen
-(void)textViewDidChangeSelection:(UITextView *)textView{
    self.tempInt ++;
    if (self.tempInt%2 == 0 || self.keyboardOpen) {
        if (self.keyboardOpen) {
            self.tempInt ++;
        }
        self.keyboardOpen = YES;
        CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
        int offset;
        int yOfCursor = (self.heightOfTextView - tableView.contentOffset.y)+ 11 + cursorPosition.y - 8 + 44;
        NSLog(@"position of cursor %d", yOfCursor);
        offset = 216 - (self.view.frame.size.height - yOfCursor) + 70;
        
        NSLog(@"scrolled %f", cursorPosition.x);
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
}


// move back the view
- (void)moveBackView{
    self.keyboardOpen = NO;
    self.heightOfCell = self.textView.contentSize.height + 22;
    self.sendReplyNote = self.textView.text;
    self.heightOfTable = 0;
    self.heightOfTextView = 0;
    self.tempInt = 0;
    [self.tableView reloadData];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

