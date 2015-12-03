//
//  FirstViewController.m
//  test
//
//  Created by selway on 2013-06-04.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "NoticeViewController.h"
#import "AppDelegate.h"
#import "NoticeDetailViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "SVProgressHUD.h"

@interface NoticeViewController ()

@property (strong, nonatomic) NSArray *notices;
@property (strong, nonatomic) NSDictionary *noticeDetail;

@property NSString *noticeState;
@property NSString *replySpecifyNotice;
@property NSInteger numOfNotices;
@property NSString *numOfUnread;

@property NSString *post;
@property NSURL *url;

@end

@implementation NoticeViewController {
    int pageOfData;
    BOOL networkProblem;
}

@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    CustomNavBar;
    networkProblem = NO;
    pageOfData = 0;
    self.searchBar.delegate = self;
    self.notices = [[NSMutableArray alloc]init];
    self.url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad01/ad0101/index"]];
    self.post = [[NSString alloc]initWithFormat:@"cond.page.pageIndex=%d", pageOfData];
    [NSThread detachNewThreadSelector:@selector(loadingData) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(getNumOfUnreadNotice) toTarget:self withObject:nil];
}

- (void)getNumOfUnreadNotice{
    NSURL *tempUrl = [NSURL URLWithString:[main_url stringByAppendingString:@"specifyNoticeCount"]];
    NSDictionary *tempBag =  [AppDelegate connectToServer:nil :tempUrl];
    if (tempBag != nil) {
        if ([[tempBag objectForKey:@"success"] intValue] == 1) {
            self.numOfUnread = [tempBag objectForKey:@"message"];
        }
    }
    [self performSelectorOnMainThread:@selector(readyToAdd) withObject:nil waitUntilDone:NO];
    [NSThread exit];
}

- (void)readyToAdd{
    if ([self.numOfUnread intValue] != 0) {
        [self addNotationOnTabBar];
    }
}

