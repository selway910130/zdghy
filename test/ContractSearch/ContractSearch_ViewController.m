//
//  ContractSearch_ViewController.m
//  test
//
//  Created by selway on 2013-07-25.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "ContractSearch_ViewController.h"
#import "labelButtonCell.h"
#import "labelTextfieldCell.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ContractListViewController.h"

@interface ContractSearch_ViewController ()

@property NSArray *lstOfTitle;
@property NSArray *lstOfContent;

@property NSArray *state;
@property NSArray *projectType;
@property NSArray *depart;

@property NSString *state_key;
@property NSString *projectType_key;
@property NSString *depart_key;

@property NSString *currentMenu;
@property NSInteger currentPage;

@property UITextField *name;
@property UITextField *authorizer;
@property UIButton *menuButton1;
@property UIButton *menuButton2;
@property UIButton *menuButton3;

@end

@implementation ContractSearch_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"/////////////////////////合同查询/////////////////////////");
    self.lstOfTitle = @[@"项目名称", @"状态", @"项目类型", @"委托方", @"部门"];
    
    pageOfContract ++;
    self.currentPage = pageOfContract;
    NSLog(@"page is %d", pageOfContract);
    self.state_key = [[NSString alloc]init];
    self.projectType_key = [[NSString alloc]init];
    self.depart_key = [[NSString alloc]init];
    
    NSURL *url = [[NSURL alloc]init];
    if (pageOfContract == 1) {
        url = [NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0601/index"]];
    }
    else if (pageOfContract == 2) {
        url = [NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0602/index"]];
    }
    else if (pageOfContract == 3) {
        url = [NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0603/index"]];
    }
    
    [SVProgressHUD showWithStatus:@"载入中"];
    [NSThread detachNewThreadSelector:@selector(loadingData:) toTarget:self withObject:url];
    
    self.name.delegate = self;
    self.authorizer.delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:singleTap];
}

// get select menu list item
- (void)loadingData:(NSURL *)url{
    @autoreleasepool {
    NSDictionary *tempLst;
    tempLst = [[AppDelegate connectToServer:nil :url] objectForKey:@"message"];
    if (tempLst != nil) {
        [SVProgressHUD dismiss];
        self.state = [tempLst objectForKey:@"state"];
        self.projectType = [tempLst objectForKey:@"projectType"];
        self.depart = [tempLst objectForKey:@"departs"];
    }
    }
}

#pragma table view date source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lstOfTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 3) {
        static NSString *CellIdentifier = @"labelTextfield";
        labelTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [self.lstOfTitle objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            self.name = cell.textfield;
            self.name.delegate = self;
            self.name.tag = 11;
        }
        else{
            self.authorizer = cell.textfield;
            self.authorizer.delegate = self;
            self.authorizer.tag = 12;
        }
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"labelButton";
        labelButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [self.lstOfTitle objectAtIndex:indexPath.row];
        if (indexPath.row == 1) {
            self.menuButton1 = cell.button;
            [self.menuButton1 addTarget:self action:@selector(_menuButton1) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (indexPath.row == 2){
            self.menuButton2 = cell.button;
            [self.menuButton2 addTarget:self action:@selector(_menuButton2) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            self.menuButton3 = cell.button;
            [self.menuButton3 addTarget:self action:@selector(_menuButton3) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}

#pragma mark - Menu

- (void)_menuButton1{
    [self creatSelectMenu:self.state :self.state_key :@"state"];
}

- (void)_menuButton2{
    [self creatSelectMenu:self.projectType :self.projectType_key :@"projectType"];
}

- (void)_menuButton3{
    [self creatSelectMenu:self.depart :self.depart_key :@"depart"];
}

#pragma mark - select menu

- (void)creatSelectMenu:(NSArray *)lst :(NSString *)key :(NSString *)typeOfButton{
    UIViewController *rootController = self.parentViewController.parentViewController.parentViewController;
    UIView *full = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    full.backgroundColor = [UIColor blackColor];
    full.alpha = 0.5f;
    full.tag = 1;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured2:)];
    [full addGestureRecognizer:singleTap];
    [rootController.view addSubview:full];
    selectMenu = [[SelectMenu alloc] initWithItems:lst :key :typeOfButton];
    selectMenu.SelectMenuDelegate = self;
    [selectMenu show];
    [rootController.view addSubview:selectMenu];
}

- (void)singleTapGestureCaptured2:(UITapGestureRecognizer *)gesture
{
    NSLog(@"disappear");
    [selectMenu dismiss];
}

- (void)dismissDarkenView{
    for (UIView *subview in [self.parentViewController.parentViewController.parentViewController.view subviews]) {
        if (subview.tag == 1) {
            [subview removeFromSuperview];
        }
    }
}

- (void)selectedItem:(NSDictionary *)item :(NSString *)typeOfButton{
    if ([typeOfButton isEqual:@"state"]) {
        self.menuButton1.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.menuButton1 setTitle:[@" " stringByAppendingString: [item objectForKey:@"value"]] forState:UIControlStateNormal];
        self.state_key = [item objectForKey:@"key"];
    }
    else if ([typeOfButton isEqual:@"projectType"]) {
        self.menuButton2.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.menuButton2 setTitle:[@" " stringByAppendingString: [item objectForKey:@"value"]] forState:UIControlStateNormal];
        self.projectType_key = [item objectForKey:@"key"];
    }
    else if ([typeOfButton isEqual:@"depart"]) {
        self.menuButton3.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.menuButton3 setTitle:[@" " stringByAppendingString: [item objectForKey:@"value"]] forState:UIControlStateNormal];
        self.depart_key = [item objectForKey:@"key"];
    }
}

