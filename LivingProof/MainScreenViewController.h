//
//  MainScreenViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenViewController : UIViewController <UIAlertViewDelegate> {
    IBOutlet UIButton *sortAge;
    IBOutlet UIButton *sortCategory;
    
    IBOutlet UILabel *loadingLabel;
    IBOutlet UIActivityIndicatorView *activityView;
    
    IBOutlet UIImageView *washULogo;
    
    UIColor *landscapeBackgroundImage;
    UIColor *portraitBackgroundImage;
    UIColor *lightPink;
    UIColor *strongPink;
    
    UITextView *myTextView ;
    UIAlertView *av;
}

-(IBAction)disclaimerPushed:(id)sender;
-(IBAction)privacyPushed:(id)sender;

@end
