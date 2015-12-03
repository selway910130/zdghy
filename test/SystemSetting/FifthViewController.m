//
//  FifthViewController.m
//  test
//
//  Created by selway on 2013-05-31.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "FifthViewController.h"
#import "Login.h"

@interface FifthViewController ()

@end

@implementation FifthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CustomNavBar;
    NSLog(@"/////////////////////////系统设置/////////////////////////");
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Login *dvc = segue.destinationViewController;
    dvc.logout = YES;
    return;
}
@end
