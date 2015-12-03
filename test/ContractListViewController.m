//
//  ContractListViewController.m
//  test
//
//  Created by selway on 2013-07-16.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ContractListViewController.h"
#import "ContractSearch_ViewController.h"
#import "ContractDetailViewController.h"
#import "ContractDetail2ViewController.h"
#import "ContractDetail3ViewController.h"
#import "CommonCustomCell.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

@interface ContractListViewController ()

@property (strong, nonatomic) NSArray *contracts;
@property NSInteger numOfContract;
@property NSDictionary *contractDetail;

@end

@implementation ContractListViewController {
    int pageOfData;
    BOOL networkProblem;
}

@synthesize lst;
@synthesize titleBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = contractType;
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textColor = [UIColor colorWithRed:(119/255.0) green:(72/255.0) blue:(34/255.0) alpha:1];
    title.frame = CGRectMake(0, 0, 320, 44);
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    self.titleBar.topItem.titleView = title;
    
	lst.delegate = self;
    lst.dataSource = self;
    
    networkProblem = NO;
    pageOfData = 1;
    if (_loadMoreFooterView == nil) {
		PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
		view.delegate = self;
		_loadMoreFooterView = view;
	}
    self.lst.tableFooterView = _loadMoreFooterView;

    NSLog(@"download %@", downloadDic);
    self.numOfContract = [[downloadDic objectForKey:@"contractCount"] intValue];
    self.contracts = [downloadDic objectForKey:@"contractList"];
    if (self.numOfContract > [self.contracts count]) {
        _allLoaded = NO;
    }
    else _allLoaded = YES;
    
    [self doneLoadingTableViewData];
}

- (void)viewDidUnload {
    [self setLst:nil];
    [self setTitleBar:nil];
    [super viewDidUnload];
}

- (void)loadingData{
    NSURL *url = [[NSURL alloc]init];
    if ([contractType isEqualToString:@"规划合同"]) {
        url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0601/search"]];
    }
    else if ([contractType isEqualToString:@"招投标"]) {
        url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0602/search"]];
    }
    else{
        url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0603/search"]];
    }
    NSString *new_post = [post stringByAppendingFormat:@"&cond.page.pageIndex=%d", pageOfData];
    
    NSLog(@"url %@", url);
    NSLog(@"post %@", new_post);

    NSDictionary *msgDic = [AppDelegate connectToServer:new_post :url];
    if (msgDic != nil){
        NSInteger success = [(NSNumber *) [msgDic objectForKey:@"success"] integerValue];
        if (success == 1){
            NSDictionary *tempContracts = [msgDic objectForKey:@"message"];
            NSLog(@"tempNotices %@", tempContracts);
            self.contracts = [self.contracts arrayByAddingObjectsFromArray: [tempContracts objectForKey:@"contractList"]];
            if ([self.contracts count] >= self.numOfContract) _allLoaded = YES;
            else {
                _allLoaded = NO;
            }
            pageOfData ++;
        }
        else{
            networkProblem = YES;
        }
    }
    else{
        networkProblem = YES;
    }
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];
    [NSThread exit];
}

#pragma mark - loadmore delegate

- (void)doneLoadingTableViewData {
    NSLog(@"doneLoadingTableViewData");
	[_loadMoreFooterView pwLoadMoreTableDataSourceDidFinishedLoading];
    [self.lst reloadData];
}

- (BOOL)pwLoadMoreTableDataSourceAllLoaded {
    return _allLoaded;
}

- (BOOL)pwLoadMoreTableDataSourceIsLoading {
    return _datasourceIsLoading;
}

- (BOOL)networkProblem{
    NSLog(@"networkProblem");
    return networkProblem;
}

- (void)deleteLoadMore{
    NSLog(@"delete load more");
    self.lst.tableFooterView = nil;
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contracts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *forCal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 21)];
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    NSDictionary *tempNotice = self.contracts[indexPath.row];
    CGSize titleLabelSize = [[tempNotice objectForKey:@"projectName"] sizeWithFont:forCal.font
                                                                 constrainedToSize:maximumLabelSize lineBreakMode:forCal.lineBreakMode];
    return titleLabelSize.height + 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show normal result and searched result, include title and date.
    
    static NSString *CellIdentifier = @"Cell";
    CommonCustomCell *cell = [self.lst dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.title.text = [[self.contracts objectAtIndex:indexPath.row] objectForKey:@"projectName"];
    cell.text1.text = [[self.contracts objectAtIndex:indexPath.row] objectForKey:@"clientName"];
    cell.text2.text = [[self.contracts objectAtIndex:indexPath.row] objectForKey:@"departmentName"];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor orangeColor]];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

