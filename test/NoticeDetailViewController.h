//
//  NoticeDetailViewController.h
//  test
//
//  Created by selway on 2013-06-04.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *notice_title;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_title;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;

@property (strong, nonatomic) NSString *sendTitle;
@property (strong, nonatomic) NSString *sendAuthor;
@property (strong, nonatomic) NSString *sendDate;
@property (strong, nonatomic) NSString *sendType;
@property (strong, nonatomic) NSString *sendContent;
@property (strong, nonatomic) NSString *sendState;
@property (strong, nonatomic) NSString *sendId;
@property (strong, nonatomic) NSString *sendReplySpecifyNotice;

@property (strong, nonatomic) NSString *sendTargetPerson;
@property (strong, nonatomic) NSString *sendTargetState;
@property (strong, nonatomic) NSString *sendTargetNote;
@property (strong, nonatomic) NSString *sendReplyNote;

@property NSRange selectedRange;
- (IBAction)backButton:(id)sender;

@end
