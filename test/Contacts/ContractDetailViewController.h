//
//  ContractDetailViewController.h
//  test
//
//  Created by selway on 2013-07-16.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractDetailViewController : UIViewController

@property (strong, nonatomic) NSString *send_projectName;
@property (strong, nonatomic) NSString *send_contractId;
@property (strong, nonatomic) NSString *send_contractTypeName;
@property (strong, nonatomic) NSString *send_contractConName;
@property (strong, nonatomic) NSString *send_projectTypeName;

@property (strong, nonatomic) NSString *send_projectGradeName;
@property (strong, nonatomic) NSString *send_clientName;
@property (strong, nonatomic) NSString *send_area;
@property (strong, nonatomic) NSString *send_areaUnit;
@property (strong, nonatomic) NSString *send_contractBeginDate;

@property (strong, nonatomic) NSString *send_contractEndDate;
@property (strong, nonatomic) NSString *send_department;
@property (strong, nonatomic) NSString *send_projectLeadingOfficial;
@property (strong, nonatomic) NSString *send_contractMoney;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
- (IBAction)backButton:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;

@end
