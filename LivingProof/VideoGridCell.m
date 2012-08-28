//
//  VideoGridCell.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoGridCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation VideoGridCell

@synthesize imageView, title, mainView, cellIdentifier;

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)initFrame_iPad:(CGRect)frame {
    
    mainView = [[UIImageView alloc] initWithFrame:frame];
    [mainView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [mainView.layer setMasksToBounds:YES];
    [mainView.layer setBorderWidth:2.0];
    [mainView.layer setCornerRadius:5.0];
    
    mainView.image = [self imageWithColor:[UIColor whiteColor]];
    mainView.highlightedImage = [self imageWithColor:[UIColor colorWithRed:45.0/255.0 green:54.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setBorderWidth:2];
    [imageView.layer setCornerRadius:5.0];
    
    
    title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.highlightedTextColor = [UIColor whiteColor];
    
    // Modified by Drew
    if (cellIdentifier == @"VideoPlayerGridCellIdentifier") {
        title.font = [UIFont boldSystemFontOfSize:12.0];
    } else {
        title.font = [UIFont boldSystemFontOfSize:18.0]; // Increase font size
    }
    
    title.adjustsFontSizeToFitWidth = YES;              // Set to be multiline
    title.numberOfLines = 3;                           // Set to use as many lines as needed (3 max i think)
    title.textAlignment = UITextAlignmentCenter;       // Center the text
    title.minimumFontSize = 10.0;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.backgroundColor;
    imageView.backgroundColor = self.backgroundColor;
    title.backgroundColor = [UIColor whiteColor];
    
    [title.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [title.layer setMasksToBounds:YES];
    [title.layer setBorderWidth:2];
    [title.layer setCornerRadius:5.0];
    
    //self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.25];
    
    [mainView addSubview:imageView];
    [mainView addSubview:title];
    [self.contentView addSubview:mainView];
    

}

// TODO:
//      Modify to look good on iPhone
-(void)initFrame_iPhone:(CGRect)frame {
    // Replace
    [self initFrame_iPad:frame];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    if ( self ) {
        cellIdentifier = reuseIdentifier;
        
        if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPhone"] ) {
            [self initFrame_iPhone:frame];
        } else {
            [self initFrame_iPad:frame];
        }
        
        return self;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = imageView.image.size;
    CGFloat imageHeightToWidth = imageSize.height/imageSize.width;
    
    CGRect bounds;
    if ( cellIdentifier == @"VideoPlayerGridCellIdentifier" ) {
        bounds = CGRectInset(self.contentView.bounds, 5.0, 5.0);
    } else {
        bounds = CGRectInset(self.contentView.bounds, 10.0, 10.0);
    }
    bounds = CGRectInset(self.contentView.bounds, 10.0, 10.0);
    CGRect frame;
    [imageView sizeToFit];
    // get current frame
    frame = imageView.frame;
    
    CGFloat inset = ((self.contentView.bounds.size.width - bounds.size.width) / 2.0);
    
    frame.origin.x = inset;
    frame.origin.y = inset;
    frame.size.width = bounds.size.width;
    frame.size.height = frame.size.width * imageHeightToWidth;
    
    // update frame
    imageView.frame = frame;
    
    imageSize = imageView.image.size;
    
    [title sizeToFit];
    frame = title.frame;
    
    frame.size.width = bounds.size.width;
    frame.origin.y = imageView.frame.origin.y + imageView.frame.size.height + inset;
    frame.origin.x = inset;
    frame.size.width = bounds.size.width;
    frame.size.height = bounds.size.height - frame.origin.y + inset;
    
    title.frame = frame;
}


@end
