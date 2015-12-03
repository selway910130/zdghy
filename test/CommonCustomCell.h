//
//  NoticeCell.h
//  test
//
//  Created by selway on 2013-06-17.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonCustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UIImageView *notation;


@end
