//
//  CustomLabelCell.m
//  test
//
//  Created by selway on 2013-07-17.
//  Copyright (c) 2013 selway. All rights reserved.
//

#import "CustomLabelCell.h"

@implementation CustomLabelCell

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
