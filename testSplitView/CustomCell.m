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
        // Initialization code
        //UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,10,95,25)];
        //[self.contentView addSubview:titleLabel];
        [self.titleLabel setFont:[UIFont fontWithName:@"Open Sans" size:18]];
        [self.subTitleLabel setFont:[UIFont fontWithName:@"Open Sans" size:13]];
        
        // Change la couleur de la cellule quand selectionnée
        
        //UIView *selectionColor = [[UIView alloc] init];
        //selectionColor.backgroundColor = [UIColor colorWithRed:(252/255.0) green:(243/255.0) blue:(193/255.0) alpha:1];
        //self.selectedBackgroundView = selectionColor;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