#pragma mark - select row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *contract = [self.contracts objectAtIndex:indexPath.row];
    NSString *sendPost = [[NSString alloc]init];
    if ([contractType isEqualToString:@"规划合同"]) {
        sendPost = [[NSString alloc] initWithFormat:@"contractId=%@&versionId=%@", [contract objectForKey:@"contractId"], [contract objectForKey:@"versionId"]];
    }
    else if ([contractType isEqualToString:@"招投标"]) {
        sendPost = [[NSString alloc] initWithFormat:@"tenderId=%@", [contract objectForKey:@"tenderId"]];
    }
    else{
        sendPost = [[NSString alloc] initWithFormat:@"buildingGardensContractId=%@", [contract objectForKey:@"buildingGardensContractId"]];
    }
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingDetail:) toTarget:self withObject:sendPost];
    [self.lst deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) loadingDetail:(NSString *)sendPost{
    NSURL *url = [[NSURL alloc] init];
    if ([contractType isEqualToString:@"规划合同"]) {
        url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0601/detail"]];
    }
    else if ([contractType isEqualToString:@"招投标"]) {
        url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0602/detail"]];
    }
    else{
        url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0603/detail"]];
    }
    NSDictionary *msgData = [AppDelegate connectToServer:sendPost :url];
    if (msgData != nil) {
        NSInteger success = [(NSNumber *) [msgData objectForKey:@"success"] integerValue];
        if(success == 1){
            self.contractDetail = [msgData objectForKey:@"message"];
            
            NSLog(@"detail %@", self.contractDetail);
            
            [self performSelectorOnMainThread:@selector(jumpToDetail) withObject:nil waitUntilDone:NO];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD show];
            [SVProgressHUD dismissWithError:@"请重新登陆"];
        }
    }
    [NSThread exit];
}

- (void)jumpToDetail{
    if ([contractType isEqualToString:@"规划合同"]) {
        [self performSegueWithIdentifier:@"contractDetail" sender:self];
    }
    else if ([contractType isEqualToString:@"招投标"]){
        [self performSegueWithIdentifier:@"contractDetail2" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"contractDetail3" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"contractDetail"]) {
        ContractDetailViewController *dvc = segue.destinationViewController;
        dvc.send_area = [self.contractDetail objectForKey:@"area"];
        dvc.send_areaUnit = [self.contractDetail objectForKey:@"areaUnit"];
        dvc.send_clientName = [self.contractDetail objectForKey:@"clientName"];
        dvc.send_contractBeginDate = [self.contractDetail objectForKey:@"contractBeginDate"];
        dvc.send_contractConName = [self.contractDetail objectForKey:@"contractConName"];

        dvc.send_contractEndDate = [self.contractDetail objectForKey:@"contractEndDate"];
        dvc.send_contractId = [self.contractDetail objectForKey:@"contractId"];
        dvc.send_contractMoney = [self.contractDetail objectForKey:@"contractMoney"];
        dvc.send_contractTypeName = [self.contractDetail objectForKey:@"contractTypeName"];
        dvc.send_department = [self.contractDetail objectForKey:@"department"];

        dvc.send_projectGradeName = [self.contractDetail objectForKey:@"projectGradeName"];
        dvc.send_projectLeadingOfficial = [self.contractDetail objectForKey:@"projectLeadingOfficial"];
        dvc.send_projectName = [self.contractDetail objectForKey:@"projectName"];
        dvc.send_projectTypeName = [self.contractDetail objectForKey:@"projectTypeName"];
    }
    else if ([contractType isEqualToString:@"招投标"]){
        ContractDetail2ViewController *dvc = segue.destinationViewController;
        dvc.send_department = [self.contractDetail objectForKey:@"department"];
        dvc.send_operator = [self.contractDetail objectForKey:@"operator"];
        dvc.send_operatorTelephone = [self.contractDetail objectForKey:@"operatorTelephone"];
        dvc.send_projectName = [self.contractDetail objectForKey:@"projectName"];
        dvc.send_projectScale = [self.contractDetail objectForKey:@"projectScale"];
        
        dvc.send_projectTypeName = [self.contractDetail objectForKey:@"projectTypeName"];
        dvc.send_signUpTimeIntervalBegin = [self.contractDetail objectForKey:@"signUpTimeIntervalBegin"];
        dvc.send_signUpTimeIntervalEnd = [self.contractDetail objectForKey:@"signUpTimeIntervalEnd"];
        dvc.send_tenderId = [self.contractDetail objectForKey:@"tenderId"];
        dvc.send_tenderResponsiblePerson = [self.contractDetail objectForKey:@"tenderResponsiblePerson"];
        
        dvc.send_tenderResult = [self.contractDetail objectForKey:@"tenderResult"];
        dvc.send_tenderStateName = [self.contractDetail objectForKey:@"tenderStateName"];
        dvc.send_tenderTypeName = [self.contractDetail objectForKey:@"tenderTypeName"];
        dvc.send_tendering = [self.contractDetail objectForKey:@"tendering"];
    }
    else{
        ContractDetail3ViewController *dvc = segue.destinationViewController;
        dvc.send_buildingGardensContractId = [self.contractDetail objectForKey:@"buildingGardensContractId"];
        dvc.send_clientName = [self.contractDetail objectForKey:@"clientName"];
        dvc.send_contractBeginDate = [self.contractDetail objectForKey:@"contractBeginDate"];
        dvc.send_contractConName = [self.contractDetail objectForKey:@"contractConName"];
        dvc.send_contractEndDate = [self.contractDetail objectForKey:@"contractEndDate"];
        
        dvc.send_contractMoney = [self.contractDetail objectForKey:@"contractMoney"];
        dvc.send_contractTypeName = [self.contractDetail objectForKey:@"contractTypeName"];
        dvc.send_department = [self.contractDetail objectForKey:@"department"];
        dvc.send_investedAmount = [self.contractDetail objectForKey:@"investedAmount"];
        dvc.send_projectLeadingOfficial = [self.contractDetail objectForKey:@"projectLeadingOfficial"];
        
        dvc.send_projectName = [self.contractDetail objectForKey:@"projectName"];
        dvc.send_projectScale = [self.contractDetail objectForKey:@"projectScale"];
        dvc.send_projectTypeName = [self.contractDetail objectForKey:@"projectTypeName"];
    }
    return;
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
