//
//  VideoPlayerViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    IBOutlet UILabel *age;
    IBOutlet UILabel *name;
    IBOutlet UILabel *survivorshipLength;
    IBOutlet UILabel *treatment;
    IBOutlet UILabel *maritalStatus;
    IBOutlet UILabel *employmentStatus;
    IBOutlet UILabel *childrenStatus;
    IBOutlet UILabel *videoTitle;
    
    IBOutlet UILabel *ageLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *survivorshipLabel;
    IBOutlet UILabel *treatmentLabel;
    IBOutlet UILabel *maritalStatusLabel;
    IBOutlet UILabel *employentLabel;
    IBOutlet UILabel *childrenLabel;
    
    IBOutlet AQGridView* _gridView;
}

@property (retain, nonatomic) UIWebView* videoView;
@property (retain, nonatomic) IBOutlet AQGridView* gridView;
@property (retain, nonatomic) NSDictionary* curVideo;
@property (retain, nonatomic) NSArray* relatedVideos;
@end
