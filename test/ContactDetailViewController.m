//
//  ContactDetailViewController.m
//  test
//
//  Created by selway on 2013-06-06.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "CustomTwoLabelsCell.h"

@interface ContactDetailViewController ()

@property NSArray *lstOfTitles;
@property NSArray *lstOfContents;

@end


@implementation ContactDetailViewController

@synthesize tableView;
@synthesize titleBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.lstOfTitles = @[@"姓名", @"职位", @"部门", @"分组", @"办公电话", @"内线电话", @"手机", @"电子邮件", @"办公场所"];
    self.lstOfContents = @[self.sendName, self.sendPosition, self.sendDepartment, self.sendGroup, self.sendOffice_line, self.sendShort_num, self.sendPhone, self.sendEmail, self.sendPlace];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lstOfTitles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CustomTwoLabelsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = [self.lstOfTitles objectAtIndex:indexPath.row];
    cell.content.text = [self.lstOfContents objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Send Message

- (IBAction)SendASMS:(id)sender
{
    MFMessageComposeViewController *textComposer = [[MFMessageComposeViewController alloc] init];
    [textComposer setMessageComposeDelegate:self];
    if ([MFMessageComposeViewController canSendText])
    {
        [textComposer setRecipients:[NSArray arrayWithObject:self.sendPhone]];
        [textComposer setBody:@""];
        [self presentViewController:textComposer animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"Can't Open Text");
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Make a phone call

-(IBAction)MakePhoneCall:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.sendPhone]];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