- (void)loadingData{    
    
    self.post = [self.post substringToIndex:[self.post length]-1];
    self.post = [self.post stringByAppendingFormat:@"%d", pageOfData];
    
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
            NSDictionary *tempNotices = [msgDic objectForKey:@"message"];
            self.notices = [self.notices arrayByAddingObjectsFromArray: [tempNotices objectForKey:@"noticeList"]];
            self.numOfNotices = [[tempNotices objectForKey:@"noticeCount"] intValue];
            if ([self.notices count] >= self.numOfNotices) _allLoaded = YES;
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

- (void)addNotationOnTabBar{
    for (UIScrollView *subview in self.parentViewController.parentViewController.view.subviews){
        if (subview.tag == 3) {
            UIImageView *notation = [[UIImageView alloc]initWithFrame:CGRectMake(40, 5, 20, 20)];
            notation.image = [UIImage imageNamed:@"bg_hint"];
            notation.tag = 4;
            UILabel *numOfNotation = [[UILabel alloc]init];
            numOfNotation.tag = 5;
            numOfNotation.text = self.numOfUnread;
            numOfNotation.font = [UIFont boldSystemFontOfSize:13];
            numOfNotation.frame = CGRectMake(24, 5, 50, 14);
            numOfNotation.textAlignment = NSTextAlignmentCenter;
            numOfNotation.backgroundColor = [UIColor clearColor];
            [subview addSubview:notation];
            [subview addSubview:numOfNotation];
        }
    }
}

#pragma mark - loadmore delegate

- (void)doneLoadingTableViewData {
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
    return networkProblem;
}

- (void)deleteLoadMore{
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
    self.notices = [[NSArray alloc]init];
    
    if (_loadMoreFooterView == nil) {
		PWLoadMoreTableFooterView *view = [[PWLoadMoreTableFooterView alloc] init];
		view.delegate = self;
		_loadMoreFooterView = view;
	}
    self.tableView.tableFooterView = _loadMoreFooterView;
    
    self.url=[NSURL URLWithString:[main_url stringByAppendingString:@"ad01/ad0101/search"]];
    self.post = [[NSString alloc]initWithFormat:@"cond.cond.title=%@&cond.page.pageIndex=%d", searchText, pageOfData];

    [self loadingData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notices count]; // normal # of rows.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *forCal = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 21)];
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    NSDictionary *tempNotice = [self.notices objectAtIndex:indexPath.row];
    CGSize titleLabelSize = [[tempNotice objectForKey:@"title"] sizeWithFont:forCal.font
                                                           constrainedToSize:maximumLabelSize
                                                               lineBreakMode:forCal.lineBreakMode];
    return titleLabelSize.height + 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show normal result and searched result, include title and date.
    
    static NSString *CellIdentifier = @"Cell";
    CommonCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIImage *notation = [[UIImage alloc]init];
    if ([[[self.notices objectAtIndex:indexPath.row] objectForKey:@"specifyNoticeState"] isEqualToString:@"0"]) {
        notation = [UIImage imageNamed:@"bullet_orange.png"];
    }
    
    cell.notation.image = notation;
    cell.notation.tag = 1;
    cell.title.text = [[self.notices objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.text1.text = [[self.notices objectAtIndex:indexPath.row] objectForKey:@"createUserName"];
    cell.text2.text = [[self.notices objectAtIndex:indexPath.row] objectForKey:@"pubTime"];

    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor orangeColor]];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

#pragma mark - select row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIImageView *subView in tempCell.contentView.subviews) {
        if (subView.tag == 1) {
            subView.image = [[UIImage alloc]init];
        }
    }
    
    NSDictionary *notice = [[NSDictionary alloc]init];
    notice = [self.notices objectAtIndex:indexPath.item];
    self.noticeState = [notice objectForKey:@"specifyNoticeState"];
    
    if ([self.noticeState isEqualToString:@"0"]) {
        
        for (UIScrollView *subview in self.parentViewController.parentViewController.view.subviews){
            if (subview.tag == 3) {
                NSLog(@"subview %@", subview.subviews);
                for (UILabel *notationLabel in subview.subviews)
                    if (notationLabel.tag == 5) {
                        NSLog(@"!!! %@", notationLabel);
                        if ([notationLabel.text intValue] != 1) {
                            NSLog(@"not 1");
                            notationLabel.text = [NSString stringWithFormat:@"%d", [self.numOfUnread intValue] - 1];
                        }
                        else{
                            for (UIView *subsubView in subview.subviews){
                                if (subsubView.tag == 4) {
                                    [subsubView removeFromSuperview];
                                }
                                else if (subsubView.tag == 5){
                                    [subsubView removeFromSuperview];
                                }
                            }
                        }
                    }
            }
        }
        
        NSArray *firstPart;
        NSArray *secondPart;
        NSRange tempRange;
        
        tempRange.location = 0;
        tempRange.length = indexPath.row;
        
        firstPart = [self.notices subarrayWithRange:tempRange];
        
        tempRange.location = indexPath.row + 1;
        tempRange.length = [self.notices count] - indexPath.row - 1;
        
        secondPart = [self.notices subarrayWithRange:tempRange];
        
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[notice objectForKey:@"createUserName"], @"createUserName", [notice objectForKey:@"noticeId"], @"noticeId", [notice objectForKey:@"pubTime"], @"pubTime", @"1", @"specifyNoticeState", [notice objectForKey:@"title"], @"title", nil];
        
        self.notices = [firstPart arrayByAddingObject:tempDic];
        self.notices = [self.notices arrayByAddingObjectsFromArray:secondPart];
    }
    
    NSString *noticeId = [notice objectForKey:@"noticeId"];
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingDetail:) toTarget:self withObject:noticeId];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) loadingDetail:(NSString *)sendId{
    NSString *tempStr = [main_url stringByAppendingString:@"ad01/ad0101/detail?noticeId=%@"];
    NSString *urlStr = [[NSString alloc] initWithFormat:tempStr, sendId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSDictionary *msgData = [AppDelegate connectToServer:nil :url];
    if (msgData != nil) {
        NSInteger success = [(NSNumber *) [msgData objectForKey:@"success"] integerValue];
        if(success == 1){
            self.noticeDetail = [msgData objectForKey:@"message"];
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
    [self performSegueWithIdentifier:@"showNotice" sender:self];
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNotice"]) {
        NoticeDetailViewController *dvc = segue.destinationViewController;
        dvc.sendTitle = [self.noticeDetail objectForKey:@"title"];
        dvc.sendAuthor = [self.noticeDetail objectForKey:@"personName"];
        dvc.sendDate = [self.noticeDetail objectForKey:@"pubTime"];
        dvc.sendType = [self.noticeDetail objectForKey:@"noticeType"];
        dvc.sendContent = [self.noticeDetail objectForKey:@"content"];
        dvc.sendState = self.noticeState;
        dvc.sendId = [self.noticeDetail objectForKey:@"noticeId"];
        
        if ([self.noticeState isEqualToString:@""]) {
            self.replySpecifyNotice = [self.noticeDetail objectForKey:@"replySpecifyNotice"];
            if (![self.replySpecifyNotice isEqualToString:@""]) {
                dvc.sendReplySpecifyNotice = self.replySpecifyNotice;
                NSDictionary *targetDetail = [self.noticeDetail objectForKey:@"noticeTargetInfos"][0];
                dvc.sendTargetPerson = [targetDetail objectForKey:@"personName"];
                dvc.sendTargetState = [targetDetail objectForKey:@"state"];
                dvc.sendTargetNote = [targetDetail objectForKey:@"note"];
            }
            else dvc.sendReplySpecifyNotice = @"";
        }
        else{
            dvc.sendReplyNote = [self.noticeDetail objectForKey:@"note"];
        }
        return;
    }
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
