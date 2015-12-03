//
//  Login.m
//  test
//
//  Created by selway on 2013-05-29.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "Login.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

@interface Login ()
@end

@implementation Login

@synthesize logout;

@synthesize username;
@synthesize password;
@synthesize checkboxButton1;
@synthesize checkboxButton2;
@synthesize backgroundImage;

extern NSString *main_url;

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // init
    main_url = [[NSString alloc]initWithFormat:@"http://192.168.0.56:8088/zdghy/"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.username.delegate = self;
    self.password.delegate = self;
    
    // set state for checkbox from defaults
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPassword"]){
        [checkboxButton1 setImage:[UIImage imageNamed:@"checked.png"] forState: UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"]){
        [checkboxButton2 setImage:[UIImage imageNamed:@"checked.png"] forState: UIControlStateNormal];
    }
    self.username.text = [defaults objectForKey:@"username"];
    self.password.text = [defaults objectForKey:@"password"];
    
    // change image for iphone5
    if (IS_IPHONE5) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"loggin_bg_long.jpg"] forState:UIControlStateNormal];
        [self.backgroundImage setImage:[UIImage imageNamed:@"loggin_bg_long.jpg"] forState:UIControlStateHighlighted];
    }
}

// auto-login, if the show this view by press logout, then stop login
- (void)viewDidAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"] && !logout){
        logout = NO;
        NSString *autoLogin =[[NSString alloc] initWithFormat:@"username=%@&password=%@&ismobile=y",[username text],[password text]];
        [SVProgressHUD showWithStatus:@"登录中"];
        [NSThread detachNewThreadSelector:@selector(loginToServer:) toTarget:self withObject:autoLogin];
    }
}

#pragma mark - check box

// remember password and account
- (IBAction)checkbox1:(id)sender{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPassword"]){
        [checkboxButton1 setImage:[UIImage imageNamed:@"checked.png"] forState: UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPassword"];
        //NSLog(@"Password remembered!");
    }
    else {
        [checkboxButton1 setImage: [UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"rememberPassword"];
        //NSLog(@"Password forgot!");
    }
}

// auto-login
- (IBAction)checkbox2:(id)sender{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"]){
        [checkboxButton2 setImage:[UIImage imageNamed:@"checked.png"] forState: UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLogin"];
        [checkboxButton1 setImage:[UIImage imageNamed:@"checked.png"] forState: UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPassword"];
        //NSLog(@"Password remembered!");
        //NSLog(@"auto login!");
    }
    else {
        [checkboxButton2 setImage: [UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
        //NSLog(@"do not auto login");
    }
}

#pragma mark - hide keyboard

// touch background to hide keyboard
- (IBAction)View_TouchDown:(id)sender
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [self moveBackView];
}

// press done to hide keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
        [self moveBackView];
    }
    return NO;
}

#pragma mark - move view

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);// the hight of keyboard is 216.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

// move the view back
- (void)moveBackView{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma mark - login to server

// pressed login button
- (IBAction)loginClicked:(id)sender {
    [SVProgressHUD showWithStatus:@"登录中"];
    if([[username text] isEqualToString:@""]) {
        [SVProgressHUD dismissWithError:@"请输入用户名"];
    }
    else if([[password text] isEqualToString:@""]){
        [SVProgressHUD dismissWithError:@"请输入密码"];
    }
    else {
        NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@&ismobile=y",[username text],[password text]];
        [NSThread detachNewThreadSelector:@selector(loginToServer:) toTarget:self withObject:post];
    }
}

// connect to server
- (void)loginToServer:(NSString *)post {
    @autoreleasepool { // auto release memory in different thread
        NSURL *url=[NSURL URLWithString:[main_url stringByAppendingString:@"login"]];
        NSDictionary *jsonData = [AppDelegate connectToServer:post :url];
        // login fail, jsonData will be empty
        if (jsonData != nil) {
            NSInteger success = [(NSNumber *) [jsonData objectForKey:@"success"] integerValue];
            if(success == 1)
            {
                [SVProgressHUD dismiss];
                // start from here, login success, remember username and password to defaults if checkbox is checked
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPassword"]) {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:self.username.text forKey:@"username"];
                    [defaults setObject:self.password.text forKey:@"password"];
                    [defaults synchronize];
                    //NSLog(@"Password remembered!");
                }
                else{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:nil forKey:@"username"];
                    [defaults setObject:nil forKey:@"password"];
                    [defaults synchronize];
                    //NSLog(@"Password forgot!");
                }
                [self performSegueWithIdentifier:@"jump" sender:self]; // jump to next view
            }
            else {
                [SVProgressHUD dismissWithError:@"用户名或密码错误"];
            }
        }
    }
}
@end
