//
//  CustomTableViewCell.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewCell.h"
#define MAX_IMAGE_DIMENSION 100
@implementation CustomTableViewCell

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, MAX_IMAGE_DIMENSION, MAX_IMAGE_DIMENSION);
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = MAX_IMAGE_DIMENSION + 5;
    self.textLabel.frame = frame;
    
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.numberOfLines = 3;
    self.textLabel.font = [UIFont systemFontOfSize:17.0];
}

@end
