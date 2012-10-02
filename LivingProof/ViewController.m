//
//  ViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate - vc");
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"supportedInterfaceOrientations vc");
    if ( [[[UIDevice currentDevice] model] hasPrefix:@"iPad"] ) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
