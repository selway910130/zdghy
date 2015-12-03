//
//  ContactDetailViewController.h
//  test
//
//  Created by selway on 2013-06-06.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"


@interface ContactDetailViewController : UIViewController <MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>{
    
}

@property (strong, nonatomic) NSString *sendName;
@property (strong, nonatomic) NSString *sendPosition;
@property (strong, nonatomic) NSString *sendDepartment;
@property (strong, nonatomic) NSString *sendGroup;
@property (strong, nonatomic) NSString *sendOffice_line;
@property (strong, nonatomic) NSString *sendShort_num;
@property (strong, nonatomic) NSString *sendPhone;
@property (strong, nonatomic) NSString *sendEmail;
@property (strong, nonatomic) NSString *sendPlace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;

-(IBAction)SendASMS:(id)sender;

-(IBAction)MakePhoneCall:(id)sender;
- (IBAction)backButton:(id)sender;

@end
