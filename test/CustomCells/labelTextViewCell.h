//
//  labelTextViewCell.h
//  test
//
//  Created by selway on 2013-07-27.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface labelTextViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
