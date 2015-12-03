//
//  ContractDetail3ViewController.m
//  test
//
//  Created by selway on 2013-07-16.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ContractDetail3ViewController.h"
#import "CustomTwoLabelsCell.h"

@interface ContractDetail3ViewController ()

@property NSArray *lstOfTitles;
@property NSArray *lstOfContents;

@end

@implementation ContractDetail3ViewController

@synthesize scrollView;
@synthesize contractTitle;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    self.lstOfTitles = @[@"建筑、园林编号", @"合同分类", @"状态", @"项目类型", @"项目规模", @"委托方", @"起止日期", @"部门", @"项目责任人", @"投资额", @"合同金额"];
    self.contractTitle.text = self.send_projectName;
    NSString *new_date = [[NSString alloc]init];
    if (![self.send_contractBeginDate isEqualToString:@""] && ![self.send_contractEndDate isEqualToString:@""]) {
        new_date = [self.send_contractBeginDate stringByAppendingFormat:@" - %@", self.send_contractEndDate];
    }
    else new_date = [self.send_contractBeginDate stringByAppendingString:self.send_contractEndDate];
    
    NSString *new_money = [self.send_contractMoney stringByAppendingString:@"（万元）"];
    NSString *new_money2 = [self.send_investedAmount stringByAppendingString:@"（万元）"];
    
    self.lstOfContents = @[self.send_buildingGardensContractId, self.send_contractTypeName, self.send_contractConName,self.send_projectTypeName, self.send_projectScale, self.send_clientName, new_date, self.send_department, self.send_projectLeadingOfficial, new_money2, new_money];
    NSLog(@"number of titles and contents %d, %d", [self.lstOfTitles count], [self.lstOfContents count]);
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
    CGSize maximumLabelSize = CGSizeMake(195,99999);
    CGSize titleLabelSize = [[self.lstOfContents objectAtIndex:indexPath.row] sizeWithFont:[UIFont systemFontOfSize:17]
                                                                         constrainedToSize:maximumLabelSize];
    if ([[self.lstOfTitles objectAtIndex:indexPath.row] isEqualToString:@"建筑、园林编号"] || [[self.lstOfTitles objectAtIndex:indexPath.row] isEqualToString:@"项目责任人"]) {
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
