//
//  CustomTableViewCell.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
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
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
    CGRect frame = self.imageView.frame;
    CGFloat aspectRatio = frame.size.width / frame.size.height;
    
    if ( frame.size.width < frame.size.height ) {
        frame.size.height = MAX_IMAGE_DIMENSION;
        frame.size.width = MAX_IMAGE_DIMENSION * aspectRatio;
        
        frame.origin.x = (MAX_IMAGE_DIMENSION - frame.size.width)/2;
    } else {
        frame.size.width = MAX_IMAGE_DIMENSION;
        frame.size.height = MAX_IMAGE_DIMENSION / aspectRatio;
        
        frame.origin.y = (MAX_IMAGE_DIMENSION - frame.size.height) / 2;
    }
  
    self.imageView.frame = frame;
//    self.imageView.frame = CGRectMake(0, 0, MAX_IMAGE_DIMENSION, MAX_IMAGE_DIMENSION);
    
    frame = self.textLabel.frame;
    frame.origin.x = MAX_IMAGE_DIMENSION + 5;
    self.textLabel.frame = frame;
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 3;
    self.textLabel.font = [UIFont systemFontOfSize:17.0];
}

@end
