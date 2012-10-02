//
//  MyNavController.m
//  LivingProof
//
//  Created by Andrew Kutta on 10/1/12.
//
//

#import "MyNavController.h"

@interface MyNavController ()

@end

@implementation MyNavController

@synthesize landscapeOn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
// Annoying change in iOS6
//      Requires this in the NavigationController instead of the subviews ( top view )
//
- (NSUInteger)supportedInterfaceOrientations{
    
    NSLog(@"supported");
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        return UIInterfaceOrientationMaskAll;
    }
    
//    return UIInterfaceOrientationMaskPortrait;
    
    if (landscapeOn) {
        NSLog(@"landscape only");
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotate{
    UIInterfaceOrientation ori = [UIDevice currentDevice].orientation;
    
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        return YES;
    }
    
//    return NO;
    NSLog(@"should Autorotate");
    
    if (landscapeOn) {
        NSLog(@"landscape");
        if ( UIInterfaceOrientationIsLandscape(ori) )
            NSLog(@"YES");
        return UIInterfaceOrientationIsLandscape(ori);
    } else {
        return !UIInterfaceOrientationIsLandscape(ori);
    }
}

@end
