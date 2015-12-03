//
//  FirstViewController.m
//  test
//
//  Created by selway on 2013-07-03.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "CaseViewController.h"
#import "AppDelegate.h"
#import "CaseDetailViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "SVProgressHUD.h"
#import "TwoLabelsTitleCell.h"

@interface CaseViewController ()

@property (strong, nonatomic) NSArray *cases;
@property (strong, nonatomic) NSDictionary *caseDetail;

@property NSInteger numOfCases;

@property NSString *post;
@property NSURL *url;

@end

@implementation CaseViewController {
    int cellCount;
    int pageOfData;
    BOOL networkProblem;
}

@synthesize  searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"/////////////////////////案例查询/////////////////////////");
    CustomNavBar;
    networkProblem = NO;
    pageOfData = 0;
    self.searchBar.delegate = self;
    self.cases = [[NSMutableArray alloc]init];
    
    self.url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad02/ad0202/index"]];
    self.post = [[NSString alloc]initWithFormat:@"cond.page.pageIndex=%d", pageOfData];
    
    [NSThread detachNewThreadSelector:@selector(loadingData) toTarget:self withObject:nil];
}

- (void)loadingData{
    
    self.post = [self.post substringToIndex:[self.post length]-1];
    self.post = [self.post stringByAppendingFormat:@"%d", pageOfData];
    NSLog(@"post :%@", self.post);
    
    if (_loadMoreFooterView == nil) {
		PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
		view.delegate = self;
		_loadMoreFooterView = view;
	}
    self.tableView.tableFooterView = _loadMoreFooterView;
    
    NSDictionary *msgDic = [AppDelegate connectToServer:self.post :self.url];
    
    if (msgDic != nil){
        NSInteger success = [(NSNumber *) [msgDic objectForKey:@"success"] integerValue];
        if (success == 1){
            [SVProgressHUD dismiss];
            networkProblem = NO;
            NSDictionary *tempContacts = [msgDic objectForKey:@"message"];
            self.numOfCases = [[tempContacts objectForKey:@"caseCount"]intValue];
            self.cases = [self.cases arrayByAddingObjectsFromArray: [tempContacts objectForKey:@"caseList"]];
            
            if ([self.cases count] >= self.numOfCases) _allLoaded = YES;
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
    [self.tableView reloadData];
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
    self.tableView.tableFooterView = nil;
}

#pragma mark - search bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    UITextField *searchBarTextField = nil;
    for (UIView *subview in self.searchBar.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
    
    UIView *darkenView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)];
    darkenView.alpha = 0.75f;
    darkenView.backgroundColor = [UIColor blackColor];
    darkenView.tag = 1;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [darkenView addGestureRecognizer:singleTap];
    
    [self.view addSubview:darkenView];
    
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.searchBar resignFirstResponder];
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 1) {
            [subview removeFromSuperview];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1{
    [SVProgressHUD showWithStatus:@"搜索中"];
    [self.searchBar resignFirstResponder];
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 1) {
            [subview removeFromSuperview];
        }
    }
    [NSThread detachNewThreadSelector:@selector(filterContentForSearchText:) toTarget:self withObject:searchBar1.text];
    
}

- (void)filterContentForSearchText: (NSString *) searchText
{
    networkProblem = NO;
    pageOfData = 0;
    self.cases = [[NSArray alloc]init];
    
    if (_loadMoreFooterView == nil) {
		PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
		view.delegate = self;
		_loadMoreFooterView = view;
	}
    self.tableView.tableFooterView = _loadMoreFooterView;
    
    self.url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad02/ad0202/search"]];
    self.post = [[NSString alloc]initWithFormat:@"cond.cond.caseName=%@&cond.page.pageIndex=%d", searchText, pageOfData];
    NSLog(@"post %@", self.post);
    
    [self loadingData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cases count]; // normal # of rows.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *forCal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 21)];
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    NSDictionary *tempNotice = [self.cases objectAtIndex:indexPath.row];
    CGSize titleLabelSize = [[tempNotice objectForKey:@"caseName"] sizeWithFont:forCal.font constrainedToSize:maximumLabelSize lineBreakMode:forCal.lineBreakMode];
    if (titleLabelSize.height == 0) {
        return 41;
    }
    return titleLabelSize.height + 41;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show normal result and searched result, include title and date.
    
    static NSString *CellIdentifier = @"Cell";
    TwoLabelsTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.title.text = [[self.cases objectAtIndex:indexPath.row] objectForKey:@"caseName"];
    cell.content.text = [[self.cases objectAtIndex:indexPath.row] objectForKey:@"caseTypeName"];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor orangeColor]];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
    
    
}

#pragma mark - select row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempCase = [[NSDictionary alloc]init];
    tempCase = [self.cases objectAtIndex:indexPath.row];
    NSString *caseId = [tempCase objectForKey:@"caseId"];
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingDetail:) toTarget:self withObject:caseId];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) loadingDetail:(NSString *)sendId{
    NSString *tempStr = [main_url stringByAppendingString:@"ad02/ad0202/detail?caseId=%@"];
    NSString *urlStr = [[NSString alloc] initWithFormat:tempStr, sendId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url %@", url);
    NSDictionary *msgData = [AppDelegate connectToServer:nil :url];
    if (msgData != nil) {
        NSInteger success = [(NSNumber *) [msgData objectForKey:@"success"] integerValue];
        if(success == 1){
            self.caseDetail = [msgData objectForKey:@"message"];
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
    [self performSegueWithIdentifier:@"showCase" sender:self];
}
#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCase"]) {
        CaseDetailViewController *dvc = segue.destinationViewController;
        dvc.sendTitle = [self.caseDetail objectForKey:@"caseName"];
        dvc.sendType = [self.caseDetail objectForKey:@"caseTypeName"];
        dvc.sendContent = [self.caseDetail objectForKey:@"caseDescription"];
        dvc.sendImageLst = [self.caseDetail objectForKey:@"imageList"];
        return;
    }
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

@end
