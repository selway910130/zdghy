//
//  ContractSearch_ViewController.h
//  test
//
//  Created by selway on 2013-07-25.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectMenu.h"

NSDictionary *downloadDic;
NSString *contractType;
NSString *post;

@interface ContractSearch_ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SelectMenuDelegate>{
    SelectMenu *selectMenu;
}

- (IBAction)searchInfo:(id)sender;

@end
