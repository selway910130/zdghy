//
//  CaseDetailViewController.h
//  test
//
//  Created by selway on 2013-07-03.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {}

@property (weak, nonatomic) IBOutlet UILabel *case_title;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_title;

@property (strong, nonatomic) NSString *sendTitle;
@property (strong, nonatomic) NSString *sendType;
@property (strong, nonatomic) NSString *sendContent;
@property (strong, nonatomic) NSArray *sendImageLst;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButton:(id)sender;

@end