#pragma mark - hide keyboard

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.name resignFirstResponder];
    [self.authorizer resignFirstResponder];
    [self moveBackView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self moveBackView];
    return NO;
}


#pragma move the screen to avoid block textfield

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 12) {
        int offset = 160 - (self.view.frame.size.height - 216.0);// the hight of keyboard is 216.
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        if(offset > 0)
        {
            CGRect rect = CGRectMake(320.0f * (self.currentPage - 1), -offset, width, height);
            self.view.frame = rect;
        }
        [UIView commitAnimations];
    }
}

- (void)moveBackView{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(320.0f * (self.currentPage - 1), 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma send request

- (IBAction)searchInfo:(id)sender {
    NSLog(@"current page %d", self.currentPage);
    
    NSURL *url = [[NSURL alloc]init];
    if (self.currentPage == 1) {
        url = [NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0601/search"]];
        contractType = @"规划合同";
    }
    else if (self.currentPage == 2) {
        url = [NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0602/search"]];
        contractType = @"招投标";
    }
    else if (self.currentPage == 3) {
        url = [NSURL URLWithString:[main_url stringByAppendingString:@"ad06/ad0603/search"]];
        contractType = @"建筑、园林";
    }
    if (self.currentPage == 2) {
        post = [NSString stringWithFormat:@"cond.cond.projectName=%@&cond.cond.state=%@&cond.cond.projectType=%@&cond.cond.tendering=%@&cond.cond.department=%@", self.name.text, self.state_key, self.projectType_key, self.authorizer.text, self.depart_key];
    }
    else{
        post = [NSString stringWithFormat:@"cond.cond.projectName=%@&cond.cond.state=%@&cond.cond.projectType=%@&cond.cond.clientName=%@&cond.cond.department=%@", self.name.text, self.state_key, self.projectType_key, self.authorizer.text, self.depart_key];
    }
    NSLog(@"sent to %@", url);
    [SVProgressHUD showWithStatus:@"搜索中"];
    [NSThread detachNewThreadSelector:@selector(jumpToNextView:) toTarget:self withObject:@[post, url]];
}

- (void)jumpToNextView:(NSArray *)lst{
    
    @autoreleasepool {
    NSDictionary *tempSearchResult = [AppDelegate connectToServer:lst[0] :lst[1]];
    
    if (tempSearchResult != nil) {
        NSInteger success = [(NSNumber *) [tempSearchResult objectForKey:@"success"] integerValue];
        if (success == 1) {
            NSLog(@"success");
            [SVProgressHUD dismiss];
            downloadDic = [tempSearchResult objectForKey:@"message"];
            [self.parentViewController performSegueWithIdentifier:@"showContract" sender:self];
        }
        else{
            [SVProgressHUD dismissWithError:@"请重新登陆"];
        }
    }
    }
}

@end
