//
//  CustomCell.m
//  testSplitView
//
//  Created by philippe nougaillon on 05/02/13.
//  Copyright (c) 2013 philippe nougaillon. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:25]];
        //[self.titleLabel setNumberOfLines:2];
        //[self.subTitleLabel setFont:[UIFont fontWithName:@"Open Sans" size:17]];
        //[self.fieldOfServiceLabel setFont:[UIFont fontWithName:@"Open Sans" size:12]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
