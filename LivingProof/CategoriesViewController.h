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

@interface CategoriesViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>  {
    NSArray *_imageNames;
    NSArray *_categories;

    AQGridView *_gridView;
    //    Utilities *_utilities;
    YouTubeInterface *youTube;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;

@end
