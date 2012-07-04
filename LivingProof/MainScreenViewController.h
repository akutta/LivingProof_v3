//
//  MainScreenViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenViewController : UIViewController {
    IBOutlet UIButton *sortAge;
    IBOutlet UIButton *sortCategory;
    
    IBOutlet UILabel *loadingLabel;
    IBOutlet UIActivityIndicatorView *activityView;
    
    UIColor *landscapeBackgroundImage;
    UIColor *portraitBackgroundImage;
    UIColor *lightPink;
    UIColor *strongPink;
}

@end
