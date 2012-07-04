//
//  VideoGridCell.h
//  LivingProof
//
//  Created by Andrew Kutta on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AQGridViewCell.h"

@interface VideoGridCell : AQGridViewCell 

@property (nonatomic, retain) UIImageView *mainView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) NSString* cellIdentifier;
@end
