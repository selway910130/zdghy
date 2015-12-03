//
//  labelButtonCell.m
//  test
//
//  Created by selway on 2013-07-25.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "labelButtonCell.h"

@implementation labelButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
