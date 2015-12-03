//
//  ContractDetail2ViewController.h
//  test
//
//  Created by selway on 2013-07-19.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractDetail2ViewController : UIViewController

@property (strong, nonatomic) NSString *send_department;
@property (strong, nonatomic) NSString *send_operator;
@property (strong, nonatomic) NSString *send_operatorTelephone;
@property (strong, nonatomic) NSString *send_projectName;
@property (strong, nonatomic) NSString *send_projectScale;

@property (strong, nonatomic) NSString *send_projectTypeName;
@property (strong, nonatomic) NSString *send_signUpTimeIntervalBegin;
@property (strong, nonatomic) NSString *send_signUpTimeIntervalEnd;
@property (strong, nonatomic) NSString *send_tenderId;
@property (strong, nonatomic) NSString *send_tenderResponsiblePerson;

@property (strong, nonatomic) NSString *send_tenderResult;
@property (strong, nonatomic) NSString *send_tenderStateName;
@property (strong, nonatomic) NSString *send_tenderTypeName;
@property (strong, nonatomic) NSString *send_tendering;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
- (IBAction)backButton:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *titleBar;

@end
