//
//  ThirdViewController.m
//  test
//
//  Created by selway on 2013-05-31.
//  Copyright (c) 2013 selway. All rights reserved.
//
// pretty much the same with FirstViewController

#import "AppDelegate.h"
#import "ContactViewController.h"
#import "ContactDetailViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "SVProgressHUD.h"

@interface ContactViewController ()
    
@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSDictionary *contactDetail;

@property NSInteger numOfContacts;

@property NSString *post;
@property NSURL *url;

@end

@implementation ContactViewController {
    int cellCount;
    int pageOfData;
    BOOL networkProblem;
}

@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"/////////////////////////通讯录页面/////////////////////////");
    CustomNavBar;
    networkProblem = NO;
    pageOfData = 0;
    self.searchBar.delegate = self;
    self.contacts = [[NSMutableArray alloc]init];
    
    self.url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad03/ad0302/index"]];
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
            self.numOfContacts = [[tempContacts objectForKey:@"addressCount"]intValue];
            self.contacts = [self.contacts arrayByAddingObjectsFromArray: [tempContacts objectForKey:@"addressList"]];
            
            if ([self.contacts count] >= self.numOfContacts) _allLoaded = YES;
            else {
                _allLoaded = NO;
            }
            pageOfData ++;
            NSLog(@"page %d", pageOfData);
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
    [NSThread detachNewThreadSelector:@selector(filterText:) toTarget:self withObject:searchBar1.text];
    
}

-(void)filterText:(NSString *)searchString
{
    
    if ([searchString isEqual: @""]) {
        [self filterContentForSearchText:nil :nil];
        return;
    }
    NSArray *arrayForStr = [searchString componentsSeparatedByString:@" "];
    if ([arrayForStr[0] isEqual: @""]) {
    }
    else if ([arrayForStr count] == 1){
        if ([self isPureInt:searchString]) [self filterContentForSearchText:nil :searchString];
        else [self filterContentForSearchText:searchString :nil];
    }
    else if ([arrayForStr count] == 2){
        if ([arrayForStr[1] isEqual: @""]) {
        }
        else{
            if ([self isPureInt: arrayForStr[0]]) [self filterContentForSearchText:arrayForStr[1] :arrayForStr[0]];
            else if ([self isPureInt: arrayForStr[1]]) [self filterContentForSearchText:arrayForStr[0] :arrayForStr[1]];
        }
    }
    else{
        [self filterContentForSearchText:nil :nil];
    }
}

- (void)filterContentForSearchText: (NSString *) searchName :(NSString *) searchNum
{
    networkProblem = NO;
    pageOfData = 0;
    self.contacts = [[NSArray alloc]init];
    
    self.url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad03/ad0302/search"]];
    if (searchName == nil && searchNum == nil) {
        self.post = @"cond.cond.mobilephone=&cond.cond.name=";
    }
    else if (searchName == nil) self.post = [@"cond.cond.mobilephone=" stringByAppendingString:searchNum];
    else if (searchNum == nil) self.post = [@"cond.cond.name=" stringByAppendingString:searchName];
    else {
        NSString *post_ = [[NSString alloc] initWithFormat: @"cond.cond.name=%@&cond.cond.mobilephone=%@", searchName, searchNum];
        self.post = post_;
    }
    self.post = [self.post stringByAppendingFormat:@"&cond.page.pageIndex=%d", pageOfData];
    
    [self loadingData];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts count]; // normal # of rows.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCellForContact *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.Name.text = [[self.contacts objectAtIndex:indexPath.row] objectForKey:@"personnelName"];
    cell.Phone_num.text = [[self.contacts objectAtIndex:indexPath.row] objectForKey:@"mobilePhone"];
    cell.ico.image = [UIImage imageNamed:@"ico_phone.png"];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor orangeColor]];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

#pragma mark - select row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *contact = [self.contacts objectAtIndex:indexPath.item];
    NSString *contactId = [contact objectForKey:@"personId"];
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingDetail:) toTarget:self withObject:contactId];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) loadingDetail:(NSString *)sendId{
    NSString *tempStr = [main_url stringByAppendingString:@"ad03/ad0302/detail?personId=%@"];
    NSString *urlStr = [[NSString alloc] initWithFormat:tempStr, sendId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"%@", url);
    
    NSDictionary *msgData = [AppDelegate connectToServer:nil :url];
    if (msgData != nil) {
        NSInteger success = [(NSNumber *) [msgData objectForKey:@"success"] integerValue];
        if(success == 1){
            self.contactDetail = [msgData objectForKey:@"message"];
            [self performSegueWithIdentifier:@"showContact" sender:self];
            [SVProgressHUD dismiss];
        }
        else{
            [SVProgressHUD show];
            [SVProgressHUD dismissWithError:@"请重新登陆"];
        }
    }
    [NSThread exit];
}


#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showContact"]) {
        ContactDetailViewController *dvc = segue.destinationViewController;
        dvc.sendName = [self.contactDetail objectForKey:@"personnel_name"];
        dvc.sendPosition = [self.contactDetail objectForKey:@"position"];
        dvc.sendDepartment = [self.contactDetail objectForKey:@"depart_name"];
        dvc.sendGroup = [self.contactDetail objectForKey:@"groupIds"];
        dvc.sendOffice_line = [self.contactDetail objectForKey:@"officePhone"];
        dvc.sendShort_num = [self.contactDetail objectForKey:@"innerPhone"];
        dvc.sendPhone = [self.contactDetail objectForKey:@"mobilephone"];
        dvc.sendEmail = [self.contactDetail objectForKey:@"email"];
        dvc.sendPlace = [self.contactDetail objectForKey:@"officeAddress"];
        return;
    }
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
