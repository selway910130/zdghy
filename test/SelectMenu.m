//
//  SelectMenu.m
//  test
//
//  Created by selway on 2013-07-15.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "SelectMenu.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectMenu ()

@property NSArray *listOfItems;
@property NSString *currentSelected;
@property NSString *typeOfButton;

@end

@implementation SelectMenu

@synthesize SelectMenuDelegate = _SelectMenuDelegate;
@synthesize selectMenuTable;

- (id)initWithItems:(NSArray *)items :(NSString *)key :(NSString *)typeOfButton{
    
    self.currentSelected = key;
    self.typeOfButton = typeOfButton;
    NSDictionary *initItems = [[NSDictionary alloc]initWithObjectsAndKeys:@"", @"key", @"", @"value", nil];
    //items = @[initItems, initItems, initItems];
    self.listOfItems = [[NSArray alloc]initWithObjects:initItems, nil];
    self.listOfItems = [self.listOfItems arrayByAddingObjectsFromArray:items];
    
    int height = 0;
    int heightOfPos = 0;
    if ([items count] < 10) {
        height = [self.listOfItems count] * 44;
        heightOfPos = 230 - 22 * [self.listOfItems count];
    }
    else {
        height = 10 * 44;
        heightOfPos = 10;
    }
    
    self = [super initWithFrame:CGRectMake(20, heightOfPos, 280, height)];
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    self.selectMenuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 280, height)];

    [self addSubview:self.selectMenuTable];
    self.selectMenuTable.delegate = self;
    self.selectMenuTable.dataSource = self;
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listOfItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [[self.listOfItems objectAtIndex:indexPath.row] objectForKey:@"value"];
    //cell.imageView.image = [UIImage imageNamed:@"select.png"];
    UIImageView *select = [[UIImageView alloc]initWithFrame:CGRectMake(235, 0, 35, 44)];
    if ([[[self.listOfItems objectAtIndex:indexPath.row] objectForKey:@"key"] isEqual:self.currentSelected]) {
        select.image = [UIImage imageNamed:@"selected.png"];
    }
    else select.image = [UIImage imageNamed:@"select.png"];
    
    select.tag = 1;
    [cell addSubview:select];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor orangeColor]];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_SelectMenuDelegate &&
       [_SelectMenuDelegate respondsToSelector:@selector(selectedItem::)])
    {
        [_SelectMenuDelegate selectedItem:[self.listOfItems objectAtIndex:indexPath.row] :self.typeOfButton];
    }
    
    [self dismiss];
}

#pragma mark - animations

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [_SelectMenuDelegate dismissDarkenView];
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    //self.center = CGPointMake(20, 10);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}
@end
