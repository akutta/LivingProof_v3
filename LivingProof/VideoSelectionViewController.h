//
//  VideoSelectionViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "YouTubeInterface.h"

@interface VideoSelectionViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>  {
    YouTubeInterface *youTube;
    NSArray *videos;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) NSString *filter;
@property (nonatomic, retain) NSString *navBackText;



@end
