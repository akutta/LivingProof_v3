//
//  CategoriesViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "YouTubeInterface.h"
#import "CustomTableViewCell.h"

@interface CategoriesViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, UITableViewDataSource, UITableViewDelegate>  {
    NSArray *_imageNames;
    NSArray *_categories;
    
    UITableView *_myTableView;
    AQGridView *_gridView;
    YouTubeInterface *youTube;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet AQGridView *gridView;

@end
