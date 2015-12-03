//
//  Login.h
//  test
//
//  Created by selway on 2013-05-29.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Login : UIViewController <UITextFieldDelegate>

// do not auto-login if user click logout before
@property BOOL logout;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

// change background for iphone5
@property (weak, nonatomic) IBOutlet UIButton *backgroundImage;

// remember the password
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton1;
- (IBAction)checkbox1:(id)sender;

// automatic login
@property (weak, nonatomic) IBOutlet UIButton *checkboxButton2;
- (IBAction)checkbox2:(id)sender;

// touch background to hide keyboard
- (IBAction)View_TouchDown:(id)sender;

// login button
- (IBAction)loginClicked:(id)sender;

@end