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
#import "CustomTableViewCell.h"

@interface VideoSelectionViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, UITableViewDataSource, UITableViewDelegate>  {
    YouTubeInterface *youTube;
    NSArray *videos;
    UITableView *_myTableView;
    
}
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) NSString *filter;
@property (nonatomic, retain) NSString *navBackText;



@end
