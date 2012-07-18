//
//  AgesViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "YouTubeInterface.h"
#import "CustomTableViewCell.h"
//#import "Utilities.h"

@interface AgesViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, UITableViewDataSource, UITableViewDelegate> {
    NSArray *_ages;
    AQGridView *_gridView;
    UITableView *_myTableView;
    YouTubeInterface *youTube;    
}
@property (nonatomic, retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@end
