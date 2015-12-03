//
//  ContractDetailViewController.m
//  test
//
//  Created by selway on 2013-07-16.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ContractDetail2ViewController.h"
#import "CustomTwoLabelsCell.h"

@interface ContractDetail2ViewController ()

@property NSArray *lstOfTitles;
@property NSArray *lstOfContents;

@end

@implementation ContractDetail2ViewController

@synthesize scrollView;
@synthesize contractTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    self.lstOfTitles = @[@"招投标编号", @"招投标分类", @"状态", @"部门", @"经办人", @"经办人联系电话", @"项目类型", @"项目规模", @"招标方", @"报名时间", @"项目负责人", @"招投标结果"];
    self.contractTitle.text = self.send_projectName;

    //NSString *new_area = [self.send_area stringByAppendingString:self.send_areaUnit];
    NSString *new_date = [[NSString alloc]init];
    if (![self.send_signUpTimeIntervalBegin isEqualToString:@""] && ![self.send_signUpTimeIntervalEnd isEqualToString:@""]) {
        new_date = [self.send_signUpTimeIntervalBegin stringByAppendingFormat:@" - %@", self.send_signUpTimeIntervalEnd];
    }
    else new_date = [self.send_signUpTimeIntervalBegin stringByAppendingString:self.send_signUpTimeIntervalEnd];
    
    //NSString *new_money = [self.send_contractMoney stringByAppendingString:@"（万元）"];
    
    self.lstOfContents = @[self.send_tenderId, self.send_tenderTypeName, self.send_tenderStateName, self.send_department, self.send_operator, self.send_operatorTelephone, self.send_projectTypeName, self.send_projectScale, self.send_tendering, new_date, self.send_tenderResponsiblePerson, self.send_tenderResult];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    CGSize titleLabelSize = [self.send_projectName sizeWithFont:self.contractTitle.font
                                              constrainedToSize:maximumLabelSize
                                                  lineBreakMode:self.contractTitle.lineBreakMode];
    if (titleLabelSize.height > 21.0f) {
        [self.contractTitle setFrame:CGRectMake(20, 1, self.contractTitle.frame.size.width, self.contractTitle.frame.size.height)];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *forCal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 178, 21)];
    CGSize maximumLabelSize = CGSizeMake(178,99999);
    CGSize titleLabelSize = [[self.lstOfContents objectAtIndex:indexPath.row] sizeWithFont:forCal.font
                                                                         constrainedToSize:maximumLabelSize
                                                                             lineBreakMode:forCal.lineBreakMode];
    if ([[self.lstOfTitles objectAtIndex:indexPath.row] isEqualToString:@"经办人联系电话"]) {
        return (56 > titleLabelSize.height ? 56:titleLabelSize.height);
    }
    else{
        if (titleLabelSize.height == 0) {
            return 35;
        }
        return titleLabelSize.height + 14;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show normal result and searched result, include title and date.
    
    static NSString *CellIdentifier = @"Cell";
    CustomTwoLabelsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.title.text = [self.lstOfTitles objectAtIndex:indexPath.row];
    cell.content.text = [self.lstOfContents objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setContractTitle:nil];
    [super viewDidUnload];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
