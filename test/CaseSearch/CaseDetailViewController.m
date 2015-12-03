//
//  CaseDetailViewController.m
//  test
//
//  Created by selway on 2013-07-03.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "CustomTwoLabelsCell.h"
#import "CustomLabelCell.h"
#import "ImageCell.h"

@interface CaseDetailViewController ()

@property NSArray *lstOfTitle;
@property NSArray *lstOfContent;
@property CGFloat heightOfTable;
@property UIImage *image;
@property UIScrollView *scrollView;

@end

@implementation CaseDetailViewController

@synthesize scrollView_title;
@synthesize tableView;
@synthesize titleBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"/////////////////////////案例明细/////////////////////////");
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *imageNavBar = [UIImage imageNamed:@"head_bar_bg.png"];
    [self.titleBar setBackgroundImage:imageNavBar forBarMetrics:UIBarMetricsDefault];
    
    NSLog(@"image list %@", self.sendImageLst);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.case_title.text = self.sendTitle;
    
    if ([self.sendImageLst isEqualToArray:@[]]) {
        self.lstOfTitle = @[@"案例类型", @""];
        self.lstOfContent = @[self.sendType, self.sendContent];
    }
    else{
        self.lstOfTitle = @[@"案例类型", @"", @"image"];
        self.lstOfContent = @[self.sendType, self.sendContent, self.sendImageLst];
        NSString *tempURL = [[NSString alloc]initWithFormat:@"http://192.168.0.56:8088/zdghy/oa02/oa0202/downloadFile?fileId=%@&thumbImage=1", self.sendImageLst[0]];
        self.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempURL]]];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    CGSize titleLabelSize = [self.sendTitle sizeWithFont:self.case_title.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:self.case_title.lineBreakMode];
    if (titleLabelSize.height > 21.0f) {
        [self.case_title setFrame:CGRectMake(20, 1, self.case_title.frame.size.width, self.case_title.frame.size.height)];
    }
}

#pragma mark - table view date source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lstOfTitle count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return (280 * self.image.size.height)/self.image.size.width + 20;
    }
    CGSize maximumLabelSize = CGSizeMake(280,99999);
    CGSize titleLabelSize = [[self.lstOfContent objectAtIndex:indexPath.row] sizeWithFont:[UIFont systemFontOfSize:17]
                                             constrainedToSize:maximumLabelSize];
    self.heightOfTable = self.heightOfTable + titleLabelSize.height + 20;
    return titleLabelSize.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.lstOfTitle objectAtIndex:indexPath.row] isEqualToString:@"案例类型"]) {
        static NSString *CellIdentifier = @"Cell";
        CustomTwoLabelsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = [self.lstOfTitle objectAtIndex:indexPath.row];
        cell.content.text = [self.lstOfContent objectAtIndex:indexPath.row];
        return cell;
    }
    else if ([[self.lstOfTitle objectAtIndex:indexPath.row] isEqualToString:@"image"]){
        static NSString *CellIdentifier = @"ImageCell";
        ImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.img.image = self.image;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *CellIdentifier = @"Cell2";
    CustomLabelCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.content.text = [self.lstOfContent objectAtIndex:indexPath.row];
    return cell;
}

// when click the image, jump to full screen image view 

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showImage"]) {
        CaseDetailViewController *dvc = segue.destinationViewController;
        dvc.sendImageLst = self.sendImageLst;
        return;
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
